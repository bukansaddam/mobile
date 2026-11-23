import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/linmas/ronda_malam/data/datasources/ronda_remote_datasource.dart';
import 'package:akar/features/linmas/ronda_malam/data/models/ronda_laporan_model.dart';
import 'package:akar/features/linmas/ronda_malam/data/sync/ronda_sync_handler.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';
import 'package:akar/features/linmas/ronda_malam/domain/repositories/ronda_repository.dart';
import 'package:akar/features/linmas/ronda_malam/domain/usecases/submit_ronda_laporan_usecase.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/bloc/ronda_bloc/ronda_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockRondaRemoteDatasource extends Fake implements RondaRemoteDatasource {
  RondaLaporanModel? lastModel;
  String? lastIdempotencyKey;
  bool shouldThrow = false;
  Exception? exceptionToThrow;

  @override
  Future<RondaLaporanModel> submitLaporan(
    RondaLaporanModel model, {
    String? idempotencyKey,
  }) async {
    lastModel = model;
    lastIdempotencyKey = idempotencyKey;
    if (shouldThrow) {
      throw exceptionToThrow ?? Exception('Network failure');
    }
    return model.copyWith(id: 'ronda-999');
  }
}

class _MockRondaRepository extends Fake implements RondaRepository {
  Either<Failure, RondaLaporanEntity>? cannedResult;

  @override
  Future<Either<Failure, RondaLaporanEntity>> submitLaporan(
    RondaLaporanEntity data, {
    String? idempotencyKey,
  }) async {
    return cannedResult ?? Right(data);
  }
}

class _MockAuthLocalDatasource extends Fake implements AuthLocalDatasource {
  @override
  String? getCachedUserId() => 'officer-42';
}

void main() {
  late Directory tempDir;
  late OfflineQueueLocalDatasource queueDatasource;
  late _MockAuthLocalDatasource mockAuthDatasource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ronda_offline_test_');
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

  group('RondaRemoteDatasource idempotency support', () {
    test('sends X-Idempotency-Key header when provided', () async {
      final mockDatasource = _MockRondaRemoteDatasource();
      const model = RondaLaporanModel(keterangan: 'Aman terkendali');

      await mockDatasource.submitLaporan(
        model,
        idempotencyKey: 'idemp-key-1234',
      );

      expect(mockDatasource.lastIdempotencyKey, equals('idemp-key-1234'));
      expect(mockDatasource.lastModel?.keterangan, equals('Aman terkendali'));
    });
  });

  group('RondaSyncHandler', () {
    test(
      'successfully syncs item and passes clientRequestId as idempotency key',
      () async {
        final mockDatasource = _MockRondaRemoteDatasource();
        final handler = RondaSyncHandler(remoteDatasource: mockDatasource);

        expect(handler.canHandle(OfflineFeatureType.ronda), isTrue);
        expect(handler.canHandle(OfflineFeatureType.jagaTanah), isFalse);

        const model = RondaLaporanModel(
          patrolTime: '23:30',
          keterangan: 'Patroli RT 02 aman',
        );

        final queueItem = OfflineQueueItem(
          id: 'queue-1',
          userId: 'officer-42',
          featureType: OfflineFeatureType.ronda,
          clientRequestId: 'req-uuid-abc',
          payload: model.toJson(),
          status: OfflineItemStatus.pending,
          retryCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await handler.sync(queueItem);

        expect(mockDatasource.lastIdempotencyKey, equals('req-uuid-abc'));
        expect(mockDatasource.lastModel?.patrolTime, equals('23:30'));
        expect(
          mockDatasource.lastModel?.keterangan,
          equals('Patroli RT 02 aman'),
        );
      },
    );
  });

  group('RondaBloc offline queue fallback', () {
    test('enqueues report into OfflineQueueLocalDatasource when failure is retryable', () async {
      final mockRepo = _MockRondaRepository();
      mockRepo.cannedResult = const Left(
        ServerFailure('Connection timed out', statusCode: 504),
      );

      final bloc = RondaBloc(
        submitRondaLaporanUsecase: SubmitRondaLaporanUsecase(mockRepo),
        offlineQueue: queueDatasource,
        authLocalDatasource: mockAuthDatasource,
      );

      bloc.add(
        const SubmitRondaLaporanEvent(
          RondaLaporanEntity(keterangan: 'Laporan ronda saat offline'),
        ),
      );

      await pumpEventQueue();
      await pumpEventQueue();
      await pumpEventQueue();

      // State is success (queued)
      expect(bloc.state, isA<RondaActionSuccess>());
      expect((bloc.state as RondaActionSuccess).message, contains('offline'));

      // Verify item stored in offline queue
      final pending = await queueDatasource.getPending('officer-42');
      expect(pending.length, equals(1));
      expect(pending.first.featureType, equals(OfflineFeatureType.ronda));
      expect(
        pending.first.payload['keterangan'],
        equals('Laporan ronda saat offline'),
      );

      await bloc.close();
    });
  });
}
