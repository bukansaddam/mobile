import 'dart:io';

import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/features/linmas/bank_sampah/data/datasources/bank_sampah_remote_datasource.dart';

class BankSampahSyncHandler implements OfflineSyncHandler {
  final BankSampahRemoteDataSource remoteDataSource;

  BankSampahSyncHandler({required this.remoteDataSource});

  @override
  bool canHandle(OfflineFeatureType type) =>
      type == OfflineFeatureType.bankSampah;

  @override
  Future<void> sync(OfflineQueueItem item) async {
    final payload = item.payload;
    final photo = item.attachments.isNotEmpty
        ? File(item.attachments.first.localPath)
        : null;

    await remoteDataSource.addDeposit(
      bankId: (payload['bank_id'] as num).toInt(),
      wasteType: payload['waste_type'] as String? ?? 'Lainnya',
      weightKg: (payload['weight_kg'] as num).toDouble(),
      reportDate: payload['report_date'] as String? ?? '',
      notes: payload['notes'] as String?,
      photo: photo,
      idempotencyKey: item.clientRequestId,
      skipMediaPreparation: true,
    );
  }
}
