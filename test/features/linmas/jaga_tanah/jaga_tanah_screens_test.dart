import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/create_jaga_tanah_report_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_my_jaga_tanah_reports_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_list_bloc/jaga_tanah_list_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/create_jaga_tanah_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_list_screen.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_category_sheet.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeJagaTanahRepository implements JagaTanahRepository {
  Either<Failure, ComplaintPaginatedEntity> listResponse = const Right(
    ComplaintPaginatedEntity(),
  );
  Either<Failure, List<JagaTanahCategoryEntity>> categoriesResponse =
      const Right([
        JagaTanahCategoryEntity(
          id: 20,
          code: 'tanah_kas_desa',
          label: 'Tanah Kas Desa',
          sortOrder: 1,
        ),
        JagaTanahCategoryEntity(
          id: 21,
          code: 'tanah_pemda',
          label: 'Tanah Pemda',
          sortOrder: 2,
          children: [
            JagaTanahCategoryEntity(
              id: 22,
              code: 'tanah_pemda_kabupaten_kota',
              label: 'Kabupaten/Kota',
              parentId: 21,
              sortOrder: 1,
            ),
            JagaTanahCategoryEntity(
              id: 23,
              code: 'tanah_pemda_provinsi',
              label: 'Provinsi',
              parentId: 21,
              sortOrder: 2,
            ),
            JagaTanahCategoryEntity(
              id: 24,
              code: 'tanah_pemda_kecamatan',
              label: 'Kecamatan',
              parentId: 21,
              sortOrder: 3,
            ),
          ],
        ),
      ]);
  Completer<Either<Failure, ComplaintPaginatedEntity>>? pendingCompleter;
  int fetchCalls = 0;
  int categoryCalls = 0;
  String? lastStatusFilter;
  String? lastCategoryFilter;

  @override
  Future<Either<Failure, ComplaintPaginatedEntity>> getMyReports({
    int page = 1,
    int perPage = 20,
    String? status,
    String? category,
  }) async {
    fetchCalls++;
    lastStatusFilter = status;
    lastCategoryFilter = category;
    if (pendingCompleter != null) {
      return pendingCompleter!.future;
    }
    return listResponse;
  }

  @override
  Future<Either<Failure, List<JagaTanahCategoryEntity>>> getCategories() async {
    categoryCalls++;
    return categoriesResponse;
  }

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
  }) async {
    return const Right(
      ComplaintReportEntity(id: '89', ticketNumber: 'PGD-2026-00089'),
    );
  }
}

