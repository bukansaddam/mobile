import 'dart:io';

import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/features/linmas/activation/data/datasources/activation_remote_datasource.dart';

class ActivationSyncHandler implements OfflineSyncHandler {
  final ActivationRemoteDatasource remoteDatasource;

  ActivationSyncHandler({required this.remoteDatasource});

  @override
  bool canHandle(OfflineFeatureType type) =>
      type == OfflineFeatureType.activation;

  @override
  Future<void> sync(OfflineQueueItem item) async {
    final payload = item.payload;
    final attachments = item.attachments
        .map((att) => File(att.localPath))
        .toList();

    await remoteDatasource.submitActivationReport(
      participantId: payload['participant_id'] as String? ?? '',
      attachments: attachments,
      notes: payload['notes'] as String?,
      receiverNik: payload['receiver_nik'] as String?,
      receiverName: payload['receiver_name'] as String?,
      idempotencyKey: item.clientRequestId,
      skipMediaPreparation: true,
    );
  }
}
