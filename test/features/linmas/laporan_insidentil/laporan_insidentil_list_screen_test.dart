import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/pages/laporan_insidentil_list_screen.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_category_option.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_incident_categories_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_my_complaints_usecase.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeComplaintRepository implements ComplaintRepository {
  Either<Failure, ComplaintPaginatedEntity> response = const Right(
    ComplaintPaginatedEntity(),
  );
  Either<Failure, List<ComplaintCategoryOption>> categoriesResponse =
      const Right([
        ComplaintCategoryOption(
          id: 1,
          code: 'bencana-alam',
          label: 'Bencana Alam',
        ),
        ComplaintCategoryOption(id: 2, code: 'lingkungan', label: 'Lingkungan'),
      ]);
  Completer<Either<Failure, ComplaintPaginatedEntity>>? pendingCompleter;
  int fetchCalls = 0;
  int categoryFetchCalls = 0;
  String? lastStatusFilter;
  String? lastCategoryFilter;

  @override
  Future<Either<Failure, ComplaintPaginatedEntity>> getMyComplaints({
    int page = 1,
    int perPage = 15,
    bool isInsidentil = false,
    String? status,
    String? category,
  }) async {
    fetchCalls++;
    lastStatusFilter = status;
    lastCategoryFilter = category;
    if (pendingCompleter != null) {
      return pendingCompleter!.future;
    }
    return response;
  }

  @override
  Future<Either<Failure, List<ComplaintCategoryOption>>>
  getIncidentCategories() async {
    categoryFetchCalls++;
    return categoriesResponse;
  }

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
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ComplaintReportEntity>> getComplaintDetail(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ComplaintPaginatedEntity>> getPublicComplaints({
    int page = 1,
    int perPage = 15,
    String? status,
    String? category,
    String? query,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  Widget buildTestApp({
    required MyComplaintListBloc bloc,
    bool showFilter = false,
  }) {
    final router = GoRouter(
      initialLocation: AppRouter.laporanInsidentilPath,
      routes: [
        GoRoute(
          path: AppRouter.laporanInsidentilPath,
          name: AppRouter.laporanInsidentil,
          builder: (context, state) => BlocProvider.value(
            value: bloc,
            child: LaporanInsidentilListScreen(showFilter: showFilter),
          ),
        ),
        GoRoute(
          path: AppRouter.tambahLaporanInsidentilPath,
          name: AppRouter.tambahLaporanInsidentil,
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Halaman Form Insidentil'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRouter.complaintDetailPath,
          name: AppRouter.complaintDetail,
          builder: (context, state) {
            final item = state.extra as ComplaintItem;
            return Scaffold(body: Center(child: Text('Detail ${item.id}')));
          },
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('menampilkan loading, empty, error+retry, search, dan FAB', (
    tester,
  ) async {
    final repository = _FakeComplaintRepository()
      ..pendingCompleter =
          Completer<Either<Failure, ComplaintPaginatedEntity>>();
    final bloc = MyComplaintListBloc(
      getMyComplaints: GetMyComplaintsUsecase(repository),
    );
    addTearDown(bloc.close);

    // 1. Loading state & filter hidden by default
    await tester.pumpWidget(buildTestApp(bloc: bloc));
    expect(find.byIcon(Icons.tune_rounded), findsNothing);
    bloc.add(const FetchMyComplaintsEvent(isInsidentil: true));
    await tester.pump();
    expect(find.text('Memuat laporan insidentil...'), findsOneWidget);

    // 2. Empty state
    repository.pendingCompleter!.complete(
      const Right(ComplaintPaginatedEntity()),
    );
    repository.pendingCompleter = null;
    await tester.pumpAndSettle();

    expect(find.text('Belum Ada Laporan Insidentil'), findsOneWidget);
    expect(find.text('Buat Laporan'), findsWidgets);

    // 3. Error state & retry
    repository.response = const Left(ServerFailure('Server tidak terjangkau'));
    bloc.add(const FetchMyComplaintsEvent(isInsidentil: true));
    await tester.pumpAndSettle();

    expect(find.text('Gagal Memuat Laporan'), findsOneWidget);
    expect(find.text('Server tidak terjangkau'), findsOneWidget);
    await tester.tap(find.text('Coba Lagi'));
    await tester.pumpAndSettle();
    expect(repository.fetchCalls, 3);

    // 4. Loaded list + breakpoints (320px & 800px) + 200% text zoom
    repository.response = Right(
      ComplaintPaginatedEntity(
        data: [
          ComplaintReportEntity(
            id: '1262',
            ticketNumber: 'PGD-2026-01262',
            title: 'Penggunaan lahan kas desa tidak sesuai peruntukan',
            category: 'Lingkungan',
            address: 'Jl. Tebet Timur Dalam II E No.10',
            status: 'in_progress',
            statusLabel: 'Sedang Diproses',
            reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ComplaintReportEntity(
            id: '1259',
            ticketNumber: 'PGD-2026-01259',
            title: 'Banjir',
            category: 'Lingkungan',
            address: 'Jalan Barkha No.9',
            status: 'verification',
            statusLabel: 'Menunggu Verifikasi',
            reportedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        currentPage: 1,
        lastPage: 1,
        total: 2,
      ),
    );
    bloc.add(const FetchMyComplaintsEvent(isInsidentil: true));
    await tester.pumpAndSettle();

    for (final size in const [Size(320, 640), Size(800, 1024)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    await tester.binding.setSurfaceSize(null);
    await tester.pumpAndSettle();

    // 5. Search & reset pencarian
    await tester.enterText(find.byType(TextField), 'banjir');
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pumpAndSettle();

    expect(find.text('Banjir'), findsOneWidget);
    expect(
      find.text('Penggunaan lahan kas desa tidak sesuai peruntukan'),
      findsNothing,
    );

    await tester.enterText(find.byType(TextField), 'tidak-ada-hasil');
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pumpAndSettle();

    expect(find.text('Laporan Tidak Ditemukan'), findsOneWidget);
    await tester.tap(find.text('Reset Pencarian'));
    await tester.pumpAndSettle();
    expect(find.text('Banjir'), findsOneWidget);

    // 6. FAB navigates to form route and refreshes when returning true
    final callsBeforeFab = repository.fetchCalls;
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Halaman Form Insidentil'), findsOneWidget);

    await tester.tap(find.text('Halaman Form Insidentil'));
    await tester.pumpAndSettle();
    expect(repository.fetchCalls, callsBeforeFab + 1);

    // 7. Tapping report card opens detail route
    await tester.tap(find.text('Banjir'));
    await tester.pumpAndSettle();
    expect(find.text('Detail PGD-2026-01259'), findsOneWidget);
  });

  testWidgets(
    'filter status dan kategori dinamis mengirim query ke server dan menampilkan badge + reset',
    (tester) async {
      final repository = _FakeComplaintRepository()
        ..response = Right(
          ComplaintPaginatedEntity(
            data: [
              ComplaintReportEntity(
                id: '1262',
                ticketNumber: 'PGD-2026-01262',
                title: 'Penggunaan lahan kas desa tidak sesuai peruntukan',
                category: 'Lingkungan',
                address: 'Jl. Tebet Timur Dalam II E No.10',
                status: 'in_progress',
                statusLabel: 'Sedang Diproses',
                reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
              ),
            ],
            currentPage: 1,
            lastPage: 1,
            total: 1,
          ),
        )
        ..categoriesResponse = const Left(
          ServerFailure('Gagal memuat kategori'),
        );

      final bloc = MyComplaintListBloc(
        getMyComplaints: GetMyComplaintsUsecase(repository),
        getIncidentCategories: GetIncidentCategoriesUsecase(repository),
      );
      addTearDown(bloc.close);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.binding.setSurfaceSize(const Size(320, 640));
      await tester.pumpWidget(buildTestApp(bloc: bloc, showFilter: true));
      bloc.add(const FetchMyComplaintsEvent(isInsidentil: true));
      await tester.pumpAndSettle();

      // Open filter sheet and verify dynamic category error + retry
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Filter Laporan'), findsOneWidget);
      expect(find.text('Gagal memuat kategori'), findsOneWidget);
      expect(find.text('Muat Ulang'), findsOneWidget);

      repository.categoriesResponse = const Right([
        ComplaintCategoryOption(
          id: 1,
          code: 'bencana-alam',
          label: 'Bencana Alam',
        ),
        ComplaintCategoryOption(id: 2, code: 'lingkungan', label: 'Lingkungan'),
      ]);
      await tester.ensureVisible(find.text('Muat Ulang'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Muat Ulang'));
      await tester.pumpAndSettle();

      expect(repository.categoryFetchCalls, 2);
      expect(find.text('Bencana Alam'), findsOneWidget);
      expect(find.text('Lingkungan'), findsWidgets);
      expect(tester.takeException(), isNull);

      // Select Status + Kategori and apply filter returning empty result
      await tester.ensureVisible(find.text('Sedang Diproses').last);
      await tester.tap(find.text('Sedang Diproses').last);
      await tester.ensureVisible(find.text('Lingkungan').last);
      await tester.tap(find.text('Lingkungan').last);
      await tester.pumpAndSettle();

      repository.response = const Right(ComplaintPaginatedEntity());
      await tester.tap(find.text('Terapkan Filter'));
      await tester.pumpAndSettle();

      expect(repository.lastStatusFilter, 'in_progress');
      expect(repository.lastCategoryFilter, 'lingkungan');
      expect(find.text('2'), findsOneWidget);
      expect(
        find.text('Tidak ada laporan yang sesuai dengan filter yang dipilih.'),
        findsOneWidget,
      );

      // Reset filter via empty state button and verify 800x1024 breakpoint
      repository.response = Right(
        ComplaintPaginatedEntity(
          data: [
            ComplaintReportEntity(
              id: '1259',
              ticketNumber: 'PGD-2026-01259',
              title: 'Banjir',
              category: 'Lingkungan',
              address: 'Jalan Barkha No.9',
              status: 'verification',
              statusLabel: 'Menunggu Verifikasi',
              reportedAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ],
          currentPage: 1,
          lastPage: 1,
          total: 1,
        ),
      );
      await tester.tap(find.text('Reset Filter'));
      await tester.pumpAndSettle();

      expect(repository.lastStatusFilter, isNull);
      expect(repository.lastCategoryFilter, isNull);
      expect(find.text('Banjir'), findsOneWidget);
      expect(find.text('2'), findsNothing);

      await tester.binding.setSurfaceSize(const Size(800, 1024));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('stepper detail pengaduan tampil 1 baris semua tanpa wrap', (
    tester,
  ) async {
    final item = ComplaintItem(
      id: 'PGD-2026-01259',
      title: 'Banjir',
      category: 'Lingkungan',
      dateTime: DateTime(2026, 11, 13, 10, 0),
      description: 'Genangan air di jalan utama.',
      location: 'Jalan Barkha No.9',
      attachments: const [],
      status: ComplaintStatus.verified,
      statusLabel: 'Menunggu Verifikasi',
      statusHistory: [
        ComplaintStatusHistory(
          status: ComplaintStatus.verified,
          dateTime: DateTime(2026, 11, 13, 10, 0),
          note: 'Laporan dibuat.',
        ),
      ],
      icon: Icons.park_rounded,
    );

    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final size in const [Size(320, 640), Size(360, 780)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(home: ComplaintDetailPage(item: item)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      for (final label in ['Diterima', 'Diverifikasi', 'Diproses', 'Selesai']) {
        final renderParagraph = tester.renderObject<RenderParagraph>(
          find.text(label),
        );
        expect(
          renderParagraph.didExceedMaxLines,
          isFalse,
          reason: 'Label $label tidak boleh melebihi 1 baris pada $size',
        );
        expect(
          renderParagraph.size.height,
          lessThan(20),
          reason: 'Label $label harus muat dalam 1 baris pada $size',
        );
      }
    }

    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
