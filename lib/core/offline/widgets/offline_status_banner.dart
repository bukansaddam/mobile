import 'dart:async';

import 'package:akar/core/di/injection_container.dart' as di;
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/core/offline/widgets/pending_queue_bottom_sheet.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class OfflineStatusBanner extends StatefulWidget {
  final OfflineQueueLocalDatasource? queueDatasource;
  final OfflineSyncCoordinator? coordinator;
  final String Function()? userIdResolver;
  final List<ConnectivityResult>? initialConnectivity;
  final Stream<List<ConnectivityResult>>? connectivityStream;
  final EdgeInsetsGeometry margin;

  const OfflineStatusBanner({
    super.key,
    this.queueDatasource,
    this.coordinator,
    this.userIdResolver,
    this.initialConnectivity,
    this.connectivityStream,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  State<OfflineStatusBanner> createState() => _OfflineStatusBannerState();
}

class _OfflineStatusBannerState extends State<OfflineStatusBanner> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isOffline = false;
  List<OfflineQueueItem> _items = const [];

  OfflineQueueLocalDatasource? get _queue =>
      widget.queueDatasource ??
      (di.sl.isRegistered<OfflineQueueLocalDatasource>()
          ? di.sl<OfflineQueueLocalDatasource>()
          : null);

  OfflineSyncCoordinator? get _coordinator =>
      widget.coordinator ??
      (di.sl.isRegistered<OfflineSyncCoordinator>()
          ? di.sl<OfflineSyncCoordinator>()
          : null);

  String _resolveUserId() {
    if (widget.userIdResolver != null) return widget.userIdResolver!();
    if (di.sl.isRegistered<AuthLocalDatasource>()) {
      return di.sl<AuthLocalDatasource>().getCachedUserId() ?? '';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _queue?.revision.addListener(_loadQueue);
    _coordinator?.isSyncingNotifier.addListener(_onSyncChanged);

    if (widget.initialConnectivity != null) {
      _applyConnectivity(widget.initialConnectivity!);
    } else {
      _checkConnectivity();
    }

    try {
      _connectivitySub =
          (widget.connectivityStream ?? Connectivity().onConnectivityChanged)
              .listen(_applyConnectivity);
    } catch (_) {}

    _loadQueue();
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (mounted) _applyConnectivity(results);
    } catch (_) {}
  }

  void _applyConnectivity(List<ConnectivityResult> results) {
    final offline =
        results.isEmpty || results.every((r) => r == ConnectivityResult.none);
    if (mounted && offline != _isOffline) {
      setState(() => _isOffline = offline);
    }
  }

  void _onSyncChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadQueue() async {
    final queue = _queue;
    if (queue == null) return;
    final userId = _resolveUserId();
    if (userId.isEmpty) {
      if (mounted && _items.isNotEmpty) {
        setState(() => _items = const []);
      }
      return;
    }
    final pending = await queue.getPending(userId);
    if (mounted) {
      setState(() => _items = pending);
    }
  }

  @override
  void dispose() {
    _queue?.revision.removeListener(_loadQueue);
    _coordinator?.isSyncingNotifier.removeListener(_onSyncChanged);
    unawaited(_connectivitySub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSyncing = _coordinator?.isSyncingNotifier.value ?? false;
    final count = _items.length;

    if (!_isOffline && !isSyncing && count == 0) {
      return const SizedBox.shrink();
    }

    final colors = context.appColors;
    final hasPermanentError = _items.any(
      (item) => item.status == OfflineItemStatus.failedPermanent,
    );
    final hasApprovalNeeded = _items.any(
      (item) => item.status == OfflineItemStatus.waitingApproval,
    );

    final Color bgColor;
    final Color borderColor;
    final Color fgColor;
    final IconData icon;
    final String title;
    final String subtitle;

    if (_isOffline) {
      bgColor = colors.warningLight;
      borderColor = colors.warningBorder;
      fgColor = colors.warningDark;
      icon = Icons.cloud_off_rounded;
      title = 'Mode Offline Aktif';
      subtitle = count > 0
          ? '$count laporan menunggu koneksi untuk dikirim'
          : 'Laporan baru akan disimpan di perangkat';
    } else if (isSyncing) {
      bgColor = colors.primaryLight;
      borderColor = colors.primaryBorder;
      fgColor = colors.primaryDark;
      icon = Icons.sync_rounded;
      title = 'Menyinkronkan Antrean';
      subtitle = count > 0
          ? '$count laporan sedang dikirim ke server...'
          : 'Mengunggah laporan tertunda...';
    } else if (hasPermanentError) {
      bgColor = colors.errorLight;
      borderColor = colors.errorBorder;
      fgColor = colors.errorDark;
      icon = Icons.error_outline_rounded;
      title = 'Perlu Perhatian ($count Antrean)';
      subtitle = 'Ada laporan gagal terkirim. Ketuk untuk lihat detail.';
    } else if (hasApprovalNeeded) {
      bgColor = colors.warningLight;
      borderColor = colors.warningBorder;
      fgColor = colors.warningDark;
      icon = Icons.signal_cellular_alt_rounded;
      title = 'Persetujuan Video Diperlukan';
      subtitle = '$count laporan di antrean. Ketuk untuk kirim lewat seluler.';
    } else {
      bgColor = colors.primaryLight;
      borderColor = colors.primaryBorder;
      fgColor = colors.primaryDark;
      icon = Icons.cloud_upload_outlined;
      title = '$count Laporan Menunggu Kirim';
      subtitle = 'Ketuk untuk melihat atau mengirim antrean sekarang.';
    }

    return Padding(
      padding: widget.margin,
      child: Material(
        key: const Key('offline_status_banner'),
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => PendingQueueBottomSheet.show(
            context,
            queueDatasource: _queue,
            coordinator: _coordinator,
            userIdResolver: widget.userIdResolver,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isSyncing)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: fgColor,
                    ),
                  )
                else
                  Icon(icon, color: fgColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: fgColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(color: fgColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: fgColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
