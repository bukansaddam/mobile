import 'dart:convert';
import 'dart:io';

import 'package:akar/core/offline/idempotency_key_generator.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:path_provider/path_provider.dart';

class OfflineQueueQuotaException implements Exception {
  final String message;
  const OfflineQueueQuotaException(this.message);

  @override
  String toString() => 'OfflineQueueQuotaException: $message';
}

class OfflineQueueLocalDatasource {
  static const String _folderName = 'offline_queue';
  static const String _indexName = 'index.json';
  static const int maxItemQuota = 50;
  static const int maxTotalMediaBytes = 250 * 1024 * 1024; // 250 MB

  final Future<Directory> Function() _rootDirectory;

  OfflineQueueLocalDatasource({Future<Directory> Function()? rootDirectory})
    : _rootDirectory = rootDirectory ?? getApplicationSupportDirectory;

  Future<Directory> _dir() async {
    final base = await _rootDirectory();
    final dir = Directory('${base.path}/$_folderName');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<List<OfflineQueueItem>> _readIndex() async {
    final baseDir = await _dir();
    final indexFile = File('${baseDir.path}/$_indexName');
    if (!indexFile.existsSync()) return [];

    try {
      final content = await indexFile.readAsString();
      if (content.trim().isEmpty) return [];
      final decoded = jsonDecode(content);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map(
            (json) =>
                OfflineQueueItem.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } catch (_) {
      // Safe recovery if index.json is corrupted
      return [];
    }
  }

  Future<void> _writeIndex(List<OfflineQueueItem> items) async {
    final baseDir = await _dir();
    final tmpFile = File('${baseDir.path}/$_indexName.tmp');
    final targetFile = File('${baseDir.path}/$_indexName');

    final jsonString = jsonEncode(items.map((i) => i.toJson()).toList());
    await tmpFile.writeAsString(jsonString, flush: true);
    if (targetFile.existsSync()) {
      await targetFile.delete();
    }
    await tmpFile.rename(targetFile.path);
  }

  Future<List<OfflineQueueItem>> getPending(String userId) async {
    final all = await _readIndex();
    final userItems = all.where((item) => item.userId == userId).toList();

    final valid = <OfflineQueueItem>[];
    var hasCleaned = false;

    for (final item in userItems) {
      final attachmentsIntact = item.attachments.every(
        (att) => File(att.localPath).existsSync(),
      );
      if (attachmentsIntact) {
        valid.add(item);
      } else {
        await _deleteItemFolder(item.id);
        all.removeWhere((i) => i.id == item.id);
        hasCleaned = true;
      }
    }

    if (hasCleaned) {
      await _writeIndex(all);
    }
    return valid;
  }

  Future<int> getPendingCount(String userId) async {
    final pending = await getPending(userId);
    return pending.length;
  }

  Future<OfflineQueueItem> enqueue({
    required String userId,
    required OfflineFeatureType featureType,
    required Map<String, dynamic> payload,
    List<File> attachments = const [],
    String? clientRequestId,
    String attachmentFieldKey = 'attachments[]',
  }) async {
    final all = await _readIndex();

    if (all.length >= maxItemQuota) {
      throw const OfflineQueueQuotaException(
        'Batas maksimal 50 antrean laporan tercapai. '
        'Sinkronkan laporan sebelum menambah laporan baru.',
      );
    }

    var totalCurrentBytes = 0;
    for (final item in all) {
      for (final att in item.attachments) {
        totalCurrentBytes += att.sizeBytes;
      }
    }

    var incomingBytes = 0;
    for (final file in attachments) {
      if (file.existsSync()) {
        incomingBytes += file.lengthSync();
      }
    }

    if (totalCurrentBytes + incomingBytes > maxTotalMediaBytes) {
      throw const OfflineQueueQuotaException(
        'Batas kapasitas media offline (250 MB) tercapai. '
        'Sinkronkan laporan sebelum menambah laporan baru.',
      );
    }

    final id =
        '${DateTime.now().millisecondsSinceEpoch}_${generateIdempotencyKey().substring(0, 8)}';
    final baseDir = await _dir();
    final itemDir = Directory('${baseDir.path}/$id');
    await itemDir.create(recursive: true);

    final savedAttachments = <OfflineAttachment>[];
    for (var i = 0; i < attachments.length; i++) {
      final src = attachments[i];
      if (!src.existsSync()) continue;
      final fileName = src.path.split('/').last;
      final targetPath = '${itemDir.path}/${i}_$fileName';
      final copied = await src.copy(targetPath);
      final size = copied.lengthSync();
      final isVideo = FileSecurityUtils.isVideoPath(copied.path);
      final mimeType = isVideo ? 'video/mp4' : 'image/webp';

      savedAttachments.add(
        OfflineAttachment(
          fieldKey: attachmentFieldKey,
          localPath: copied.path,
          originalName: fileName,
          mimeType: mimeType,
          sizeBytes: size,
          isVideo: isVideo,
          alreadyStamped: false,
        ),
      );
    }

    final hasLargeVideo = savedAttachments.any(
      (a) => a.isVideo && a.sizeBytes > 15 * 1024 * 1024,
    );

    final now = DateTime.now();
    final item = OfflineQueueItem(
      id: id,
      clientRequestId: clientRequestId ?? generateIdempotencyKey(),
      featureType: featureType,
      userId: userId,
      status: OfflineItemStatus.pending,
      payload: Map<String, dynamic>.from(payload),
      attachments: savedAttachments,
      requiresCellularConsent: hasLargeVideo,
      isUserApprovedOnCellular: false,
      createdAt: now,
      updatedAt: now,
    );

    all.add(item);
    await _writeIndex(all);
    return item;
  }

  Future<void> updateItem(OfflineQueueItem item) async {
    final all = await _readIndex();
    final idx = all.indexWhere((i) => i.id == item.id);
    if (idx != -1) {
      all[idx] = item.copyWith(updatedAt: DateTime.now());
      await _writeIndex(all);
    }
  }

  Future<void> remove(String id) async {
    await _deleteItemFolder(id);
    final all = await _readIndex();
    all.removeWhere((item) => item.id == id);
    await _writeIndex(all);
  }

  Future<void> clearForUser(String userId) async {
    final all = await _readIndex();
    final toRemove = all.where((item) => item.userId == userId).toList();
    for (final item in toRemove) {
      await _deleteItemFolder(item.id);
    }
    all.removeWhere((item) => item.userId == userId);
    await _writeIndex(all);
  }

  Future<void> clearAll() async {
    final baseDir = await _dir();
    if (baseDir.existsSync()) {
      await baseDir.delete(recursive: true);
    }
  }

  Future<void> _deleteItemFolder(String id) async {
    final baseDir = await _dir();
    final itemDir = Directory('${baseDir.path}/$id');
    if (itemDir.existsSync()) {
      await itemDir.delete(recursive: true);
    }
  }
}
