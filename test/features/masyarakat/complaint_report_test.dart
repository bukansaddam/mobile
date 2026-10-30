import 'dart:convert';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_mapper.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_complaint_detail_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_my_complaints_usecase.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/complaint_detail_bloc/complaint_detail_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

const _listResponse = {
  'success': true,
  'message': 'OK',
  'data': [
    {
      'id': 1256,
      'ticketNumber': 'PGD-2026-01256',
      'title': 'Rusak',
      'description': 'Testing saja',
      'status': 'new',
      'statusLabel': 'Baru',
      'statusColor': '#D3B04B',
      'category': null,
      'address': 'Jalan Keselamatan II No. 8',
      'latitude': -6.2206868,
      'longitude': 106.8487152,
      'reportedAt': '2026-10-30T06:54:47+00:00',
      'updatedAt': '2026-10-30T06:54:47+00:00',
      'attachments': [
        {
          'id': 2437,
          'file_name': 'foto.webp',
          'mime_type': 'image/webp',
          'size': 114052,
          'file_url': '/api/reports/attachments/2437/file',
        },
        {
          'id': 2438,
          'fileName': 'video.mp4',
          'mimeType': 'video/mp4',
          'sizeBytes': 1196843,
          'fileUrl': '/api/reports/attachments/2438/file',
        },
      ],
    },
  ],
  'meta': {'current_page': 1, 'last_page': 3, 'per_page': 1, 'total': 3},
};

const _detailResponse = {
  'success': true,
  'message': 'OK',
  'data': {
    'complaint': {
      'id': 1256,
      'ticketNumber': 'PGD-2026-01256',
      'title': 'Rusak',
      'description': 'Testing saja',
      'category': {'id': 6, 'label': 'Lingkungan', 'color': '#6B7280'},
      'status': 'in_progress',
      'statusLabel': 'Diproses',
      'reportedAt': '2026-10-30T06:54:47+00:00',
    },
    'location': {
      'address': 'Jalan Keselamatan II No. 8',
      'latitude': -6.2206868,
      'longitude': 106.8487152,
    },
    'attachments': [
      {
        'id': 2438,
        'file_name': 'video.mp4',
        'mime_type': 'video/mp4',
        'size': 1196843,
        'file_url': '/api/reports/attachments/2438/file',
      },
    ],
    'timeline': [
      {
        'id': '7786',
        'type': 'created',
        'actor': {'id': 504363, 'name': 'Budi Devano'},
        'createdAt': '2026-10-30T06:54:47+00:00',
        'description': 'Laporan dibuat.',
      },
    ],
    'sla': {
      'stageLabel': 'Verifikasi',
      'totalMinutes': 1440,
      'remainingMinutes': 1439,
      'progressPct': 0,
      'state': 'on_track',
    },
  },
};

class _FakeRepository implements ComplaintRepository {
  Either<Failure, ComplaintPaginatedEntity>? listResult;
  Either<Failure, ComplaintReportEntity>? detailResult;
  int listCalls = 0;

  ComplaintReportEntity report(String id) => ComplaintReportEntity(
    id: id,
    ticketNumber: 'PGD-$id',
    title: 'Aduan $id',
  );

  @override
  Future<Either<Failure, ComplaintPaginatedEntity>> getMyComplaints({
    int page = 1,
    int perPage = 15,
  }) async {
    listCalls++;
    return listResult ??
        Right(
          ComplaintPaginatedEntity(
            data: [report('$page')],
            currentPage: page,
            lastPage: 2,
            total: 2,
          ),
        );
  }

  @override
  Future<Either<Failure, ComplaintReportEntity>> getComplaintDetail(
    String id,
  ) async {
    return detailResult ?? Right(report(id));
  }

