import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/create_jaga_tanah_report_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_detail_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_my_jaga_tanah_reports_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_detail_bloc/jaga_tanah_detail_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_list_bloc/jaga_tanah_list_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_detail_labels.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/create_jaga_tanah_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_detail_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_list_screen.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_attachment_section.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_detail_status_banner.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_review_step.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_spatial_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_step_indicator.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/location_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  int createCalls = 0;
  String? lastStatusFilter;
  String? lastCategoryFilter;
  String? lastSubmittedTitle;
  String? lastSubmittedDescription;
  String? lastSubmittedAddress;
  double? lastSubmittedLatitude;
  double? lastSubmittedLongitude;
  List<String>? lastSubmittedAttachmentPaths;
  int? lastSubmittedCategoryId;
  int? lastSubmittedSubCategoryId;
  String? lastSubmittedType;
  String? lastSubmittedLocationAccess;
  String? lastSubmittedFieldCondition;
  String? lastSubmittedDominantLandCover;
  String? lastSubmittedVisibleUsage;
  String? lastSubmittedUsageLevel;
  String? lastSubmittedMaintenanceStatus;
  String? lastSubmittedConditionInfoSource;
  String? lastSubmittedTenureInfoSource;
  String? lastSubmittedPossessionMarkers;
  String? lastSubmittedConflictInfo;
  final List<String> recordedIdempotencyKeys = [];
  final List<Either<Failure, ComplaintReportEntity>> createResponses = [];

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

  Either<Failure, JagaTanahDetailEntity> detailResponse = const Right(
    JagaTanahDetailEntity(
      id: '89',
      ticketNumber: 'JGT-2611200001',
      title: 'Laporan Tanah 89',
    ),
  );
  int detailCalls = 0;

  @override
  Future<Either<Failure, JagaTanahDetailEntity>> getReportDetail(
    String id,
  ) async {
    detailCalls++;
    return detailResponse;
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
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    createCalls++;
    lastSubmittedTitle = title;
    lastSubmittedDescription = description;
    lastSubmittedAddress = address;
    lastSubmittedLatitude = latitude;
    lastSubmittedLongitude = longitude;
    lastSubmittedAttachmentPaths = attachments.map((f) => f.path).toList();
    lastSubmittedCategoryId = categoryId;
    lastSubmittedSubCategoryId = subCategoryId;
    lastSubmittedType = type;
    lastSubmittedLocationAccess = locationAccess;
    lastSubmittedFieldCondition = fieldCondition;
    lastSubmittedDominantLandCover = dominantLandCover;
    lastSubmittedVisibleUsage = visibleUsage;
    lastSubmittedUsageLevel = usageLevel;
    lastSubmittedMaintenanceStatus = maintenanceStatus;
    lastSubmittedConditionInfoSource = conditionInfoSource;
    lastSubmittedTenureInfoSource = tenureInfoSource;
    lastSubmittedPossessionMarkers = possessionMarkers;
    lastSubmittedConflictInfo = conflictInfo;
    if (idempotencyKey != null) {
      recordedIdempotencyKeys.add(idempotencyKey);
    }
    return createResponses.isNotEmpty
        ? createResponses.removeAt(0)
        : const Right(
            ComplaintReportEntity(id: '89', ticketNumber: 'JGT-2611200001'),
          );
  }
}

