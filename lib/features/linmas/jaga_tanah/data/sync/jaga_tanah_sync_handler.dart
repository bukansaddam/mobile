import 'dart:io';

import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/features/linmas/jaga_tanah/data/datasources/jaga_tanah_remote_datasource.dart';

class JagaTanahSyncHandler implements OfflineSyncHandler {
  final JagaTanahRemoteDatasource remoteDatasource;

  JagaTanahSyncHandler({required this.remoteDatasource});

  @override
  bool canHandle(OfflineFeatureType type) =>
      type == OfflineFeatureType.jagaTanah;

  @override
  Future<void> sync(OfflineQueueItem item) async {
    final payload = item.payload;
    final attachments = item.attachments
        .map((att) => File(att.localPath))
        .toList();

    final rawBoundary = payload['boundary_geojson'];
    final boundaryGeojson = rawBoundary is Map
        ? Map<String, dynamic>.from(rawBoundary)
        : null;

    await remoteDatasource.createReport(
      title: payload['title'] as String? ?? 'Laporan Jaga Tanah',
      description: payload['description'] as String? ?? '',
      address: payload['address'] as String? ?? '',
      latitude: (payload['latitude'] as num).toDouble(),
      longitude: (payload['longitude'] as num).toDouble(),
      attachments: attachments,
      categoryId: payload['category_id'] as int? ?? 1,
      subCategoryId: payload['sub_category_id'] as int?,
      type: payload['type'] as String? ?? 'point',
      locationAccess: payload['location_access'] as String?,
      fieldCondition: payload['field_condition'] as String?,
      dominantLandCover: payload['dominant_land_cover'] as String?,
      visibleUsage: payload['visible_usage'] as String?,
      usageLevel: payload['usage_level'] as String?,
      maintenanceStatus: payload['maintenance_status'] as String?,
      conditionInfoSource: payload['condition_info_source'] as String?,
      tenureInfoSource: payload['tenure_info_source'] as String?,
      possessionMarkers: payload['possession_markers'] as String?,
      conflictInfo: payload['conflict_info'] as String?,
      boundaryGeojson: boundaryGeojson,
      estimatedArea: payload['estimated_area'] as String?,
      idempotencyKey: item.clientRequestId,
      skipMediaPreparation: true,
    );
  }
}
