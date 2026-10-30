import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/linmas/activation/data/datasources/activation_pending_report_local_datasource.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_entity.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';
import 'package:akar/features/linmas/activation/domain/repositories/activation_repository.dart';
import 'package:akar/features/linmas/activation/domain/usecases/get_activation_runs_usecase.dart';
import 'package:akar/features/linmas/activation/domain/usecases/get_activation_submissions_usecase.dart';
import 'package:akar/features/linmas/activation/domain/usecases/submit_activation_report_usecase.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements ActivationRepository {
  Either<Failure, ActivationSubmissionEntity> submitResult = const Right(
    ActivationSubmissionEntity(id: 1),
  );
  int submitCalls = 0;

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
  }) async {
    submitCalls++;
    return submitResult;
  }
}

class _FakeAuthLocal extends Fake implements AuthLocalDatasource {
  @override
  Future<UserModel?> getUser() async => const UserModel(id: 250420);
}

void main() {
  late Directory tempDir;
  late _FakeRepository repository;
  late ActivationPendingReportLocalDatasource store;
  late ActivationBloc bloc;
  late File attachment;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('activation_bloc_test');
    attachment = File('${tempDir.path}/bukti.webp')
      ..writeAsBytesSync([1, 2, 3]);

    repository = _FakeRepository();
    store = ActivationPendingReportLocalDatasource(
      rootDirectory: () async => tempDir,
    );
    bloc = ActivationBloc(
      getActivationRunsUsecase: GetActivationRunsUsecase(repository),
      getActivationSubmissionsUsecase: GetActivationSubmissionsUsecase(
        repository,
      ),
      submitActivationReportUsecase: SubmitActivationReportUsecase(repository),
      pendingReportStore: store,
      authLocalDatasource: _FakeAuthLocal(),
    );
    await bloc.stream
        .firstWhere((state) => !state.isLoading)
        .timeout(const Duration(seconds: 5));
  });

  tearDown(() async {
    await bloc.close();
    await tempDir.delete(recursive: true);
  });

  Future<ActivationState> waitFor(
    bool Function(ActivationState state) predicate,
  ) {
    return bloc.stream
        .firstWhere(predicate)
        .timeout(const Duration(seconds: 5));
  }

  SubmitActivationReportApiEvent submitEvent({
    String participantId = 'act-1',
    VoidCallback? onQueued,
    void Function(String message)? onError,
  }) {
    return SubmitActivationReportApiEvent(
      participantId: participantId,
      activityTitle: 'Sosialisasi',
      attachments: [attachment],
      onQueued: onQueued,
      onError: onError,
    );
  }

  test('kegagalan jaringan disimpan ke antrean', () async {
    repository.submitResult = const Left(ServerFailure('Koneksi timeout'));
    var queued = false;
    var errorCalled = false;

    bloc.add(
      submitEvent(
        onQueued: () => queued = true,
        onError: (_) => errorCalled = true,
      ),
    );
    await waitFor((state) => state.pendingReports.isNotEmpty);

    expect(queued, isTrue);
    expect(errorCalled, isFalse);
    expect(bloc.state.pendingReports.single.userId, '250420');
  });

  test('kegagalan validasi tidak diantrekan', () async {
    repository.submitResult = const Left(ValidationFailure('Berkas kosong'));
    var queued = false;
    final error = Completer<String>();

    bloc.add(
      submitEvent(onQueued: () => queued = true, onError: error.complete),
    );
    final message = await error.future.timeout(const Duration(seconds: 5));

    expect(queued, isFalse);
    expect(message, 'Berkas kosong');
    expect(bloc.state.pendingReports, isEmpty);
  });

  test('sync mengunggah antrean lalu menghapus berkasnya', () async {
    repository.submitResult = const Left(ServerFailure('Koneksi timeout'));
    bloc.add(submitEvent());
    await waitFor((state) => state.pendingReports.isNotEmpty);
    final queuedFile = File(
      bloc.state.pendingReports.single.attachmentPaths.single,
    );

    repository.submitResult = const Right(ActivationSubmissionEntity(id: 1));
    bloc.add(const SyncPendingReportsEvent());
    await waitFor(
      (state) => !state.isSyncingPending && state.pendingReports.isEmpty,
    );

    expect(queuedFile.existsSync(), isFalse);
  });

  test(
    'antrean milik akun lain tidak terlihat dan tidak ikut terkirim',
    () async {
      await store.enqueue(
        userId: '999',
        participantId: 'act-9',
        activityTitle: 'Punya akun lain',
        attachments: [attachment],
      );

      bloc.add(const LoadActivationActivitiesEvent());
      await bloc.stream
          .firstWhere((state) => !state.isLoading)
          .timeout(const Duration(seconds: 5));

      bloc.add(const SyncPendingReportsEvent());
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(bloc.state.pendingReports, isEmpty);
      expect(repository.submitCalls, 0);
      expect(await store.getPending(), hasLength(1));
    },
  );

  test('kirim ulang satu laporan hanya mengunggah laporan itu', () async {
    repository.submitResult = const Left(ServerFailure('Koneksi timeout'));
    bloc.add(submitEvent());
    await waitFor((state) => state.pendingReports.length == 1);
    bloc.add(submitEvent(participantId: 'act-2'));
    await waitFor((state) => state.pendingReports.length == 2);

    final target = bloc.state.pendingReports.first;
    repository.submitResult = const Right(ActivationSubmissionEntity(id: 1));
    repository.submitCalls = 0;
    bloc.add(SyncPendingReportsEvent(reportId: target.id));
    await waitFor(
      (state) => !state.isSyncingPending && state.pendingReports.length == 1,
    );

    expect(repository.submitCalls, 1);
    expect(bloc.state.pendingReports.single.id, isNot(target.id));
  });
}