void main() {
  Widget buildListTestApp({
    required JagaTanahListBloc bloc,
    bool showFilter = true,
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
                child: const Text('Halaman Form Jaga Tanah'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRouter.jagaTanahDetailPath,
          name: AppRouter.jagaTanahDetail,
          builder: (context, state) {
            final item = state.extra as ComplaintItem;
            return Scaffold(body: Center(child: Text('Detail JGT ${item.id}')));
          },
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  testWidgets(
    'JagaTanahListScreen menampilkan loading, empty, error+retry, search, FAB, dan filter tampil default',
    (tester) async {
      final repository = _FakeJagaTanahRepository()
        ..pendingCompleter =
            Completer<Either<Failure, ComplaintPaginatedEntity>>();
      final bloc = JagaTanahListBloc(
        getMyReports: GetMyJagaTanahReportsUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      );
      addTearDown(bloc.close);

      // 1. Loading & filter button visible by default
      await tester.pumpWidget(buildListTestApp(bloc: bloc));
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      bloc.add(const FetchJagaTanahReportsEvent());
      await tester.pump();
      expect(find.byType(ReportCardShimmerList), findsOneWidget);
      expect(
        find.bySemanticsLabel('Memuat laporan Jaga Tanah...'),
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
      expect(find.text('Belum Ada Laporan Jaga Tanah'), findsOneWidget);
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
      expect(find.text('Halaman Form Jaga Tanah'), findsOneWidget);

      await tester.tap(find.text('Halaman Form Jaga Tanah'));
      await tester.pumpAndSettle();
      expect(repository.fetchCalls, callsBeforeFab + 1);

      // 7. Tap item opens Jaga Tanah detail route
      await tester.tap(find.text('Okupasi lahan pemda'));
      await tester.pumpAndSettle();
      expect(find.text('Detail JGT PGD-2026-00102'), findsOneWidget);
    },
  );

  testWidgets(
    'filter status dan kategori Jaga Tanah mengirim query ke server dan menampilkan badge + reset',
    (tester) async {
      final repository = _FakeJagaTanahRepository()
        ..listResponse = Right(
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
            ],
            currentPage: 1,
            lastPage: 1,
            total: 1,
          ),
        )
        ..categoriesResponse = const Left(
          ServerFailure('Gagal memuat kategori'),
        );

      final bloc = JagaTanahListBloc(
        getMyReports: GetMyJagaTanahReportsUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      );
      addTearDown(bloc.close);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.binding.setSurfaceSize(const Size(320, 640));
      await tester.pumpWidget(buildListTestApp(bloc: bloc));
      bloc.add(const FetchJagaTanahReportsEvent());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Filter Laporan'), findsOneWidget);
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
          ],
        ),
      ]);
      await tester.ensureVisible(find.text('Muat Ulang'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Muat Ulang'));
      await tester.pumpAndSettle();

      expect(repository.categoryCalls, 2);
      expect(find.text('Tanah Kas Desa'), findsWidgets);
      expect(find.text('Tanah Pemda - Kabupaten/Kota'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Verify 200% zoom inside filter sheet at 320x640 without overflow
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Mediasi').last);
      await tester.tap(find.text('Mediasi').last);
      await tester.ensureVisible(find.text('Tanah Pemda - Kabupaten/Kota'));
      await tester.tap(find.text('Tanah Pemda - Kabupaten/Kota'));
      await tester.pumpAndSettle();

      repository.listResponse = const Right(ComplaintPaginatedEntity());
      await tester.tap(find.text('Terapkan Filter'));
      await tester.pumpAndSettle();

      expect(repository.lastStatusFilter, 'mediation');
      expect(repository.lastCategoryFilter, 'tanah_pemda_kabupaten_kota');
      expect(find.text('2'), findsOneWidget);
      expect(
        find.text('Tidak ada laporan yang sesuai dengan filter yang dipilih.'),
        findsOneWidget,
      );

      repository.listResponse = Right(
        ComplaintPaginatedEntity(
          data: [
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
          total: 1,
        ),
      );
      await tester.tap(find.text('Reset Filter'));
      await tester.pumpAndSettle();

      expect(repository.lastStatusFilter, isNull);
      expect(repository.lastCategoryFilter, isNull);
      expect(find.text('Okupasi lahan pemda'), findsOneWidget);
      expect(find.text('2'), findsNothing);

      await tester.binding.setSurfaceSize(const Size(800, 1024));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'CreateJagaTanahPage menjalankan alur 5 langkah (Informasi, Lokasi tanpa kartu GPS, Kondisi, Penguasaan, Review), indikator step slide horizontal di layar ponsel, mengisi otomatis wilayah, dan aman di layar sempit serta zoom 200%',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final repository = _FakeJagaTanahRepository()
        ..createResponses.add(
          const Left(ServerFailure('Validasi gagal pada server.')),
        );
      final createBloc = CreateJagaTanahBloc(
        createReport: CreateJagaTanahReportUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      )..add(const LoadJagaTanahCategoriesEvent());
      addTearDown(createBloc.close);

      bool? popResult;
      await tester.binding.setSurfaceSize(const Size(360, 780));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (rootContext) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  popResult = await Navigator.of(rootContext).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<CreateJagaTanahBloc>.value(
                        value: createBloc,
                        child: CreateJagaTanahPage(
                          autoFetchLocation: false,
                          mapPreviewBuilder: (_, center) => Container(
                            key: const ValueKey('fake_map_preview'),
                            alignment: Alignment.center,
                            child: Text(
                              'Pin ${center.latitude.toStringAsFixed(3)}, ${center.longitude.toStringAsFixed(3)}',
                            ),
                          ),
                          onOpenMapOverride:
                              (_, {initialAddress, initialPosition}) async {
                                return const LocationPickerResult(
                                  address:
                                      '± 500 m arah barat Balai Desa Sukomulyo',
                                  position: LatLng(-7.983921, 112.621508),
                                );
                              },
                          addressResolverOverride: (_) async => (
                            province: 'Jawa Timur',
                            regency: 'Kab. Mojokerto',
                            district: 'Ngoro',
                            village: 'Sukomulyo',
                            landmarkAddress: 'Jl. Raya Sukomulyo, Sukomulyo',
                          ),
                          onPickPhotoOverride: (_) async =>
                              '/tmp/non_existent_geotag.webp',
                          onPickVideoOverride: (_) async =>
                              '/tmp/non_existent_video.mp4',
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Buka Form Jaga Tanah'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Buka Form Jaga Tanah'));
      await tester.pumpAndSettle();

      double currentProgress() => tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value!;

      // Step 1/5 (Informasi) tampil terlebih dahulu + 5 pill penuh dan dapat di-slide horizontal di ponsel
      expect(find.text('Buat Laporan Jaga Tanah'), findsOneWidget);
      expect(find.textContaining('Form Jaga Tanah ('), findsNothing);
      expect(find.text('Info'), findsNothing);
      expect(find.text('Hak'), findsNothing);
      expect(find.text('Informasi'), findsOneWidget);
      expect(find.text('Lokasi'), findsOneWidget);
      expect(find.text('Kondisi'), findsOneWidget);
      expect(find.text('Penguasaan'), findsOneWidget);
      expect(find.text('Review'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(JagaTanahStepIndicator),
          matching: find.byWidgetPredicate(
            (w) =>
                w is SingleChildScrollView &&
                w.scrollDirection == Axis.horizontal,
          ),
        ),
        findsOneWidget,
      );
      expect(currentProgress(), closeTo(0.20, 0.001));
      expect(find.text('Informasi Laporan'), findsOneWidget);
      expect(find.byIcon(Icons.category_outlined), findsNothing);
      expect(find.byIcon(Icons.landscape_rounded), findsOneWidget);
      expect(find.text('Lokasi dan Data Spasial'), findsNothing);
      expect(find.text('Kondisi Penggunaan & Pemanfaatan'), findsNothing);
      expect(find.text('Informasi Hak & Penguasaan'), findsNothing);
      expect(find.text('Lanjut'), findsOneWidget);
      expect(find.text('Kembali'), findsNothing);

      expect(find.text('Jenis Hak'), findsNothing);
      expect(find.text('Pengguna / Penguasa Terlihat'), findsNothing);
      expect(find.text('Nomor Hak / NIB'), findsNothing);
      expect(find.textContaining('Lama Kondisi'), findsNothing);
      expect(find.text('Bentuk Objek'), findsNothing);
      expect(find.text('Perkiraan Luas'), findsNothing);

      // Lanjut saat Step 1 kosong tertahan dan memunculkan validasi inline
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.20, 0.001));
      expect(find.text('Kategori Laporan wajib dipilih'), findsOneWidget);
      expect(find.text('Judul Laporan wajib diisi'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Pilih kategori induk yang memiliki sub-kategori -> Sub-Kategori muncul & wajib diisi
      await tester.tap(find.text('Pilih kategori laporan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tanah Pemda'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.account_balance_rounded), findsOneWidget);
      expect(find.text('Pilih sub-kategori'), findsOneWidget);

      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.20, 0.001));
      expect(find.text('Sub-Kategori wajib dipilih'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih sub-kategori'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kabupaten/Kota'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'Contoh: Indikasi okupasi tanah kas desa',
        ),
        'Indikasi okupasi tanah pemda',
      );
      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'Ringkasan singkat atau catatan penting di lapangan (opsional)',
        ),
        'Terdapat patok baru di sisi selatan lahan',
      );
      await tester.pumpAndSettle();

      // Cek responsif & zoom 200% di Step 1 sebelum lanjut ke Step 2
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
      await tester.binding.setSurfaceSize(const Size(360, 780));
      await tester.pumpAndSettle();

      // Lanjut ke Step 2/5 (Lokasi)
      await tester.ensureVisible(find.text('Lanjut'));
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.40, 0.001));
      expect(find.text('Lokasi dan Data Spasial'), findsOneWidget);
      expect(find.text('Kembali'), findsOneWidget);
      expect(find.text('Koordinat GPS'), findsNothing);
      expect(find.text('Ambil GPS'), findsNothing);

      final spatialTop = tester
          .getTopLeft(find.byType(JagaTanahSpatialCard))
          .dy;
      final provinceTop = tester
          .getTopLeft(find.widgetWithText(TextFormField, 'Contoh: Jawa Timur'))
          .dy;
      expect(spatialTop, lessThan(provinceTop));

      // Uji Kembali ke Step 1 menjaga nilai isian tetap utuh, lalu maju lagi ke Step 2
      await tester.tap(find.text('Kembali'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.20, 0.001));
      expect(find.text('Informasi Laporan'), findsOneWidget);
      expect(find.text('Indikasi okupasi tanah pemda'), findsOneWidget);
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.40, 0.001));

      // Lanjut saat Step 2 kosong tertahan dan memunculkan validasi inline
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.40, 0.001));
      expect(find.text('Provinsi wajib diisi'), findsOneWidget);
      expect(find.text('Titik lokasi di peta wajib dipilih'), findsOneWidget);
      expect(
        find.text('Minimal 1 lampiran foto atau video wajib dilampirkan'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Pilih lokasi pin di peta -> peta preview tampil & field bawah otomatis terisi
      await tester.ensureVisible(find.text('Belum ada titik lokasi'));
      await tester.tap(find.text('Belum ada titik lokasi'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('fake_map_preview')), findsOneWidget);
      expect(find.text('Ubah titik lokasi'), findsOneWidget);
      expect(find.text('Pin -7.984, 112.622'), findsOneWidget);
      expect(find.text('Jawa Timur'), findsOneWidget);
      expect(find.text('Kab. Mojokerto'), findsOneWidget);
      expect(find.text('Ngoro'), findsOneWidget);
      expect(find.text('Sukomulyo'), findsOneWidget);
      expect(find.text('Jl. Raya Sukomulyo, Sukomulyo'), findsOneWidget);

      // Ambil foto & video lewat JagaTanahAttachmentSection (maksimal 1 video dari 5 lampiran)
      expect(find.text('Ambil Foto Lokasi (Geotag)'), findsNothing);
      final photoBtn = find.descendant(
        of: find.byType(JagaTanahAttachmentSection),
        matching: find.text('Foto'),
      );
      await tester.ensureVisible(photoBtn);
      await tester.tap(photoBtn);
      await tester.pumpAndSettle();
      expect(find.text('1/5 lampiran'), findsOneWidget);

      final videoBtn = find.descendant(
        of: find.byType(JagaTanahAttachmentSection),
        matching: find.byIcon(Icons.videocam_rounded),
      );
      expect(videoBtn, findsOneWidget);
      await tester.ensureVisible(videoBtn);
      await tester.tap(videoBtn);
      await tester.pumpAndSettle();
      expect(find.text('2/5 lampiran'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(JagaTanahAttachmentSection),
          matching: find.byIcon(Icons.videocam_rounded),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(JagaTanahAttachmentSection),
          matching: find.byIcon(Icons.play_circle_fill_rounded),
        ),
        findsOneWidget,
      );

      Future<void> pickOption(String hint, String option) async {
        final target = find.text(hint);
        await tester.ensureVisible(target);
        await tester.tap(target);
        await tester.pumpAndSettle();
        await tester.tap(find.text(option));
        await tester.pumpAndSettle();
      }

      await pickOption('Pilih akses menuju lokasi', 'Jalan lingkungan');

      // Cek responsif Step 2 sebelum lanjut
      for (final size in const [Size(320, 640), Size(800, 1024)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.binding.setSurfaceSize(const Size(360, 780));
      await tester.pumpAndSettle();

      // Lanjut ke Step 3/5 (Kondisi)
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.60, 0.001));
      expect(find.text('Kondisi Penggunaan & Pemanfaatan'), findsOneWidget);
      expect(find.text('Kembali'), findsOneWidget);

      // Lanjut saat Step 3 kosong tertahan & tampilkan error inline
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.60, 0.001));
      expect(
        find.text('Kondisi Utama di Lapangan wajib dipilih'),
        findsOneWidget,
      );

      await pickOption(
        'Pilih kondisi utama di lapangan',
        'Sebagian dimanfaatkan',
      );
      await pickOption('Pilih penutup lahan dominan', 'Semak belukar');
      await pickOption('Pilih penggunaan yang terlihat', 'Perkebunan');
      await pickOption(
        'Pilih tingkat penggunaan lahan',
        'Rendah (< 25% dari luas)',
      );
      await pickOption(
        'Pilih kondisi pemeliharaan',
        'Tidak terpelihara (tidak ada aktivitas)',
      );
      await pickOption(
        'Pilih sumber informasi kondisi',
        'Pengamatan langsung oleh Linmas',
      );

      // Lanjut ke Step 4/5 (Penguasaan / Hak)
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.80, 0.001));
      expect(find.text('Informasi Hak & Penguasaan'), findsOneWidget);
      expect(find.text('Lanjut'), findsOneWidget);

      // Lanjut saat Step 4 kosong tertahan & tampilkan error inline
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.80, 0.001));
      expect(
        find.text('Sumber Informasi Penguasaan wajib dipilih'),
        findsOneWidget,
      );

      await pickOption('Pilih sumber informasi penguasaan', 'Papan di lokasi');
      await pickOption(
        'Pilih tanda penguasaan di lokasi',
        'Ada papan, tanpa pagar',
      );
      await pickOption('Pilih status informasi konflik', 'Tidak ada informasi');

      // Lanjut ke Step 5/5 (Review)
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(1.0, 0.001));
      expect(find.byType(JagaTanahReviewStep), findsOneWidget);
      expect(find.text('Review Data Laporan'), findsOneWidget);
      expect(find.text('Kirim'), findsOneWidget);
      expect(find.text('Tanah Pemda'), findsOneWidget);
      expect(find.text('Kabupaten/Kota'), findsNWidgets(2));
      expect(find.text('Indikasi okupasi tanah pemda'), findsOneWidget);
      expect(
        find.text('Terdapat patok baru di sisi selatan lahan'),
        findsOneWidget,
      );
      expect(find.text('Koordinat GPS'), findsNothing);
      expect(find.text('-7.983921, 112.621508'), findsNothing);
      expect(find.byType(JagaTanahSpatialCard), findsOneWidget);
      expect(find.byKey(const ValueKey('fake_map_preview')), findsOneWidget);
      expect(find.text('Pin -7.984, 112.622'), findsOneWidget);
      expect(find.text('Ubah titik lokasi'), findsNothing);
      expect(find.byIcon(Icons.fullscreen_rounded), findsNothing);
      expect(find.text('Jawa Timur'), findsOneWidget);
      expect(find.text('1 foto, 1 video terlampir'), findsOneWidget);
      expect(find.text('Jalan lingkungan'), findsOneWidget);
      expect(find.text('Sebagian dimanfaatkan'), findsOneWidget);
      expect(find.text('Papan di lokasi'), findsOneWidget);

      // Tap Ubah pada bagian 3 membawa kembali ke Step 3 Kondisi, lalu lanjut kembali ke Step 5 Review
      await tester.ensureVisible(find.text('Ubah').at(2));
      await tester.tap(find.text('Ubah').at(2));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(0.60, 0.001));
      expect(find.text('Kondisi Penggunaan & Pemanfaatan'), findsOneWidget);
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(currentProgress(), closeTo(1.0, 0.001));
      expect(find.text('Review Data Laporan'), findsOneWidget);

      // Cek responsif & zoom 200% di viewport sempit pada Step 5 Review sebelum submit
      for (final size in const [Size(320, 640), Size(800, 1024)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      await tester.binding.setSurfaceSize(const Size(320, 640));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Submit pertama gagal -> tampilkan toast error, tetap di Review, dan retry kirim ulang
      await tester.tap(find.text('Kirim'));
      await tester.pumpAndSettle();
      expect(find.text('Validasi gagal pada server.'), findsOneWidget);
      expect(find.text('Kirim'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Retry dengan payload identik -> idempotency key sama, dialog sukses + nomor tiket tampil aman di 320x640 zoom 200%, lalu pop(true)
      await tester.tap(find.text('Kirim'));
      await tester.pumpAndSettle();
      expect(find.text('Laporan Terkirim'), findsOneWidget);
      expect(find.text('JGT-2611200001'), findsOneWidget);
      expect(tester.takeException(), isNull);

      expect(repository.createCalls, 2);
      expect(repository.recordedIdempotencyKeys, hasLength(2));
      expect(
        repository.recordedIdempotencyKeys[0],
        equals(repository.recordedIdempotencyKeys[1]),
      );
      expect(
        RegExp(r'^[A-Za-z0-9._:\-/+=]{1,128}$')
            .hasMatch(repository.recordedIdempotencyKeys.first),
        isTrue,
      );
      expect(repository.lastSubmittedCategoryId, 21);
      expect(repository.lastSubmittedSubCategoryId, 22);
      expect(repository.lastSubmittedTitle, 'Indikasi okupasi tanah pemda');
      expect(
        repository.lastSubmittedDescription,
        'Terdapat patok baru di sisi selatan lahan',
      );
      expect(repository.lastSubmittedAddress, 'Jl. Raya Sukomulyo, Sukomulyo');
      expect(repository.lastSubmittedLatitude, -7.983921);
      expect(repository.lastSubmittedLongitude, 112.621508);
      expect(repository.lastSubmittedType, 'point');
      expect(repository.lastSubmittedLocationAccess, 'Jalan lingkungan');
      expect(repository.lastSubmittedFieldCondition, 'Sebagian dimanfaatkan');
      expect(repository.lastSubmittedDominantLandCover, 'Semak belukar');
      expect(repository.lastSubmittedVisibleUsage, 'Perkebunan');
      expect(repository.lastSubmittedUsageLevel, 'Rendah (< 25% dari luas)');
      expect(
        repository.lastSubmittedMaintenanceStatus,
        'Tidak terpelihara (tidak ada aktivitas)',
      );
      expect(
        repository.lastSubmittedConditionInfoSource,
        'Pengamatan langsung oleh Linmas',
      );
      expect(repository.lastSubmittedTenureInfoSource, 'Papan di lokasi');
      expect(
        repository.lastSubmittedPossessionMarkers,
        'Ada papan, tanpa pagar',
      );
      expect(repository.lastSubmittedConflictInfo, 'Tidak ada informasi');
      expect(repository.lastSubmittedAttachmentPaths, [
        '/tmp/non_existent_geotag.webp',
        '/tmp/non_existent_video.mp4',
      ]);

      await tester.tap(find.text('Selesai'));
      await tester.pumpAndSettle();
      expect(find.text('Laporan Terkirim'), findsNothing);
      expect(popResult, isTrue);
    },
  );

  testWidgets(
    'JagaTanahDetailPage menampilkan loading, error+retry, serta seluruh isi laporan Jaga Tanah aman di 320x640 dan zoom 200%',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final repository = _FakeJagaTanahRepository()
        ..detailResponse = const Left(ServerFailure('Server gangguan'));
      final bloc = JagaTanahDetailBloc(
        getReportDetail: GetJagaTanahDetailUsecase(repository),
      );
      addTearDown(bloc.close);

      await tester.binding.setSurfaceSize(const Size(360, 780));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<JagaTanahDetailBloc>.value(
            value: bloc,
            child: JagaTanahDetailPage(
              reportId: '89',
              mapPreviewBuilder: (_, center) => Container(
                key: const ValueKey('detail_fake_map'),
                alignment: Alignment.center,
                child: Text(
                  'Pin ${center.latitude.toStringAsFixed(3)}, ${center.longitude.toStringAsFixed(3)}',
                ),
              ),
            ),
          ),
        ),
      );

      bloc.add(const FetchJagaTanahDetailEvent('89'));
      await tester.pumpAndSettle();
      expect(find.text('Detail Laporan Jaga Tanah'), findsOneWidget);
      expect(find.text('Gagal Memuat Detail Laporan'), findsOneWidget);
      expect(find.text('Server gangguan'), findsOneWidget);

      repository.detailResponse = Right(
        JagaTanahDetailEntity(
          id: '89',
          ticketNumber: 'JGT-2611200001',
          title: 'Lahan Kas Desa Sukomulyo Belum Terpelihara',
          description: 'Sebagian lahan ditumbuhi semak belukar.',
          status: 'bpn_forwarded',
          statusLabel: 'Diteruskan ke BPN',
          category: 'Tanah Pemda',
          subCategory: 'Kabupaten/Kota',
          reportedAt: DateTime(2026, 11, 20, 15, 0),
          escalationLevel: 1,
          address: '± 500 m arah barat Balai Desa Sukomulyo',
          province: 'Jawa Timur',
          regency: 'Kab. Mojokerto',
          district: 'Ngoro',
          village: 'Sukomulyo',
          latitude: -7.983921,
          longitude: 112.621508,
          objectShape: 'Satu bidang tanah',
          estimatedArea: '> 5 - 10 Ha',
          locationAccess: 'Jalan lingkungan',
          fieldCondition: 'Sebagian dimanfaatkan',
          dominantLandCover: 'Semak belukar',
          visibleUsage: 'Perkebunan',
          usageLevel: 'Rendah (< 25% dari luas)',
          maintenanceStatus: 'Tidak terpelihara (tidak ada aktivitas)',
          conditionInfoSource: 'Pengamatan langsung oleh Linmas',
          tenureInfoSource: 'Papan di lokasi',
          possessionMarkers: 'Ada papan, tanpa pagar',
          conflictInfo: 'Tidak ada informasi',
          verifierUnit: 'DPC Kab. Mojokerto',
          verificationMethod: 'both',
          verificationSummary: 'Titik sesuai batas fisik.',
          followUpDecision: 'bpn',
          followUpNotes: 'Koordinasi cek sertifikat ke Kantah.',
          bpnActionType: 'cek_status_hak',
          bpnReferenceNumber: 'BPN/2026/89',
          sourceInstitution: 'BPN Kab. Mojokerto',
          landRightType: 'HP',
          landRightNumberNib: 'HP-12.01.00045',
          bpnFeedbackStatus: 'certificate_checked',
          bpnFeedbackSummary: 'Tercatat atas nama Pemkab.',
          attachments: const [
            ComplaintAttachmentEntity(
              mimeType: 'image/jpeg',
              url: '/tmp/non_existent_detail.jpg',
            ),
            ComplaintAttachmentEntity(
              mimeType: 'video/mp4',
              url: '/tmp/non_existent_detail.mp4',
            ),
          ],
          timeline: [
            ComplaintTimelineEntity(
              type: 'submitted',
              description: 'Laporan dikirim oleh petugas.',
              actorName: 'Budi Santoso',
              createdAt: DateTime(2026, 11, 20, 15, 0),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();
      expect(repository.detailCalls, 2);

      // Pastikan seluruh seksi & isi Jaga Tanah tampil dan copy Dumas tidak muncul
      expect(find.text('Detail Pengaduan'), findsNothing);
      expect(find.text('Status Pengaduan'), findsNothing);
      expect(find.text('Status Laporan'), findsOneWidget);
      expect(find.text('Diteruskan ke BPN'), findsNWidgets(2));
      expect(find.text('JGT-2611200001'), findsNothing);
      expect(find.text('Tanah Pemda • Kabupaten/Kota'), findsNothing);
      expect(find.text('Eskalasi Level 1'), findsNothing);
      expect(find.text('Tanah Pemda'), findsOneWidget);
      expect(find.text('Kabupaten/Kota'), findsNWidgets(2));
      final bannerContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(JagaTanahDetailStatusBanner),
              matching: find.byType(Container),
            )
            .first,
      );
      final bannerDecoration = bannerContainer.decoration as BoxDecoration;
      expect(bannerDecoration.color, AppColors.primaryLight);

      expect(find.text('Informasi Laporan'), findsOneWidget);
      expect(find.text('Lokasi & Data Spasial'), findsOneWidget);
      expect(find.byKey(const ValueKey('detail_fake_map')), findsOneWidget);
      expect(find.text('Jawa Timur'), findsOneWidget);
      expect(find.text('Jalan lingkungan'), findsOneWidget);
      expect(find.text('2 media'), findsOneWidget);

      expect(find.text('Kondisi Penggunaan & Pemanfaatan'), findsOneWidget);
      expect(find.text('Sebagian dimanfaatkan'), findsOneWidget);
      expect(find.text('Semak belukar'), findsOneWidget);
      expect(find.text('Pengamatan langsung oleh Linmas'), findsOneWidget);

      expect(find.text('Informasi Hak & Penguasaan'), findsOneWidget);
      expect(find.text('Papan di lokasi'), findsOneWidget);
      expect(find.text('Ada papan, tanpa pagar'), findsOneWidget);

      expect(find.text('Verifikasi & Tindak Lanjut'), findsOneWidget);
      expect(find.text('DPC Kab. Mojokerto'), findsOneWidget);
      expect(find.text('Hubungi Pelapor & Cek Lapangan'), findsOneWidget);
      expect(find.text('HP-12.01.00045'), findsOneWidget);

      expect(find.text('Perkembangan Status'), findsOneWidget);
      expect(find.text('Oleh: Budi Santoso'), findsOneWidget);

      // Uji responsivitas 320x640, 800x1024, dan zoom teks 200%
      for (final size in const [Size(320, 640), Size(800, 1024)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      await tester.binding.setSurfaceSize(const Size(320, 640));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  group('Jaga Tanah points UI', () {
    testWidgets(
      'JagaTanahCard hanya menampilkan +10 Poin untuk status terverifikasi dan aman di layar sempit',
      (tester) async {
        final verifiedItem = ComplaintItem.fromReport(
          const ComplaintReportEntity(
            id: '101',
            ticketNumber: 'JGT-101',
            title: 'Lahan Kosong Sangat Luas Dekat Perbatasan Wilayah Desa',
            category: 'Tanah Pemda',
            status: 'bpn_forwarded',
            statusLabel: 'Diteruskan ke BPN',
          ),
        );
        final pendingItem = ComplaintItem.fromReport(
          const ComplaintReportEntity(
            id: '102',
            ticketNumber: 'JGT-102',
            title: 'Lahan Baru Diajukan',
            category: 'Tanah Kas Desa',
            status: 'submitted',
            statusLabel: 'Diajukan',
          ),
        );
        final rejectedItem = ComplaintItem.fromReport(
          const ComplaintReportEntity(
            id: '103',
            ticketNumber: 'JGT-103',
            title: 'Lahan Ditolak',
            category: 'Tanah Kas Desa',
            status: 'rejected',
            statusLabel: 'Ditolak',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(2.0),
              ),
              child: Scaffold(
                body: ListView(
                  children: [
                    JagaTanahCard(item: verifiedItem, onTap: () {}),
                    JagaTanahCard(item: pendingItem, onTap: () {}),
                    JagaTanahCard(item: rejectedItem, onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('+10 Poin'), findsOneWidget);
        expect(find.text('Potensi +10 Poin'), findsNothing);
        expect(find.text('0 Poin'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'JagaTanahDetailStatusBanner menampilkan strip poin untuk earned, pending, rejected, dan override API',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    JagaTanahDetailStatusBanner(
                      detail: JagaTanahDetailEntity(
                        id: '1',
                        status: 'verified',
                        statusLabel: 'Terverifikasi',
                      ),
                    ),
                    JagaTanahDetailStatusBanner(
                      detail: JagaTanahDetailEntity(
                        id: '2',
                        status: 'verification_assigned',
                        statusLabel: 'Verifikasi Ditugaskan',
                      ),
                    ),
                    JagaTanahDetailStatusBanner(
                      detail: JagaTanahDetailEntity(
                        id: '3',
                        status: 'rejected',
                        statusLabel: 'Ditolak',
                      ),
                    ),
                    JagaTanahDetailStatusBanner(
                      detail: JagaTanahDetailEntity(
                        id: '4',
                        status: 'verified',
                        statusLabel: 'Terverifikasi',
                        pointsAwarded: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('+10 Poin'), findsOneWidget);
        expect(find.text('Potensi +10 Poin'), findsOneWidget);
        expect(find.text('0 Poin'), findsOneWidget);
        expect(find.text('+25 Poin'), findsOneWidget);
      },
    );

    testWidgets(
      'JagaTanahDetailPage mempertahankan pointsAwarded dari initialItem saat detail API tidak mengirim field poin',
      (tester) async {
        final repository = _FakeJagaTanahRepository()
          ..detailResponse = const Right(
            JagaTanahDetailEntity(
              id: '90',
              ticketNumber: 'JGT-090',
              title: 'Lahan Desa',
              description: 'Deskripsi lahan',
              status: 'verified',
              statusLabel: 'Terverifikasi',
              category: 'Tanah Kas Desa',
              address: 'Jl. Desa No. 9',
            ),
          );
        final detailBloc = JagaTanahDetailBloc(
          getReportDetail: GetJagaTanahDetailUsecase(repository),
        );
        addTearDown(detailBloc.close);

        final initialItem = ComplaintItem(
          id: 'JGT-090',
          reportId: '90',
          title: 'Lahan Desa',
          category: 'Tanah Kas Desa',
          dateTime: DateTime(2026, 11, 20),
          description: 'Deskripsi lahan',
          location: 'Jl. Desa No. 9',
          attachments: const [],
          status: ComplaintStatus.verified,
          statusLabel: 'Terverifikasi',
          pointsAwarded: 15,
          statusHistory: const [],
          icon: Icons.landscape_rounded,
        );

        // Pastikan fallback manual ComplaintStatus.verified tanpa statusCode tetap terverifikasi
        final fallbackEntity = JagaTanahDetailLabels.fromComplaintItem(
          initialItem,
        );
        expect(fallbackEntity.status, equals('verified'));
        expect(fallbackEntity.pointsAwarded, equals(15));

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: detailBloc,
              child: JagaTanahDetailPage(
                reportId: '90',
                initialItem: initialItem,
              ),
            ),
          ),
        );

        expect(find.text('+15 Poin'), findsOneWidget);

        detailBloc.add(const FetchJagaTanahDetailEvent('90'));
        await tester.pumpAndSettle();

        expect(find.text('+15 Poin'), findsOneWidget);
        expect(find.text('Poin diperoleh'), findsOneWidget);
      },
    );
  });
}
