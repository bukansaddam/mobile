import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/features/linmas/ronda_malam/data/datasources/ronda_remote_datasource.dart';
import 'package:akar/features/linmas/ronda_malam/data/models/ronda_laporan_model.dart';

class RondaSyncHandler implements OfflineSyncHandler {
  final RondaRemoteDatasource remoteDatasource;

  RondaSyncHandler({required this.remoteDatasource});

  @override
  bool canHandle(OfflineFeatureType type) => type == OfflineFeatureType.ronda;

  @override
  Future<void> sync(OfflineQueueItem item) async {
    final model = RondaLaporanModel.fromJson(item.payload);
    await remoteDatasource.submitLaporan(
      model,
      idempotencyKey: item.clientRequestId,
    );
  }
}
