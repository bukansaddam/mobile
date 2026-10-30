import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/features/masyarakat/complaint/data/datasources/complaint_remote_datasource.dart';
import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/features/masyarakat/complaint/data/repositories/complaint_repository_impl.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/create_complaint_usecase.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/create_complaint_bloc/create_complaint_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements ComplaintRepository {
  Either<Failure, ComplaintReportEntity> result = const Right(
    ComplaintReportEntity(id: '9', status: 'received'),
  );
  int calls = 0;

  @override
  Future<Either<Failure, ComplaintReportEntity>> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  }) async {
    calls++;
    return result;
  }
}

class _ThrowingDatasource implements ComplaintRemoteDatasource {
  @override
  Future<ComplaintReportModel> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  }) async {
    throw const FileSecurityException('Berkas tidak valid');
  }
}

void main() {
  late _FakeRepository repository;
  late CreateComplaintBloc bloc;

  setUp(() {
    repository = _FakeRepository();
    bloc = CreateComplaintBloc(
      createComplaint: CreateComplaintUsecase(repository),
    );
  });

  tearDown(() => bloc.close());

  SubmitComplaintEvent event() => const SubmitComplaintEvent(
    title: 'Jalan rusak',
    description: 'Jalan berlubang di depan sekolah',
    address: 'Jl. Merdeka No. 1',
    latitude: -6.2,
    longitude: 106.8,
    attachments: [],
  );

  test('pengaduan terkirim memancarkan success dengan data server', () async {
    bloc.add(event());

    final state = await bloc.stream.firstWhere(
      (state) => state is CreateComplaintSuccess,
    );
    expect((state as CreateComplaintSuccess).report.id, '9');
    expect(repository.calls, 1);
  });

  test('kegagalan server memancarkan failure dan pesannya', () async {
    repository.result = const Left(ServerFailure('Server sedang sibuk'));
    bloc.add(event());

    final state = await bloc.stream.firstWhere(
      (state) => state is CreateComplaintFailure,
    );
    expect((state as CreateComplaintFailure).message, 'Server sedang sibuk');
  });

  test('model membaca response kosong tanpa error', () {
    final model = ComplaintReportModel.fromJson(const {});
    expect(model.id, '');
    expect(model.ticketNumber, '');
    expect(model.createdAt, isNull);
  });

  test('model membaca response 201 tanpa wrapper data', () {
    final model = ComplaintReportModel.fromJson(const {
      'id': 1251,
      'ticketNumber': 'PGD-2026-01251',
      'message': 'Laporan berhasil dibuat.',
      'success': true,
    });

    expect(model.id, '1251');
    expect(model.ticketNumber, 'PGD-2026-01251');
  });

  test('berkas tidak valid dipetakan menjadi ValidationFailure', () async {
    final repository = ComplaintRepositoryImpl(
      remoteDatasource: _ThrowingDatasource(),
    );

    final result = await repository.createComplaint(
      title: 'Jalan rusak',
      description: 'Jalan berlubang',
      address: 'Jl. Merdeka No. 1',
      latitude: -6.2,
      longitude: 106.8,
      attachments: const [],
    );

    expect(result.left, isA<ValidationFailure>());
    expect(result.left.message, 'Berkas tidak valid');
  });
}
