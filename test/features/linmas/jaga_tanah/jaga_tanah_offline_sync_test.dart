import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/data/datasources/jaga_tanah_remote_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/data/sync/jaga_tanah_sync_handler.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/create_jaga_tanah_report_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockJagaTanahRemoteDatasource extends Fake
    implements JagaTanahRemoteDatasource {
  String? lastIdempotencyKey;
  bool? lastSkipMediaPreparation;
  String? lastTitle;
  List<File>? lastAttachments;
  Map<String, dynamic>? lastBoundaryGeojson;
  String? lastEstimatedArea;

  @override
  Future<ComplaintReportModel> createReport({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    required int categoryId,
    int? subCategoryId,
    String type = 'point',
    String? locationAccess,
    String? fieldCondition,
    String? dominantLandCover,
    String? visibleUsage,
    String? usageLevel,
    String? maintenanceStatus,
    String? conditionInfoSource,
    String? tenureInfoSource,
    String? possessionMarkers,
    String? conflictInfo,
    Map<String, dynamic>? boundaryGeojson,
    String? estimatedArea,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    lastTitle = title;
    lastAttachments = attachments;
    lastBoundaryGeojson = boundaryGeojson;
    lastEstimatedArea = estimatedArea;
    lastIdempotencyKey = idempotencyKey;
    lastSkipMediaPreparation = skipMediaPreparation;
    return ComplaintReportModel(
      id: 99,
      title: title,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      status: 'pending',
      reportedAt: DateTime.now(),
    );
  }

  @override
  Future<List<JagaTanahRegionEntity>> getProvinces({
    bool forceRefresh = false,
  }) async => const [];

  @override
  Future<List<JagaTanahRegionEntity>> getRegencies(
    String provinceId, {
    bool forceRefresh = false,
  }) async => const [];

  @override
  Future<List<JagaTanahRegionEntity>> getDistricts(
    String regencyId, {
    bool forceRefresh = false,
  }) async => const [];

  @override
  Future<List<JagaTanahRegionEntity>> getVillages(
    String districtId, {
    bool forceRefresh = false,
  }) async => const [];
}

class _MockJagaTanahRepository extends Fake implements JagaTanahRepository {
  Either<Failure, ComplaintReportEntity>? cannedCreateResult;

  @override
  Future<Either<Failure, ComplaintReportEntity>> createReport({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    required int categoryId,
    int? subCategoryId,
    String type = 'point',
    String? locationAccess,
    String? fieldCondition,
    String? dominantLandCover,
    String? visibleUsage,
    String? usageLevel,
    String? maintenanceStatus,
    String? conditionInfoSource,
    String? tenureInfoSource,
    String? possessionMarkers,
    String? conflictInfo,
    Map<String, dynamic>? boundaryGeojson,
    String? estimatedArea,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    return cannedCreateResult ??
        Right(
          ComplaintReportEntity(
            id: '99',
            title: title,
            description: description,
            address: address,
            latitude: latitude,
            longitude: longitude,
            status: 'pending',
            reportedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<Either<Failure, List<JagaTanahCategoryEntity>>> getCategories() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getProvinces({
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getRegencies(
    String provinceId, {
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getDistricts(
    String regencyId, {
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getVillages(
    String districtId, {
    bool forceRefresh = false,
  }) async => const Right([]);
}

class _MockAuthLocalDatasource extends Fake implements AuthLocalDatasource {
  @override
  String? getCachedUserId() => 'linmas-user-88';
}

void main() {
  late Directory tempDir;
  late OfflineQueueLocalDatasource queueDatasource;
  late _MockAuthLocalDatasource mockAuthDatasource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('jaga_tanah_offline_test_');
    queueDatasource = OfflineQueueLocalDatasource(
      rootDirectory: () async => tempDir,
    );
    mockAuthDatasource = _MockAuthLocalDatasource();
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('JagaTanahSyncHandler', () {
    test('handles OfflineFeatureType.jagaTanah and calls datasource with skipMediaPreparation true', () async {
      final mockDatasource = _MockJagaTanahRemoteDatasource();
      final handler = JagaTanahSyncHandler(remoteDatasource: mockDatasource);

      expect(handler.canHandle(OfflineFeatureType.jagaTanah), isTrue);
      expect(handler.canHandle(OfflineFeatureType.ronda), isFalse);

      final dummyPhoto = File('${tempDir.path}/test_photo.jpg')
        ..writeAsStringSync('binary_photo_content');

      final queueItem = OfflineQueueItem(
        id: 'queue-jt-1',
        userId: 'linmas-user-88',
        featureType: OfflineFeatureType.jagaTanah,
        clientRequestId: 'idemp-uuid-jt-123',
        payload: {
          'title': 'Laporan Tanah Kosong',
          'description': 'Tanah tidak terurus',
          'address': 'Lat: -7.123, Long: 112.456',
          'latitude': -7.123,
          'longitude': 112.456,
          'category_id': 2,
          'boundary_geojson': {
            'type': 'Polygon',
            'coordinates': [
              [
                [106.8477468, -6.1719736],
                [106.8483068, -6.1719736],
                [106.8483068, -6.1715336],
                [106.8477468, -6.1719736],
              ],
            ],
          },
          'estimated_area': '± 2.900 m²',
        },
        attachments: [
          OfflineAttachment(
            localPath: dummyPhoto.path,
            originalName: 'test_photo.jpg',
            fieldKey: 'attachments[]',
            mimeType: 'image/jpeg',
            sizeBytes: dummyPhoto.lengthSync(),
            isVideo: false,
          ),
        ],
        status: OfflineItemStatus.pending,
        retryCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await handler.sync(queueItem);

      expect(mockDatasource.lastIdempotencyKey, equals('idemp-uuid-jt-123'));
      expect(mockDatasource.lastSkipMediaPreparation, isTrue);
      expect(mockDatasource.lastTitle, equals('Laporan Tanah Kosong'));
      expect(mockDatasource.lastAttachments?.length, equals(1));
      expect(mockDatasource.lastBoundaryGeojson?['type'], equals('Polygon'));
      expect(mockDatasource.lastEstimatedArea, equals('± 2.900 m²'));
    });
  });

  group('CreateJagaTanahBloc offline queueing', () {
    test('enqueues report into OfflineQueueLocalDatasource when error is retryable', () async {
      final mockRepo = _MockJagaTanahRepository();
      mockRepo.cannedCreateResult = const Left(
        ServerFailure('Server 503 Unavailable', statusCode: 503),
      );

      final dummyPhoto = File('${tempDir.path}/report_photo.jpg')
        ..writeAsStringSync('sample photo bytes');

      final bloc = CreateJagaTanahBloc(
        createReport: CreateJagaTanahReportUsecase(mockRepo),
        getCategories: GetJagaTanahCategoriesUsecase(mockRepo),
        offlineQueue: queueDatasource,
        authLocalDatasource: mockAuthDatasource,
      );

      final doneFuture = bloc.stream
          .firstWhere(
            (state) =>
                state.submitStatus == CreateJagaTanahSubmitStatus.success,
          )
          .timeout(const Duration(seconds: 5));

      const sampleBoundary = {
        'type': 'Polygon',
        'coordinates': [
          [
            [112.5, -7.5],
            [112.501, -7.5],
            [112.501, -7.501],
            [112.5, -7.5],
          ],
        ],
      };
      bloc.add(
        SubmitJagaTanahReportEvent(
          title: 'Patroli Tanah Sengketa',
          description: 'Pemasangan plang sengketa',
          address: 'Lat: -7.500000, Long: 112.500000',
          latitude: -7.5,
          longitude: 112.5,
          attachments: [dummyPhoto],
          categoryId: 3,
          type: 'geometries',
          boundaryGeojson: sampleBoundary,
          estimatedArea: '± 2.900 m²',
        ),
      );

      final doneState = await doneFuture;

      expect(
        doneState.submitStatus,
        equals(CreateJagaTanahSubmitStatus.success),
      );
      expect(doneState.isQueuedOffline, isTrue);

      final pending = await queueDatasource.getPending('linmas-user-88');
      expect(pending.length, equals(1));
      expect(pending.first.featureType, equals(OfflineFeatureType.jagaTanah));
      expect(pending.first.payload['title'], equals('Patroli Tanah Sengketa'));
      expect(pending.first.payload['type'], equals('geometries'));
      expect(pending.first.payload['boundary_geojson'], equals(sampleBoundary));
      expect(pending.first.payload['estimated_area'], equals('± 2.900 m²'));
      expect(pending.first.attachments.length, equals(1));

      await bloc.close();
    });
  });
}