  @override
  Future<Either<Failure, ComplaintReportEntity>> createComplaint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('Parsing response aduan', () {
    test('list memetakan meta, lampiran absolut, dan status', () {
      final paginated = ComplaintPaginatedModel.fromJson(
        _listResponse,
      ).toDomain();

      expect(paginated.currentPage, 1);
      expect(paginated.lastPage, 3);
      expect(paginated.total, 3);
      expect(paginated.data.single.ticketNumber, 'PGD-2026-01256');

      final report = paginated.data.single;
      expect(
        report.attachments.first.url,
        'https://akaraslinmas.id/api/reports/attachments/2437/file',
      );
      expect(report.attachments.last.isVideo, isTrue);

      final item = ComplaintItem.fromReport(report);
      expect(item.id, 'PGD-2026-01256');
      expect(item.reportId, '1256');
      expect(item.category, 'Umum');
      expect(item.status, ComplaintStatus.received);
      expect(item.isVideoAttachment(item.attachments.last), isTrue);
      expect(item.isVideoAttachment(item.attachments.first), isFalse);
    });

    test('detail meratakan lokasi, timeline, dan SLA', () {
      final report = ComplaintReportDetailModel.fromJson(
        _detailResponse['data']! as Map<String, dynamic>,
      ).toDomain();

      expect(report.address, 'Jalan Keselamatan II No. 8');
      expect(report.latitude, -6.2206868);
      expect(report.category, 'Lingkungan');
      expect(report.sla?.stageLabel, 'Verifikasi');
      expect(report.sla?.remainingMinutes, 1439);
      expect(report.timeline.single.description, 'Laporan dibuat.');
      expect(report.timeline.single.actorName, 'Budi Devano');

      final item = ComplaintItem.fromReport(report);
      expect(item.status, ComplaintStatus.inProgress);
      expect(item.statusHistory.single.note, 'Laporan dibuat.');
      expect(
        item.attachments.single,
        endsWith('/api/reports/attachments/2438/file'),
      );
    });

    test('detail lengkap dari server terbaca tanpa error', () {
      final body =
          jsonDecode(
                File(
                  'test/features/masyarakat/fixtures/complaint_detail_completed.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;

      final report = ComplaintReportDetailModel.fromJson(
        body['data']! as Map<String, dynamic>,
      ).toDomain();

      expect(report.ticketNumber, 'PGD-2026-01251');
      expect(report.category, 'Bencana Alam');
      expect(report.status, 'completed');
      expect(report.address, 'Jl. Keselamatan 2 No.2 11');
      expect(report.latitude, -6.2216891);
      expect(report.sla, isNull);
      expect(report.timeline, hasLength(6));
      expect(report.timeline.first.actorName, 'Admin AKAR');
      expect(
        report.attachments.single.url,
        endsWith('/api/reports/attachments/2430/file'),
      );

      final item = ComplaintItem.fromReport(report);
      expect(item.reportId, '1251');
      expect(item.category, 'Bencana Alam');
      expect(item.status, ComplaintStatus.completed);
      expect(item.statusLabel, 'Selesai');
      expect(item.statusHistory, hasLength(6));
      expect(item.statusHistory.first.note, 'Laporan dibuat.');
      expect(
        item.statusHistory.last.note,
        'Laporan selesai ditindaklanjuti dan ditutup.',
      );
    });
  });

  group('Status dari kode list', () {
    test('new, verification, in_progress, completed, rejected terpetakan', () {
      expect(complaintStatusFromCode('new'), ComplaintStatus.received);
      expect(complaintStatusFromCode('verification'), ComplaintStatus.verified);
      expect(
        complaintStatusFromCode('in_progress'),
        ComplaintStatus.inProgress,
      );
      expect(complaintStatusFromCode('completed'), ComplaintStatus.completed);
      expect(complaintStatusFromCode('rejected'), ComplaintStatus.rejected);
    });
  });

  group('MyComplaintListBloc', () {
    test('memuat halaman pertama lalu menambah halaman berikutnya', () async {
      final repository = _FakeRepository();
      final bloc = MyComplaintListBloc(
        getMyComplaints: GetMyComplaintsUsecase(repository),
      );
      addTearDown(bloc.close);

      bloc.add(const FetchMyComplaintsEvent());
      var state = await bloc.stream.firstWhere(
        (state) => state.status == MyComplaintListStatus.loaded,
      );
      expect(state.items.length, 1);
      expect(state.hasReachedMax, isFalse);

      bloc.add(const LoadMoreMyComplaintsEvent());
      state = await bloc.stream.firstWhere(
        (state) => state.items.length == 2 && !state.isLoadingMore,
      );
      expect(state.currentPage, 2);
      expect(state.hasReachedMax, isTrue);
      expect(repository.listCalls, 2);
    });

    test('kegagalan memuat memancarkan status failure', () async {
      final repository = _FakeRepository()
        ..listResult = const Left(ServerFailure('Gagal memuat'));

      final bloc = MyComplaintListBloc(
        getMyComplaints: GetMyComplaintsUsecase(repository),
      );
      addTearDown(bloc.close);

      bloc.add(const FetchMyComplaintsEvent());
      final state = await bloc.stream.firstWhere(
        (state) => state.status == MyComplaintListStatus.failure,
      );
      expect(state.errorMessage, 'Gagal memuat');
    });
  });

  group('ComplaintDetailBloc', () {
    test('memuat detail berdasarkan id', () async {
      final repository = _FakeRepository();
      final bloc = ComplaintDetailBloc(
        getComplaintDetail: GetComplaintDetailUsecase(repository),
      );
      addTearDown(bloc.close);

      bloc.add(const FetchComplaintDetailEvent('1256'));
      final state = await bloc.stream.firstWhere(
        (state) => state is ComplaintDetailLoaded,
      );
      expect((state as ComplaintDetailLoaded).report.ticketNumber, 'PGD-1256');
    });

    test('kegagalan memuat detail memancarkan failure', () async {
      final repository = _FakeRepository()
        ..detailResult = const Left(ServerFailure('Tidak ditemukan'));

      final bloc = ComplaintDetailBloc(
        getComplaintDetail: GetComplaintDetailUsecase(repository),
      );
      addTearDown(bloc.close);

      bloc.add(const FetchComplaintDetailEvent('1'));
      final state = await bloc.stream.firstWhere(
        (state) => state is ComplaintDetailFailure,
      );
      expect((state as ComplaintDetailFailure).message, 'Tidak ditemukan');
    });
  });
}