void main() {
  Widget buildListTestApp({
    required JagaTanahListBloc bloc,
    bool showFilter = false,
  }) {
    final router = GoRouter(
      initialLocation: AppRouter.jagaTanahPath,
      routes: [
        GoRoute(
          path: AppRouter.jagaTanahPath,
          name: AppRouter.jagaTanah,
          builder: (context, state) => BlocProvider.value(
            value: bloc,
            child: JagaTanahListScreen(showFilter: showFilter),
          ),
        ),
        GoRoute(
          path: AppRouter.tambahJagaTanahPath,
          name: AppRouter.tambahJagaTanah,
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Halaman Form Jaga Tanahku'),
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

  testWidgets(
    'JagaTanahListScreen menampilkan loading, empty, error+retry, search, FAB, dan filter tersembunyi default',
    (tester) async {
      final repository = _FakeJagaTanahRepository()
        ..pendingCompleter =
            Completer<Either<Failure, ComplaintPaginatedEntity>>();
      final bloc = JagaTanahListBloc(
        getMyReports: GetMyJagaTanahReportsUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      );
      addTearDown(bloc.close);

      // 1. Loading & filter button hidden by default
      await tester.pumpWidget(buildListTestApp(bloc: bloc));
      expect(find.byIcon(Icons.tune_rounded), findsNothing);

      bloc.add(const FetchJagaTanahReportsEvent());
      await tester.pump();
      expect(find.byType(ReportCardShimmerList), findsOneWidget);
      expect(
        find.bySemanticsLabel('Memuat laporan Jaga Tanahku...'),
        findsOneWidget,
      );
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(tester.takeException(), isNull);

      // 2. Empty state
      repository.pendingCompleter!.complete(
        const Right(ComplaintPaginatedEntity()),
      );
      repository.pendingCompleter = null;
      await tester.pumpAndSettle();
      expect(find.text('Belum Ada Laporan Jaga Tanahku'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.text('Buat Laporan'), findsOneWidget);

      // 3. Error + retry
      repository.listResponse = const Left(ServerFailure('Server gangguan'));
      bloc.add(const FetchJagaTanahReportsEvent());
      await tester.pumpAndSettle();
      expect(find.text('Gagal Memuat Laporan'), findsOneWidget);
      expect(find.text('Server gangguan'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);

      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();
      expect(repository.fetchCalls, 3);

      // 4. Loaded list + breakpoints (320x640, 800x1024) + 200% zoom
      repository.listResponse = Right(
        ComplaintPaginatedEntity(
          data: [
            ComplaintReportEntity(
              id: '101',
              ticketNumber: 'PGD-2026-00101',
              title: 'Pagar batas tanah desa rusak',
              category: 'Tanah Kas Desa',
              address: 'Desa Sukamaju',
              status: 'in_progress',
              statusLabel: 'Sedang Diproses',
              reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            ComplaintReportEntity(
              id: '102',
              ticketNumber: 'PGD-2026-00102',
              title: 'Okupasi lahan pemda',
              category: 'Kabupaten/Kota',
              address: 'Jl. Jenderal Sudirman',
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
      bloc.add(const FetchJagaTanahReportsEvent());
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);

      addTearDown(() => tester.binding.setSurfaceSize(null));
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

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

      // 5. Search & reset search
      await tester.enterText(find.byType(TextField), 'okupasi');
      await tester.pump(const Duration(milliseconds: 550));
      await tester.pumpAndSettle();

      expect(find.text('Okupasi lahan pemda'), findsOneWidget);
      expect(find.text('Pagar batas tanah desa rusak'), findsNothing);

      await tester.enterText(find.byType(TextField), 'nihil');
      await tester.pump(const Duration(milliseconds: 550));
      await tester.pumpAndSettle();
      expect(find.text('Laporan Tidak Ditemukan'), findsOneWidget);

      await tester.tap(find.text('Reset Pencarian'));
      await tester.pumpAndSettle();
      expect(find.text('Okupasi lahan pemda'), findsOneWidget);

      // 6. FAB create navigation refreshes list when returning true
      final callsBeforeFab = repository.fetchCalls;
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Halaman Form Jaga Tanahku'), findsOneWidget);

      await tester.tap(find.text('Halaman Form Jaga Tanahku'));
      await tester.pumpAndSettle();
      expect(repository.fetchCalls, callsBeforeFab + 1);

      // 7. Tap item opens detail route
      await tester.tap(find.text('Okupasi lahan pemda'));
      await tester.pumpAndSettle();
      expect(find.text('Detail PGD-2026-00102'), findsOneWidget);
    },
  );

  testWidgets(
    'CreateJagaTanahPage menampilkan kategori bertingkat dan mewajibkan sub-kategori saat memilih Tanah Pemda',
    (tester) async {
      final repository = _FakeJagaTanahRepository()
        ..categoriesResponse = const Left(
          ServerFailure('Gagal memuat kategori'),
        );
      final bloc = CreateJagaTanahBloc(
        createReport: CreateJagaTanahReportUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      );
      addTearDown(bloc.close);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.binding.setSurfaceSize(const Size(360, 780));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc..add(const LoadJagaTanahCategoriesEvent()),
            child: const CreateJagaTanahPage(autoFetchLocation: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Buat Laporan Jaga Tanahku'), findsOneWidget);
      expect(find.text('Gagal memuat kategori'), findsOneWidget);
      expect(find.text('Muat Ulang'), findsOneWidget);

      repository.categoriesResponse = const Right([
        JagaTanahCategoryEntity(
          id: 20,
          code: 'tanah_kas_desa',
          label: 'Tanah Kas Desa',
          sortOrder: 1,
        ),
        JagaTanahCategoryEntity(
          id: 21,
          code: 'tanah_pemda',
          label: 'Tanah Pemda',
          sortOrder: 2,
          children: [
            JagaTanahCategoryEntity(
              id: 22,
              code: 'tanah_pemda_kabupaten_kota',
              label: 'Kabupaten/Kota',
              parentId: 21,
              sortOrder: 1,
            ),
            JagaTanahCategoryEntity(
              id: 23,
              code: 'tanah_pemda_provinsi',
              label: 'Provinsi',
              parentId: 21,
              sortOrder: 2,
            ),
          ],
        ),
      ]);
      await tester.tap(find.text('Muat Ulang'));
      await tester.pumpAndSettle();

      // Pilih Tanah Kas Desa -> Sub-Kategori tidak tampil, sheet tanpa search
      expect(find.byIcon(Icons.category_outlined), findsOneWidget);
      await tester.tap(find.text('Pilih kategori Jaga Tanahku'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(JagaTanahCategorySheet),
          matching: find.byType(TextField),
        ),
        findsNothing,
      );
      expect(find.text('Tanah Kas Desa'), findsOneWidget);
      expect(find.text('Tanah Pemda'), findsOneWidget);
      expect(find.text('2 sub-kategori'), findsOneWidget);

      await tester.tap(find.text('Tanah Kas Desa'));
      await tester.pumpAndSettle();
      expect(find.text('Sub-Kategori'), findsNothing);
      expect(find.byIcon(Icons.terrain_rounded), findsOneWidget);

      // Ganti ke Tanah Pemda -> Sub-Kategori muncul & wajib diisi
      await tester.tap(find.text('Tanah Kas Desa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tanah Pemda'));
      await tester.pumpAndSettle();
      expect(find.text('Pilih sub-kategori Tanah Pemda'), findsOneWidget);
      expect(find.byIcon(Icons.account_tree_outlined), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_rounded), findsOneWidget);

      // Submit tanpa pilih sub-kategori -> validasi inline muncul
      await tester.tap(find.text('KIRIM'));
      await tester.pumpAndSettle();
      expect(find.text('Sub-kategori wajib dipilih'), findsOneWidget);

      // Pilih sub-kategori Kabupaten/Kota -> error hilang & zero overflow di 320px/800px
      await tester.tap(find.text('Pilih sub-kategori Tanah Pemda'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kabupaten/Kota'));
      await tester.pumpAndSettle();
      expect(find.text('Kabupaten/Kota'), findsOneWidget);
      expect(find.text('Sub-kategori wajib dipilih'), findsNothing);

      for (final size in const [Size(320, 640), Size(800, 1024)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.binding.setSurfaceSize(const Size(320, 640));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
