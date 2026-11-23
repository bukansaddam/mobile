import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/linmas/activation/data/datasources/activation_pending_report_local_datasource.dart';
import 'package:akar/features/linmas/activation/data/datasources/activation_remote_datasource.dart';
import 'package:akar/features/linmas/activation/data/models/activation_run_model.dart';
import 'package:akar/features/linmas/activation/data/models/activation_submission_model.dart';
import 'package:akar/features/linmas/activation/data/sync/activation_sync_handler.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_entity.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';
import 'package:akar/features/linmas/activation/domain/repositories/activation_repository.dart';
import 'package:akar/features/linmas/activation/domain/usecases/get_activation_runs_usecase.dart';
import 'package:akar/features/linmas/activation/domain/usecases/get_activation_submissions_usecase.dart';
import 'package:akar/features/linmas/activation/domain/usecases/submit_activation_report_usecase.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockActivationRemoteDatasource extends Fake
    implements ActivationRemoteDatasource {
  String? lastParticipantId;
  List<File>? lastAttachments;
  String? lastNotes;
  String? lastReceiverNik;
  String? lastReceiverName;
  String? lastIdempotencyKey;
  bool? lastSkipMediaPreparation;

  @override
  Future<ActivationSubmissionResponseModel> submitActivationReport({
    required String participantId,
    required List<File> attachments,
    String? notes,
    String? receiverNik,
    String? receiverName,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    lastParticipantId = participantId;
    lastAttachments = attachments;
    lastNotes = notes;
    lastReceiverNik = receiverNik;
    lastReceiverName = receiverName;
    lastIdempotencyKey = idempotencyKey;
    lastSkipMediaPreparation = skipMediaPreparation;

    return const ActivationSubmissionResponseModel(
      success: true,
      data: ActivationSubmissionDataModel(id: 501),
    );
  }

  @override
  Future<ActivationRunResponseModel> getActivationRuns({
    int? page,
    int? perPage,
    String? status,
  }) async {
    return const ActivationRunResponseModel(success: true, data: []);
  }

  @override
  Future<List<ActivationSubmissionDataModel>> getActivationSubmissions({
    required String participantId,
  }) async {
    return const [];
  }
}

class _MockActivationRepository extends Fake implements ActivationRepository {
  Either<Failure, ActivationSubmissionEntity> submitResult = const Right(
    ActivationSubmissionEntity(id: 1),
  );
  String? lastIdempotencyKey;
  bool? lastSkipMediaPreparation;

  @override
  Future<Either<Failure, List<ActivationRunEntity>>> getActivationRuns({
    int? page,
    int? perPage,
    String? status,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<ActivationSubmissionEntity>>>
  getActivationSubmissions({required String participantId}) async =>
      const Right([]);

  @override
  Future<Either<Failure, ActivationSubmissionEntity>> submitActivationReport({
    required String participantId,
    required List<File> attachments,
    String? notes,
    String? receiverNik,
    String? receiverName,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    lastIdempotencyKey = idempotencyKey;
    lastSkipMediaPreparation = skipMediaPreparation;
    return submitResult;
  }
}

class _MockAuthLocalDatasource extends Fake implements AuthLocalDatasource {
  @override
  Future<UserModel?> getUser() async => const UserModel(id: 250420);

  @override
  String? getCachedUserId() => '250420';
}

void main() {
  late Directory tempDir;
  late OfflineQueueLocalDatasource sharedQueue;
  late ActivationPendingReportLocalDatasource legacyStore;
  late _MockAuthLocalDatasource mockAuth;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('activation_offline_test_');
    sharedQueue = OfflineQueueLocalDatasource(
      rootDirectory: () async => tempDir,
    );
    legacyStore = ActivationPendingReportLocalDatasource(
      rootDirectory: () async => tempDir,
    );
    mockAuth = _MockAuthLocalDatasource();
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Activation legacy migration', () {
    test('migrates items from pending_activation_reports to OfflineQueueLocalDatasource once', () async {
      final legacyPhoto = File('${tempDir.path}/legacy.jpg')
        ..writeAsStringSync('legacy_photo_bytes');

      await legacyStore.enqueue(
        userId: '250420',
        participantId: 'part-99',
        activityTitle: 'Distribusi Logistik',
        attachments: [legacyPhoto],
        notes: 'Catatan legacy',
        receiverNik: '3578010101900001',
        receiverName: 'Budi',
      );

      final migratedCount = await legacyStore.migrateToSharedQueue(sharedQueue);
      expect(migratedCount, equals(1));

      final remainingLegacy = await legacyStore.getPending();
      expect(remainingLegacy, isEmpty);

      final sharedItems = await sharedQueue.getPending('250420');
      expect(sharedItems.length, equals(1));
      final item = sharedItems.first;
      expect(item.featureType, equals(OfflineFeatureType.activation));
      expect(item.payload['participant_id'], equals('part-99'));
      expect(item.payload['activity_title'], equals('Distribusi Logistik'));
      expect(item.payload['notes'], equals('Catatan legacy'));
      expect(item.payload['receiver_nik'], equals('3578010101900001'));
      expect(item.payload['receiver_name'], equals('Budi'));
      expect(item.attachments.length, equals(1));
      expect(File(item.attachments.first.localPath).existsSync(), isTrue);

      // Second migration should be a no-op
      final secondRun = await legacyStore.migrateToSharedQueue(sharedQueue);
      expect(secondRun, equals(0));
      expect((await sharedQueue.getPending('250420')).length, equals(1));
    });
  });

  group('ActivationSyncHandler', () {
    test('handles OfflineFeatureType.activation and calls datasource with idempotencyKey & skipMediaPreparation true', () async {
      final mockDatasource = _MockActivationRemoteDatasource();
      final handler = ActivationSyncHandler(remoteDatasource: mockDatasource);

      expect(handler.canHandle(OfflineFeatureType.activation), isTrue);
      expect(handler.canHandle(OfflineFeatureType.ronda), isFalse);

      final photo = File('${tempDir.path}/act_photo.jpg')
        ..writeAsStringSync('binary_photo_data');

      final queueItem = OfflineQueueItem(
        id: 'queue-act-1',
        userId: '250420',
        featureType: OfflineFeatureType.activation,
        clientRequestId: 'idemp-uuid-act-888',
        payload: {
          'participant_id': 'part-123',
          'activity_title': 'Penyaluran Bantuan',
          'notes': 'Diserahkan lengkap',
          'receiver_nik': '3578000000000001',
          'receiver_name': 'Siti',
        },
        attachments: [
          OfflineAttachment(
            localPath: photo.path,
            originalName: 'act_photo.jpg',
            fieldKey: 'files[]',
            mimeType: 'image/jpeg',
            sizeBytes: photo.lengthSync(),
            isVideo: false,
          ),
        ],
        status: OfflineItemStatus.pending,
        retryCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await handler.sync(queueItem);

      expect(mockDatasource.lastParticipantId, equals('part-123'));
      expect(mockDatasource.lastNotes, equals('Diserahkan lengkap'));
      expect(mockDatasource.lastReceiverNik, equals('3578000000000001'));
      expect(mockDatasource.lastReceiverName, equals('Siti'));
      expect(mockDatasource.lastAttachments?.length, equals(1));
      expect(mockDatasource.lastIdempotencyKey, equals('idemp-uuid-act-888'));
      expect(mockDatasource.lastSkipMediaPreparation, isTrue);
    });
  });

  group('ActivationBloc with shared OfflineQueueLocalDatasource', () {
    test('enqueues failed submission into shared OfflineQueueLocalDatasource and exposes pendingReports', () async {
      final mockRepo = _MockActivationRepository();
      mockRepo.submitResult = const Left(
        NetworkFailure('Tidak ada koneksi internet'),
      );

      final photo = File('${tempDir.path}/bloc_act_photo.jpg')
        ..writeAsStringSync('photo bytes');

      final bloc = ActivationBloc(
        getActivationRunsUsecase: GetActivationRunsUsecase(mockRepo),
        getActivationSubmissionsUsecase: GetActivationSubmissionsUsecase(
          mockRepo,
        ),
        submitActivationReportUsecase: SubmitActivationReportUsecase(mockRepo),
        pendingReportStore: legacyStore,
        offlineQueue: sharedQueue,
        authLocalDatasource: mockAuth,
      );

      await bloc.stream
          .firstWhere((state) => !state.isLoading)
          .timeout(const Duration(seconds: 5));

      var queuedCalled = false;
      bloc.add(
        SubmitActivationReportApiEvent(
          participantId: 'part-77',
          activityTitle: 'Patroli Wilayah',
          attachments: [photo],
          notes: 'Aman terkendali',
          onQueued: () => queuedCalled = true,
        ),
      );

      await bloc.stream
          .firstWhere((state) => state.pendingReports.isNotEmpty)
          .timeout(const Duration(seconds: 5));

      expect(queuedCalled, isTrue);
      expect(bloc.state.pendingReports.length, equals(1));
      expect(bloc.state.pendingReports.first.participantId, equals('part-77'));

      final sharedItems = await sharedQueue.getPending('250420');
      expect(sharedItems.length, equals(1));
      expect(
        sharedItems.first.featureType,
        equals(OfflineFeatureType.activation),
      );
      expect(await legacyStore.getPending(), isEmpty);

      await bloc.close();
    });
  });
}
