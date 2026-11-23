import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/masyarakat/complaint/data/datasources/complaint_remote_datasource.dart';
import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/features/masyarakat/complaint/data/sync/complaint_sync_handler.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/create_complaint_usecase.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/create_complaint_bloc/create_complaint_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockComplaintRemoteDatasource extends Fake
    implements ComplaintRemoteDatasource {
  String? lastIdempotencyKey;
  bool? lastSkipMediaPreparation;
  String? lastTitle;
  List<File>? lastAttachments;

  @override
  Future<ComplaintReportModel> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    String? category,
    int? categoryId,
    bool isInsidentil = false,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    lastTitle = title;
    lastAttachments = attachments;
    lastIdempotencyKey = idempotencyKey;
    lastSkipMediaPreparation = skipMediaPreparation;
    return ComplaintReportModel(
      id: 101,
      title: title,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      status: 'pending',
      reportedAt: DateTime.now(),
    );
  }
}

class _MockComplaintRepository extends Fake implements ComplaintRepository {
  Either<Failure, ComplaintReportEntity>? cannedCreateResult;

  @override
  Future<Either<Failure, ComplaintReportEntity>> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    String? category,
    int? categoryId,
    bool isInsidentil = false,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    return cannedCreateResult ??
        Right(
          ComplaintReportEntity(
            id: '101',
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
}

class _MockAuthLocalDatasource extends Fake implements AuthLocalDatasource {
  @override
  String? getCachedUserId() => 'masyarakat-user-55';
}

void main() {
  late Directory tempDir;
  late OfflineQueueLocalDatasource queueDatasource;
  late _MockAuthLocalDatasource mockAuthDatasource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('complaint_offline_test_');
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

  group('ComplaintSyncHandler', () {
    test('handles OfflineFeatureType.pengaduan and calls datasource with skipMediaPreparation true', () async {
      final mockDatasource = _MockComplaintRemoteDatasource();
      final handler = ComplaintSyncHandler(remoteDatasource: mockDatasource);

      expect(handler.canHandle(OfflineFeatureType.complaint), isTrue);
      expect(handler.canHandle(OfflineFeatureType.ronda), isFalse);

      final dummyPhoto = File('${tempDir.path}/complaint_photo.jpg')
        ..writeAsStringSync('binary_photo_data');

      final queueItem = OfflineQueueItem(
        id: 'queue-cmp-1',
        userId: 'masyarakat-user-55',
        featureType: OfflineFeatureType.complaint,
        clientRequestId: 'idemp-uuid-cmp-777',
        payload: {
          'title': 'Jalan Berlubang Parah',
          'description': 'Bahaya bagi pengendara motor',
          'address': 'Jl. Raya No. 12',
          'latitude': -7.2,
          'longitude': 112.7,
          'category': 'Infrastruktur',
          'is_insidentil': false,
        },
        attachments: [
          OfflineAttachment(
            localPath: dummyPhoto.path,
            originalName: 'complaint_photo.jpg',
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

      expect(mockDatasource.lastIdempotencyKey, equals('idemp-uuid-cmp-777'));
      expect(mockDatasource.lastSkipMediaPreparation, isTrue);
      expect(mockDatasource.lastTitle, equals('Jalan Berlubang Parah'));
      expect(mockDatasource.lastAttachments?.length, equals(1));
    });
  });

  group('CreateComplaintBloc offline queueing', () {
    test('enqueues report into OfflineQueueLocalDatasource when error is retryable', () async {
      final mockRepo = _MockComplaintRepository();
      mockRepo.cannedCreateResult = const Left(
        ServerFailure('Connection refused / 503', statusCode: 503),
      );

      final dummyPhoto = File('${tempDir.path}/report_photo.jpg')
        ..writeAsStringSync('dummy bytes');

      final bloc = CreateComplaintBloc(
        createComplaint: CreateComplaintUsecase(mockRepo),
        offlineQueue: queueDatasource,
        authLocalDatasource: mockAuthDatasource,
      );

      final queuedFuture = bloc.stream
          .firstWhere((state) => state is CreateComplaintQueuedOffline)
          .timeout(const Duration(seconds: 5));

      bloc.add(
        SubmitComplaintEvent(
          title: 'Sampah Menumpuk di Pasar',
          description: 'Sudah 3 hari tidak diangkut',
          address: 'Pasar Baru',
          latitude: -7.25,
          longitude: 112.75,
          attachments: [dummyPhoto],
          category: 'Kebersihan',
        ),
      );

      final queuedState = await queuedFuture as CreateComplaintQueuedOffline;
      expect(queuedState.title, equals('Sampah Menumpuk di Pasar'));

      final pending = await queueDatasource.getPending('masyarakat-user-55');
      expect(pending.length, equals(1));
      expect(pending.first.featureType, equals(OfflineFeatureType.complaint));
      expect(
        pending.first.payload['title'],
        equals('Sampah Menumpuk di Pasar'),
      );
      expect(pending.first.attachments.length, equals(1));

      await bloc.close();
    });
  });
}
