import 'dart:io';

import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/features/masyarakat/complaint/data/datasources/complaint_remote_datasource.dart';

class ComplaintSyncHandler implements OfflineSyncHandler {
  final ComplaintRemoteDatasource remoteDatasource;

  ComplaintSyncHandler({required this.remoteDatasource});

  @override
  bool canHandle(OfflineFeatureType type) =>
      type == OfflineFeatureType.complaint;

  @override
  Future<void> sync(OfflineQueueItem item) async {
    final payload = item.payload;
    final attachments = item.attachments
        .map((att) => File(att.localPath))
        .toList();

    await remoteDatasource.createComplaint(
      title: payload['title'] as String? ?? 'Pengaduan',
      description: payload['description'] as String? ?? '',
      address: payload['address'] as String? ?? '',
      latitude: (payload['latitude'] as num).toDouble(),
      longitude: (payload['longitude'] as num).toDouble(),
      attachments: attachments,
      category: payload['category'] as String?,
      categoryId: payload['category_id'] as int?,
      isInsidentil: payload['is_insidentil'] as bool? ?? false,
      idempotencyKey: item.clientRequestId,
      skipMediaPreparation: true,
    );
  }
}
