import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/core/utils/app_logger.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

abstract class OfflineSyncHandler {
  bool canHandle(OfflineFeatureType type);
  Future<void> sync(OfflineQueueItem item);
}

class OfflineSyncCoordinator {
  static const List<Duration> backoffDelays = [
    Duration(seconds: 15),
    Duration(minutes: 1),
    Duration(minutes: 3),
    Duration(minutes: 10),
    Duration(minutes: 30),
  ];
  static const int maxRetries = 5;

  final OfflineQueueLocalDatasource _queueDatasource;
  final String Function()? _currentUserIdResolver;
  final Future<List<ConnectivityResult>> Function() _connectivityChecker;
  final FirebaseNotificationService? _notificationService;

  final List<OfflineSyncHandler> _handlers = [];
  bool _isSyncing = false;
  final ValueNotifier<bool> isSyncingNotifier = ValueNotifier<bool>(false);
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool get isSyncing => _isSyncing;
  List<OfflineSyncHandler> get handlers => List.unmodifiable(_handlers);

  bool hasHandlerFor(OfflineFeatureType type) =>
      _handlers.any((h) => h.canHandle(type));

  OfflineSyncCoordinator({
    required this._queueDatasource,
    this._currentUserIdResolver,
    Future<List<ConnectivityResult>> Function()? connectivityChecker,
    Stream<List<ConnectivityResult>>? connectivityStream,
    this._notificationService,
  }) : _connectivityChecker =
           connectivityChecker ?? (() => Connectivity().checkConnectivity()) {
    if (connectivityStream != null) {
      _connectivitySubscription = connectivityStream.listen(
        _onConnectivityChanged,
      );
    }
  }

  void registerHandler(OfflineSyncHandler handler) {
    _handlers.add(handler);
  }

  void startListening(Stream<List<ConnectivityResult>> stream) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = stream.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasInternet = results.any(
      (r) => r != ConnectivityResult.none && r != ConnectivityResult.bluetooth,
    );
    if (hasInternet && !_isSyncing) {
      syncNow();
    }
  }

  Future<void> syncNow({bool includeCellularLargeVideos = false}) async {
    if (_isSyncing) return;
    _isSyncing = true;
    isSyncingNotifier.value = true;

    try {
      final connectivity = await _connectivityChecker();
      final isOffline =
          connectivity.isEmpty ||
          connectivity.every((r) => r == ConnectivityResult.none);
      if (isOffline) {
        return;
      }

      final isCellular = connectivity.contains(ConnectivityResult.mobile);
      final currentUserId = _currentUserIdResolver?.call();
      if (currentUserId == null || currentUserId.isEmpty) {
        return;
      }

      final pending = await _queueDatasource.getPending(currentUserId);
      if (pending.isEmpty) return;

      // Sort: Lightweight (JSON / non-large video) first, then large video (> 15 MB)
      final sorted = List<OfflineQueueItem>.from(pending)
        ..sort((a, b) {
          final aLarge = a.requiresCellularConsent;
          final bLarge = b.requiresCellularConsent;
          if (aLarge == bLarge) return a.createdAt.compareTo(b.createdAt);
          return aLarge ? 1 : -1;
        });

      final now = DateTime.now();

      for (final item in sorted) {
        // Skip items waiting for next retry backoff
        if (item.nextRetryAt != null && item.nextRetryAt!.isAfter(now)) {
          continue;
        }

        // Permanent failures require explicit user retry from UI
        if (item.status == OfflineItemStatus.failedPermanent) {
          continue;
        }

        // Cellular guard for video > 15 MB
        if (isCellular &&
            item.requiresCellularConsent &&
            !item.isUserApprovedOnCellular &&
            !includeCellularLargeVideos) {
          if (item.status != OfflineItemStatus.waitingApproval) {
            await _queueDatasource.updateItem(
              item.copyWith(status: OfflineItemStatus.waitingApproval),
            );
            _notifyCellularApproval(item);
          }
          continue;
        }

        final handler = _handlers.cast<OfflineSyncHandler?>().firstWhere(
          (h) => h?.canHandle(item.featureType) ?? false,
          orElse: () => null,
        );
        if (handler == null) {
          AppLogger.w(
            '[SYNC_COORD] No handler for feature ${item.featureType}',
          );
          continue;
        }

        await _syncItem(handler, item);
      }
    } catch (e, s) {
      AppLogger.e('[SYNC_COORD] Unexpected error during syncNow: $e', e, s);
    } finally {
      _isSyncing = false;
      isSyncingNotifier.value = false;
    }
  }

  Future<void> retryItem(
    OfflineQueueItem item, {
    bool approveCellular = false,
  }) async {
    await _queueDatasource.updateItem(
      item.copyWith(
        status: OfflineItemStatus.pending,
        clearNextRetryAt: true,
        clearLastError: true,
        retryCount: 0,
        isUserApprovedOnCellular: approveCellular
            ? true
            : item.isUserApprovedOnCellular,
      ),
    );
    await syncNow(includeCellularLargeVideos: approveCellular);
  }

  Future<void> _syncItem(
    OfflineSyncHandler handler,
    OfflineQueueItem item,
  ) async {
    try {
      await _queueDatasource.updateItem(
        item.copyWith(status: OfflineItemStatus.syncing),
      );

      // Best-effort reverse geocode & watermark preparation before sending
      final preparedItem = await _prepareItemMedia(item);

      await handler.sync(preparedItem);

      // Successfully synced: cleanup from local queue
      await _queueDatasource.remove(item.id);
      AppLogger.i(
        '[SYNC_COORD] Item ${item.id} successfully synced and removed.',
      );
    } catch (e, s) {
      AppLogger.w('[SYNC_COORD] Failed syncing item ${item.id}: $e', e, s);
      final failure = e is Failure ? e : ErrorUtils.toFailure(e);
      await _handleSyncFailure(item, failure);
    }
  }

  Future<OfflineQueueItem> _prepareItemMedia(OfflineQueueItem item) async {
    var updatedPayload = Map<String, dynamic>.from(item.payload);

    // 1. Best-effort reverse geocode if requested
    if (updatedPayload['needsReverseGeocode'] == true) {
      final lat = (updatedPayload['capturedLat'] as num?)?.toDouble();
      final lng = (updatedPayload['capturedLng'] as num?)?.toDouble();
      if (lat != null && lng != null) {
        try {
          final placemarks = await Geocoding()
              .placemarkFromCoordinates(lat, lng)
              .timeout(const Duration(seconds: 4));
          if (placemarks.isNotEmpty) {
            final p = placemarks.first;
            final address = [
              p.street,
              p.subLocality,
              p.locality,
              p.subAdministrativeArea,
            ].where((s) => s != null && s.trim().isNotEmpty).join(', ');
            if (address.isNotEmpty) {
              updatedPayload['address'] = address;
              updatedPayload['needsReverseGeocode'] = false;
            }
          }
        } catch (_) {
          // If reverse geocoding still fails, keep existing address fallback
        }
      }
    }

    // 2. Watermark images if not already stamped
    final updatedAttachments = <OfflineAttachment>[];
    for (final att in item.attachments) {
      if (att.isVideo || att.alreadyStamped) {
        updatedAttachments.add(att);
        continue;
      }

      final file = File(att.localPath);
      if (!file.existsSync()) {
        updatedAttachments.add(att);
        continue;
      }

      try {
        final capturedAt =
            DateTime.tryParse(updatedPayload['capturedAt'] ?? '') ??
            item.createdAt;
        final lat = (updatedPayload['capturedLat'] as num?)?.toDouble();
        final lng = (updatedPayload['capturedLng'] as num?)?.toDouble();
        final addr = updatedPayload['address'] as String?;

        final stamped = await ImageCompressHelper.compressToWebp(
          file,
          watermark: true,
          includeGeoStamp: true,
          stampTimestamp: capturedAt,
          stampLatitude: lat,
          stampLongitude: lng,
          stampAddress: addr,
          resolveDeviceLocationIfMissing: false,
        );

        updatedAttachments.add(
          att.copyWith(
            localPath: stamped.path,
            alreadyStamped: true,
            sizeBytes: stamped.existsSync()
                ? stamped.lengthSync()
                : att.sizeBytes,
          ),
        );
      } catch (_) {
        updatedAttachments.add(att);
      }
    }

    final prepared = item.copyWith(
      payload: updatedPayload,
      attachments: updatedAttachments,
    );
    await _queueDatasource.updateItem(prepared);
    return prepared;
  }

  Future<void> _handleSyncFailure(
    OfflineQueueItem item,
    Failure failure,
  ) async {
    final isPermanent =
        !failure.isRetryable ||
        failure is ValidationFailure ||
        failure.statusCode == 400 ||
        failure.statusCode == 422;

    if (isPermanent) {
      await _queueDatasource.updateItem(
        item.copyWith(
          status: OfflineItemStatus.failedPermanent,
          lastError: failure.message,
          lastStatusCode: failure.statusCode,
          nextRetryAt: null,
        ),
      );
      _notifyPermanentFailure(item, failure.message);
      return;
    }

    // Retryable failure (5xx, 408, 429, 409, or network disconnection)
    final nextRetryCount = item.retryCount + 1;
    if (nextRetryCount >= maxRetries) {
      await _queueDatasource.updateItem(
        item.copyWith(
          status: OfflineItemStatus.failedPermanent,
          retryCount: nextRetryCount,
          lastError:
              'Gagal setelah $maxRetries kali percobaan: ${failure.message}',
          lastStatusCode: failure.statusCode,
          nextRetryAt: null,
        ),
      );
      _notifyPermanentFailure(item, 'Batas maksimal percobaan ulang tercapai.');
      return;
    }

    final delay =
        backoffDelays[(nextRetryCount - 1).clamp(0, backoffDelays.length - 1)];
    final nextRetryAt = DateTime.now().add(delay);

    await _queueDatasource.updateItem(
      item.copyWith(
        status: OfflineItemStatus.failedRetryable,
        retryCount: nextRetryCount,
        nextRetryAt: nextRetryAt,
        lastError: failure.message,
        lastStatusCode: failure.statusCode,
      ),
    );
  }

  void _notifyCellularApproval(OfflineQueueItem item) {
    try {
      _notificationService?.showLocalNotification(
        id: item.id.hashCode,
        title: 'Laporan Tertunda di Jaringan Seluler',
        body: 'Video laporan memerlukan persetujuan untuk dikirim menggunakan data seluler.',
        data: {'kind': 'offline_queue', 'itemId': item.id},
      );
    } catch (_) {}
  }

  void _notifyPermanentFailure(OfflineQueueItem item, String message) {
    try {
      _notificationService?.showLocalNotification(
        id: item.id.hashCode,
        title: 'Gagal Mengirim Laporan',
        body: 'Laporan tidak dapat diproses: $message. Ketuk untuk memeriksa.',
        data: {'kind': 'offline_queue', 'itemId': item.id},
      );
    } catch (_) {}
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
