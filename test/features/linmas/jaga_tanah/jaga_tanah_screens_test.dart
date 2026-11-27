import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/create_jaga_tanah_report_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_detail_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_regions_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_my_jaga_tanah_reports_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_detail_bloc/jaga_tanah_detail_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_list_bloc/jaga_tanah_list_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_detail_labels.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_form_draft.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/create_jaga_tanah_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_detail_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_list_screen.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_polygon_picker_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_attachment_section.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_detail_status_banner.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_region_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_review_step.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_spatial_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_step_indicator.dart';
import 'package:akar/features/masyarakat/complaint/presentation/models/complaint_item.dart';
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
  Map<String, dynamic>? lastSubmittedBoundaryGeojson;
  String? lastSubmittedEstimatedArea;
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

  static const List<JagaTanahRegionEntity> defaultProvinces = [
    JagaTanahRegionEntity(id: '35', name: 'JAWA TIMUR'),
    JagaTanahRegionEntity(id: '31', name: 'DKI JAKARTA'),
  ];

  static const Map<String, List<JagaTanahRegionEntity>>
  defaultRegenciesByProvince = {
    '35': [
      JagaTanahRegionEntity(id: '3516', name: 'KABUPATEN MOJOKERTO'),
      JagaTanahRegionEntity(id: '3576', name: 'KOTA MOJOKERTO'),
      JagaTanahRegionEntity(id: '3573', name: 'KOTA MALANG'),
      JagaTanahRegionEntity(id: '3578', name: 'KOTA SURABAYA'),
    ],
    '31': [JagaTanahRegionEntity(id: '3171', name: 'KOTA JAKARTA SELATAN')],
  };

  static const Map<String, List<JagaTanahRegionEntity>>
  defaultDistrictsByRegency = {
    '3516': [
      JagaTanahRegionEntity(id: '351601', name: 'NGORO'),
      JagaTanahRegionEntity(id: '351602', name: 'PACET'),
    ],
    '3578': [JagaTanahRegionEntity(id: '357801', name: 'GUBENG')],
    '3171': [JagaTanahRegionEntity(id: '317101', name: 'TEBET')],
  };

  static const Map<String, List<JagaTanahRegionEntity>>
  defaultVillagesByDistrict = {
    '351601': [
      JagaTanahRegionEntity(id: '3516012001', name: 'SUKOMULYO'),
      JagaTanahRegionEntity(id: '3516012002', name: 'KUTOGIRANG'),
    ],
    '357801': [JagaTanahRegionEntity(id: '3578011001', name: 'AIRLANGGA')],
    '317101': [JagaTanahRegionEntity(id: '3171011001', name: 'TEBET BARAT')],
  };

  Either<Failure, List<JagaTanahRegionEntity>>? provincesOverride;
  Either<Failure, List<JagaTanahRegionEntity>>? regenciesOverride;
  Either<Failure, List<JagaTanahRegionEntity>>? districtsOverride;
  Either<Failure, List<JagaTanahRegionEntity>>? villagesOverride;
  Completer<Either<Failure, List<JagaTanahRegionEntity>>>? provincesCompleter;
  int provincesCalls = 0;
  bool? lastProvincesForceRefresh;

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getProvinces({
    bool forceRefresh = false,
  }) async {
    provincesCalls++;
    lastProvincesForceRefresh = forceRefresh;
    if (provincesCompleter != null) {
      return provincesCompleter!.future;
    }
    return provincesOverride ?? const Right(defaultProvinces);
  }

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getRegencies(
    String provinceId, {
    bool forceRefresh = false,
  }) async {
    if (regenciesOverride != null) return regenciesOverride!;
    return Right(defaultRegenciesByProvince[provinceId] ?? const []);
  }

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getDistricts(
    String regencyId, {
    bool forceRefresh = false,
  }) async {
    if (districtsOverride != null) return districtsOverride!;
    return Right(defaultDistrictsByRegency[regencyId] ?? const []);
  }

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getVillages(
    String districtId, {
    bool forceRefresh = false,
  }) async {
    if (villagesOverride != null) return villagesOverride!;
    return Right(defaultVillagesByDistrict[districtId] ?? const []);
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
    Map<String, dynamic>? boundaryGeojson,
    String? estimatedArea,
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
    lastSubmittedBoundaryGeojson = boundaryGeojson;
    lastSubmittedEstimatedArea = estimatedArea;
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
                          regionsUsecase: GetJagaTanahRegionsUsecase(
                            repository,
                          ),
                          mapPreviewBuilder: (_, center) => Container(
                            key: const ValueKey('fake_map_preview'),
                            alignment: Alignment.center,
                            child: Text(
                              'Pin ${center.latitude.toStringAsFixed(3)}, ${center.longitude.toStringAsFixed(3)}',
                            ),
                          ),
                          onOpenPolygonOverride:
                              (
                                _, {
                                initialCenter,
                                initialPoints = const [],
                              }) async {
                                return const [
                                  LatLng(-7.983421, 112.621008),
                                  LatLng(-7.983421, 112.622008),
                                  LatLng(-7.984421, 112.622008),
                                  LatLng(-7.984421, 112.621008),
                                ];
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
      final provinceTop = tester.getTopLeft(find.text('Pilih provinsi')).dy;
      expect(spatialTop, greaterThan(provinceTop));

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
      expect(find.text('Provinsi wajib dipilih'), findsOneWidget);
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
      expect(find.text('Ubah Arsiran'), findsOneWidget);
      expect(find.text('Pin -7.984, 112.622'), findsOneWidget);
      expect(find.text('JAWA TIMUR'), findsOneWidget);
      expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);
      expect(find.text('NGORO'), findsOneWidget);
      expect(find.text('SUKOMULYO'), findsOneWidget);
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
        'Pengamatan langsung oleh Aslinmas',
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
      expect(find.text('Ubah Arsiran'), findsNothing);
      expect(find.byIcon(Icons.fullscreen_rounded), findsNothing);
      expect(find.text('JAWA TIMUR'), findsOneWidget);
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
      expect(repository.lastSubmittedLatitude, closeTo(-7.983921, 1e-6));
      expect(repository.lastSubmittedLongitude, closeTo(112.621508, 1e-6));
      expect(repository.lastSubmittedType, 'geometries');
      expect(repository.lastSubmittedEstimatedArea, startsWith('± '));
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
        'Pengamatan langsung oleh Aslinmas',
      );
      expect(repository.lastSubmittedTenureInfoSource, 'Papan di lokasi');
      expect(
        repository.lastSubmittedPossessionMarkers,
        'Ada papan, tanpa pagar',
      );
      expect(repository.lastSubmittedConflictInfo, 'Tidak ada informasi');
      expect(repository.lastSubmittedBoundaryGeojson?['type'], 'Polygon');
      final submittedRing =
          ((repository.lastSubmittedBoundaryGeojson?['coordinates'] as List)
                  .first
              as List);
      expect(submittedRing, hasLength(5));
      expect(submittedRing.first, equals([112.621008, -7.983421]));
      expect(submittedRing.first, equals(submittedRing.last));
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
          polygonPoints: const [
            LatLng(-6.22079498492423, 106.84864025563002),
            LatLng(-6.220641666018301, 106.84866204857826),
            LatLng(-6.220608002513408, 106.84854470193386),
            LatLng(-6.220771320487323, 106.84852324426174),
          ],
          objectShape: 'Satu bidang tanah',
          estimatedArea: '> 5 - 10 Ha',
          locationAccess: 'Jalan lingkungan',
          fieldCondition: 'Sebagian dimanfaatkan',
          dominantLandCover: 'Semak belukar',
          visibleUsage: 'Perkebunan',
          usageLevel: 'Rendah (< 25% dari luas)',
          maintenanceStatus: 'Tidak terpelihara (tidak ada aktivitas)',
          conditionInfoSource: 'Pengamatan langsung oleh Aslinmas',
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
      expect(find.text('Peta Default'), findsOneWidget);
      expect(find.text('Hybrid / Satelit'), findsOneWidget);
      expect(find.text('4 titik sudut'), findsOneWidget);
      expect(find.textContaining('Perkiraan luas: ±'), findsOneWidget);
      expect(find.byTooltip('Lihat Peta Layar Penuh'), findsOneWidget);

      await tester.ensureVisible(find.byTooltip('Lihat Peta Layar Penuh'));
      await tester.tap(find.byTooltip('Lihat Peta Layar Penuh'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Pusatkan Peta'), findsOneWidget);
      expect(find.text('4 titik sudut'), findsOneWidget);
      await tester.tap(find.text('Hybrid / Satelit'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Kembali').last);
      await tester.pumpAndSettle();

      expect(find.text('Jawa Timur'), findsOneWidget);
      expect(find.text('Jalan lingkungan'), findsOneWidget);
      expect(find.text('2 media'), findsOneWidget);

      expect(find.text('Kondisi Penggunaan & Pemanfaatan'), findsOneWidget);
      expect(find.text('Sebagian dimanfaatkan'), findsOneWidget);
      expect(find.text('Semak belukar'), findsOneWidget);
      expect(find.text('Pengamatan langsung oleh Aslinmas'), findsOneWidget);

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

  group('Jaga Tanah Polygon UI', () {
    const samplePolygon = [
      LatLng(-7.560000, 112.630000),
      LatLng(-7.560000, 112.630900),
      LatLng(-7.560900, 112.630900),
      LatLng(-7.560900, 112.630000),
    ];

    testWidgets(
      'Step 2 menempatkan Peta Lokasi di bawah Patokan dan di atas Lampiran tanpa Titik Bidang Tanah serta tombol fullscreen & Ubah Titik membuka polygon picker',
      (tester) async {
        final repository = _FakeJagaTanahRepository();
        final bloc = CreateJagaTanahBloc(
          createReport: CreateJagaTanahReportUsecase(repository),
          getCategories: GetJagaTanahCategoriesUsecase(repository),
        )..add(const LoadJagaTanahCategoriesEvent());
        addTearDown(bloc.close);

        var openCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: BlocProvider.value(
              value: bloc,
              child: CreateJagaTanahPage(
                autoFetchLocation: false,
                regionsUsecase: GetJagaTanahRegionsUsecase(repository),
                mapPreviewBuilder: (_, center) =>
                    Text('MapPreview ${center.latitude.toStringAsFixed(3)}'),
                addressResolverOverride: (_) async => (
                  province: 'Jawa Timur',
                  regency: 'Kab. Mojokerto',
                  district: 'Ngoro',
                  village: 'Sukomulyo',
                  landmarkAddress: 'Jl. Raya Sukomulyo',
                ),
                onOpenPolygonOverride:
                    (_, {initialCenter, initialPoints = const []}) async {
                      openCount++;
                      return samplePolygon;
                    },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Isi Step 1 lalu lanjut ke Step 2
        await tester.tap(find.text('Pilih kategori laporan'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Tanah Kas Desa'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextFormField).first,
          'Pengawasan Lahan Desa',
        );
        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();

        final landmarkRect = tester.getRect(
          find.text('Alamat / Patokan Lokasi *', findRichText: true),
        );
        final fetchLocationRect = tester.getRect(find.text('Ambil Lokasi'));
        final spatialRect = tester.getRect(find.byType(JagaTanahSpatialCard));
        final attachmentRect = tester.getRect(
          find.byType(JagaTanahAttachmentSection),
        );

        expect(fetchLocationRect.top, greaterThan(landmarkRect.bottom));
        expect(spatialRect.top, greaterThan(fetchLocationRect.bottom));
        expect(spatialRect.bottom, lessThan(attachmentRect.top));
        expect(
          find.text(
            'Ketuk peta atau tombol di bawah untuk menandai dan mengubah titik bidang.',
          ),
          findsOneWidget,
        );
        expect(find.text('Titik Bidang Tanah'), findsNothing);
        expect(find.text('Peta Default'), findsOneWidget);
        expect(find.text('Hybrid / Satelit'), findsOneWidget);

        // Ketuk tombol fullscreen -> membuka polygon picker
        await tester.ensureVisible(find.byTooltip('Tambahkan Arsiran'));
        await tester.tap(find.byTooltip('Tambahkan Arsiran'));
        await tester.pumpAndSettle();

        final mapRect = tester.getRect(
          find.byKey(const ValueKey('jaga_tanah_spatial_map_container')),
        );
        expect(openCount, 1);
        expect(find.text('Ubah Arsiran'), findsOneWidget);
        expect(find.text('4 titik sudut'), findsOneWidget);
        expect(find.textContaining('Perkiraan luas: ±'), findsOneWidget);
        expect(
          tester.getRect(find.text('4 titik sudut')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );
        expect(
          tester.getRect(find.textContaining('Perkiraan luas: ±')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );
        expect(
          tester.getRect(find.text('Ubah Arsiran')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );

        // Ketuk tombol Ubah Arsiran di bawah peta -> membuka polygon picker lagi
        await tester.ensureVisible(find.text('Ubah Arsiran'));
        await tester.tap(find.text('Ubah Arsiran'));
        await tester.pumpAndSettle();

        expect(openCount, 2);
      },
    );

    testWidgets(
      'Ambil Lokasi memperbarui wilayah & patokan sambil menjaga polygonPoints dan simpan polygon tidak menimpa patokan yang sudah terisi',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final repository = _FakeJagaTanahRepository();
        final bloc = CreateJagaTanahBloc(
          createReport: CreateJagaTanahReportUsecase(repository),
          getCategories: GetJagaTanahCategoriesUsecase(repository),
        )..add(const LoadJagaTanahCategoriesEvent());
        addTearDown(bloc.close);

        const gpsPoint = LatLng(-7.250445, 112.768845);
        Completer<LatLng?>? fetchCompleter;
        var polygonRound = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: BlocProvider.value(
              value: bloc,
              child: CreateJagaTanahPage(
                autoFetchLocation: false,
                regionsUsecase: GetJagaTanahRegionsUsecase(repository),
                mapPreviewBuilder: (_, center) =>
                    Text('MapPreview ${center.latitude.toStringAsFixed(3)}'),
                onFetchLocationOverride: (_) {
                  fetchCompleter = Completer<LatLng?>();
                  return fetchCompleter!.future;
                },
                onOpenPolygonOverride:
                    (_, {initialCenter, initialPoints = const []}) async {
                      polygonRound++;
                      if (polygonRound == 1) {
                        return samplePolygon;
                      }
                      return const [
                        LatLng(-7.561000, 112.631000),
                        LatLng(-7.561000, 112.631900),
                        LatLng(-7.561900, 112.631900),
                        LatLng(-7.561900, 112.631000),
                      ];
                    },
                addressResolverOverride: (position) async {
                  if ((position.latitude - gpsPoint.latitude).abs() < 0.001) {
                    return (
                      province: 'Jawa Timur',
                      regency: 'Kota Surabaya',
                      district: 'Gubeng',
                      village: 'Airlangga',
                      landmarkAddress: 'Jl. Dharmawangsa No. 10',
                    );
                  }
                  return (
                    province: 'Jawa Timur',
                    regency: 'Kab. Mojokerto',
                    district: 'Ngoro',
                    village: 'Sukomulyo',
                    landmarkAddress: 'Jl. Raya Sukomulyo',
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Step 1 -> Step 2
        await tester.tap(find.text('Pilih kategori laporan'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Tanah Kas Desa'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextFormField).first,
          'Pengawasan Lahan Desa',
        );
        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();

        // 1. Field kosong -> simpan polygon pertama kali auto-fill semua wilayah & patokan
        await tester.ensureVisible(find.text('Tambahkan Arsiran'));
        await tester.tap(find.text('Tambahkan Arsiran'));
        await tester.pumpAndSettle();

        expect(find.text('4 titik sudut'), findsOneWidget);
        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);
        expect(find.text('NGORO'), findsOneWidget);
        expect(find.text('SUKOMULYO'), findsOneWidget);
        expect(find.text('Jl. Raya Sukomulyo'), findsOneWidget);

        // 2. Tap Ambil Lokasi -> loading state tampil, lalu overwrite wilayah & patokan sambil menjaga polygonPoints
        await tester.ensureVisible(find.text('Ambil Lokasi'));
        await tester.tap(find.text('Ambil Lokasi'));
        await tester.pump();
        expect(find.text('Mengambil lokasi...'), findsOneWidget);

        fetchCompleter!.complete(gpsPoint);
        await tester.pumpAndSettle();

        expect(find.text('Ambil Lokasi'), findsOneWidget);
        expect(find.text('MapPreview -7.250'), findsOneWidget);
        expect(find.text('KOTA SURABAYA'), findsOneWidget);
        expect(find.text('GUBENG'), findsOneWidget);
        expect(find.text('AIRLANGGA'), findsOneWidget);
        expect(find.text('Jl. Dharmawangsa No. 10'), findsOneWidget);
        expect(find.text('4 titik sudut'), findsOneWidget);

        // 3. Edit patokan secara manual -> simpan polygon via Ubah Arsiran
        //    Patokan manual dan wilayah terpilih tidak tertimpa.
        final landmarkField = find.widgetWithText(
          TextFormField,
          'Jl. Dharmawangsa No. 10',
        );
        await tester.ensureVisible(landmarkField);
        await tester.enterText(landmarkField, 'Patokan Manual Linmas');
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Ubah Arsiran'));
        await tester.tap(find.text('Ubah Arsiran'));
        await tester.pumpAndSettle();

        expect(find.text('Patokan Manual Linmas'), findsOneWidget);
        expect(find.text('Jl. Raya Sukomulyo'), findsNothing);
        expect(find.text('KOTA SURABAYA'), findsOneWidget);
        expect(find.text('GUBENG'), findsOneWidget);
        expect(find.text('AIRLANGGA'), findsOneWidget);
        expect(find.text('4 titik sudut'), findsOneWidget);

        // Cek layar sempit 320x640 + zoom 200% aman tanpa overflow
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        await tester.binding.setSurfaceSize(const Size(320, 640));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'JagaTanahSpatialCard menampilkan toggle Peta Default dan Hybrid/Satelit, info polygon serta tombol Ubah Titik di luar peta, dan aman di layar sempit Dark/Light + zoom 200%',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        var openCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: JagaTanahSpatialCard(
                  latitude: -7.56045,
                  longitude: 112.63045,
                  polygonPoints: samplePolygon,
                  showMapTypeToggle: true,
                  initialMapType: MapType.normal,
                  onOpenMap: () => openCount++,
                  mapPreviewBuilder: (_, center) =>
                      Center(child: Text('Preview ${center.latitude}')),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final mapRect = tester.getRect(
          find.byKey(const ValueKey('jaga_tanah_spatial_map_container')),
        );
        expect(find.text('Peta Default'), findsOneWidget);
        expect(find.text('Hybrid / Satelit'), findsOneWidget);
        expect(find.text('Ubah Arsiran'), findsOneWidget);
        expect(find.text('4 titik sudut'), findsOneWidget);
        expect(find.textContaining('Perkiraan luas: ±'), findsOneWidget);
        expect(
          tester.getRect(find.text('4 titik sudut')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );
        expect(
          tester.getRect(find.textContaining('Perkiraan luas: ±')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );
        expect(
          tester.getRect(find.text('Ubah Arsiran')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );

        final indicatorFinder = find.byKey(
          const ValueKey('jaga_tanah_map_type_indicator'),
        );
        expect(
          tester.widget<AnimatedAlign>(indicatorFinder).alignment,
          Alignment.centerLeft,
        );

        await tester.tap(find.text('Hybrid / Satelit'));
        await tester.pumpAndSettle();
        expect(
          tester.widget<AnimatedAlign>(indicatorFinder).alignment,
          Alignment.centerRight,
        );

        await tester.tap(find.byTooltip('Ubah Arsiran'));
        await tester.pumpAndSettle();
        expect(openCount, 1);

        await tester.tap(find.text('Ubah Arsiran'));
        await tester.pumpAndSettle();
        expect(openCount, 2);

        // Uji kondisi belum ada titik + Dark Theme + layar sempit 320x640 + zoom 200%
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        await tester.binding.setSurfaceSize(const Size(320, 640));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: JagaTanahSpatialCard(
                  latitude: null,
                  longitude: null,
                  polygonPoints: samplePolygon,
                  showMapTypeToggle: true,
                  onOpenMap: () => openCount++,
                  mapPreviewBuilder: (_, center) =>
                      Center(child: Text('Preview ${center.latitude}')),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: JagaTanahSpatialCard(
                  latitude: null,
                  longitude: null,
                  onOpenMap: () => openCount++,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Tambahkan Arsiran'), findsOneWidget);
        final emptyMapRect = tester.getRect(
          find.byKey(const ValueKey('jaga_tanah_spatial_map_container')),
        );
        expect(
          tester.getRect(find.text('Tambahkan Arsiran')).top,
          greaterThanOrEqualTo(emptyMapRect.bottom),
        );
        await tester.ensureVisible(find.text('Tambahkan Arsiran'));
        await tester.tap(find.text('Tambahkan Arsiran'));
        await tester.pumpAndSettle();
        expect(openCount, 3);
      },
    );

    testWidgets(
      'JagaTanahReviewStep menampilkan ringkasan Titik Bidang Tanah saat polygon diisi',
      (tester) async {
        const draft = JagaTanahFormDraft(
          categoryId: 20,
          categoryLabel: 'Tanah Kas Desa',
          title: 'Pengawasan Lahan Desa',
          province: 'Jawa Timur',
          regency: 'Kab. Mojokerto',
          district: 'Ngoro',
          village: 'Sukomulyo',
          landmarkAddress: 'Barat Balai Desa',
          latitude: -7.56045,
          longitude: 112.63045,
          polygonPoints: samplePolygon,
          photoPaths: ['/tmp/foto_1.jpg'],
          aksesLokasi: 'Jalan Aspal',
          kondisiUtama: 'Terawat',
          penutupLahan: 'Pertanian',
          penggunaanTerlihat: 'Lahan Kosong',
          tingkatPenggunaan: 'Tidak Digunakan',
          pemeliharaanFasilitas: 'Baik',
          sumberInformasiKondisi: 'Pengamatan Langsung',
          sumberInformasiPenguasaan: 'Warga Sekitar',
          tandaPenguasaan: 'Pagar',
          informasiKonflik: 'Tidak Ada',
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: JagaTanahReviewStep(
                  draft: draft,
                  onEditStep: (_) {},
                  mapPreviewBuilder: (_, center) =>
                      Text('ReviewMap ${center.latitude.toStringAsFixed(3)}'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final mapRect = tester.getRect(
          find.byKey(const ValueKey('jaga_tanah_spatial_map_container')),
        );
        expect(find.text('Titik Bidang Tanah'), findsOneWidget);
        expect(find.textContaining('4 titik (±'), findsOneWidget);
        expect(find.text('4 titik sudut'), findsOneWidget);
        expect(find.textContaining('Perkiraan luas: ±'), findsOneWidget);
        expect(
          tester.getRect(find.text('4 titik sudut')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );
        expect(
          tester.getRect(find.textContaining('Perkiraan luas: ±')).top,
          greaterThanOrEqualTo(mapRect.bottom),
        );
        expect(find.text('Ubah Arsiran'), findsNothing);
        expect(find.text('Tambahkan Arsiran'), findsNothing);
      },
    );

    testWidgets(
      'JagaTanahPolygonPickerPage mendukung tap tambah, geser 1 titik, hapus 1 titik, Undo, Reset, Simpan (>=3 titik) pada Light/Dark dan layar sempit',
      (tester) async {
        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          tester.view.physicalSize = const Size(360, 640);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          List<LatLng>? savedPoints;
          var nextTapIndex = 0;
          const movedPoint = LatLng(-7.561234, 112.631234);

          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: Builder(
                builder: (context) => Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        savedPoints = await Navigator.of(context)
                            .push<List<LatLng>>(
                              MaterialPageRoute(
                                builder: (_) => JagaTanahPolygonPickerPage(
                                  initialCenter: samplePolygon.first,
                                  mapBuilder:
                                      (
                                        _, {
                                        required initialCenter,
                                        required points,
                                        required selectedIndex,
                                        required onTapPoint,
                                        required onSelectPoint,
                                        required onMovePoint,
                                      }) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              onTapPoint(
                                                samplePolygon[nextTapIndex %
                                                    samplePolygon.length],
                                              );
                                              nextTapIndex++;
                                            },
                                            child: Text(
                                              'Simulasi Tap (${points.length})',
                                            ),
                                          ),
                                          if (points.length >= 2)
                                            ElevatedButton(
                                              onPressed: () => onSelectPoint(1),
                                              child: const Text(
                                                'Pilih Titik 2',
                                              ),
                                            ),
                                          if (points.isNotEmpty)
                                            ElevatedButton(
                                              onPressed: () =>
                                                  onMovePoint(0, movedPoint),
                                              child: const Text(
                                                'Geser Titik 1',
                                              ),
                                            ),
                                        ],
                                      ),
                                ),
                              ),
                            );
                      },
                      child: const Text('Buka Picker'),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.tap(find.text('Buka Picker'));
          await tester.pumpAndSettle();

          ElevatedButton saveButton() => tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Simpan Bidang'),
          );

          expect(saveButton().onPressed, isNull);
          expect(
            find.text('Ketuk peta untuk menandai titik sudut pertama'),
            findsOneWidget,
          );

          // Tambah 2 titik -> Simpan masih nonaktif
          await tester.tap(find.text('Simulasi Tap (0)'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Simulasi Tap (1)'));
          await tester.pumpAndSettle();
          expect(saveButton().onPressed, isNull);
          expect(find.text('2 titik sudut'), findsOneWidget);

          // Undo -> kembali ke 1 titik
          await tester.tap(find.text('Undo'));
          await tester.pumpAndSettle();
          expect(find.text('1 titik sudut'), findsOneWidget);

          // Reset -> kembali ke 0 titik
          await tester.tap(find.text('Reset'));
          await tester.pumpAndSettle();
          expect(find.text('0 titik sudut'), findsOneWidget);

          // Tambah 4 titik, hapus hanya Titik 2, lalu geser Titik 1
          for (var i = 0; i < 4; i++) {
            await tester.tap(find.text('Simulasi Tap ($i)'));
            await tester.pumpAndSettle();
          }
          expect(find.text('4 titik sudut'), findsOneWidget);

          await tester.tap(find.text('Pilih Titik 2'));
          await tester.pumpAndSettle();
          expect(find.text('Titik 2 dipilih'), findsOneWidget);

          await tester.tap(find.text('Hapus Titik'));
          await tester.pumpAndSettle();
          expect(find.text('3 titik sudut'), findsOneWidget);
          expect(find.text('Titik 2 dipilih'), findsNothing);

          await tester.tap(find.text('Geser Titik 1'));
          await tester.pumpAndSettle();
          expect(saveButton().onPressed, isNotNull);

          await tester.tap(find.text('Simpan Bidang'));
          await tester.pumpAndSettle();

          expect(savedPoints, isNotNull);
          expect(savedPoints!.length, 3);
          expect(savedPoints!.first, movedPoint);
        }
      },
    );
  });

  group('Jaga Tanah Region Picker UI', () {
    Future<void> goToStep2(
      WidgetTester tester, {
      required _FakeJagaTanahRepository repository,
      bool autoFetchLocation = false,
      ThemeData? theme,
      Future<LatLng?> Function(BuildContext context)? onFetchLocationOverride,
      JagaTanahMapLocationPickerOpener? onPickMapLocationOverride,
      JagaTanahAdminAddressResolver? addressResolverOverride,
      Future<String?> Function(BuildContext context)? onPickPhotoOverride,
    }) async {
      final bloc = CreateJagaTanahBloc(
        createReport: CreateJagaTanahReportUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      )..add(const LoadJagaTanahCategoriesEvent());
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          key: UniqueKey(),
          theme: theme ?? AppTheme.lightTheme,
          home: BlocProvider.value(
            value: bloc,
            child: CreateJagaTanahPage(
              key: UniqueKey(),
              autoFetchLocation: autoFetchLocation,
              regionsUsecase: GetJagaTanahRegionsUsecase(repository),
              mapPreviewBuilder: (_, center) =>
                  Text('Map ${center.latitude.toStringAsFixed(3)}'),
              onFetchLocationOverride: onFetchLocationOverride,
              onPickMapLocationOverride: onPickMapLocationOverride,
              addressResolverOverride: addressResolverOverride,
              onPickPhotoOverride: onPickPhotoOverride,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih kategori laporan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tanah Kas Desa'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'Pengawasan Lahan Wilayah',
      );
      await tester.tap(find.text('Lanjut'));
      if (autoFetchLocation) {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      } else {
        await tester.pumpAndSettle();
      }
    }

    testWidgets(
      'cascading picker, pencarian lokal, dan reset anak saat induk berubah',
      (tester) async {
        final repository = _FakeJagaTanahRepository();
        await goToStep2(tester, repository: repository);

        // Tap Kabupaten sebelum Provinsi menampilkan peringatan
        await tester.tap(find.text('Pilih kabupaten/kota'));
        await tester.pumpAndSettle();
        expect(find.text('Pilih Provinsi terlebih dahulu.'), findsOneWidget);
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();

        // Buka Provinsi -> cari 'timur' -> cari 'zzzz' -> Reset Pencarian -> pilih JAWA TIMUR
        await tester.tap(find.text('Pilih provinsi'));
        await tester.pumpAndSettle();
        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('DKI JAKARTA'), findsOneWidget);
        final callsBeforeSearch = repository.provincesCalls;

        final searchField = find.descendant(
          of: find.byType(JagaTanahRegionSheet),
          matching: find.byType(TextField),
        );
        await tester.enterText(searchField, 'timur');
        await tester.pumpAndSettle();
        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('DKI JAKARTA'), findsNothing);
        expect(repository.provincesCalls, callsBeforeSearch);

        await tester.enterText(searchField, 'zzzz');
        await tester.pumpAndSettle();
        expect(find.text('Tidak ditemukan untuk "zzzz".'), findsOneWidget);
        await tester.tap(find.text('Reset Pencarian'));
        await tester.pumpAndSettle();
        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('DKI JAKARTA'), findsOneWidget);

        await tester.tap(find.text('JAWA TIMUR'));
        await tester.pumpAndSettle();
        expect(find.text('JAWA TIMUR'), findsOneWidget);

        // Pilih Kabupaten -> Kecamatan -> Desa
        await tester.tap(find.text('Pilih kabupaten/kota'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('KABUPATEN MOJOKERTO'));
        await tester.pumpAndSettle();
        expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);

        await tester.tap(find.text('Pilih kecamatan'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('NGORO'));
        await tester.pumpAndSettle();
        expect(find.text('NGORO'), findsOneWidget);

        await tester.tap(find.text('Pilih desa/kelurahan'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('SUKOMULYO'));
        await tester.pumpAndSettle();
        expect(find.text('SUKOMULYO'), findsOneWidget);

        // Pilih ulang Provinsi yang sama -> pilihan anak tetap terjaga
        await tester.tap(find.text('JAWA TIMUR'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(JagaTanahRegionSheet),
            matching: find.text('JAWA TIMUR'),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);
        expect(find.text('NGORO'), findsOneWidget);
        expect(find.text('SUKOMULYO'), findsOneWidget);

        // Ubah Provinsi ke DKI JAKARTA -> semua anak ter-reset
        await tester.tap(find.text('JAWA TIMUR'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('DKI JAKARTA'));
        await tester.pumpAndSettle();

        expect(find.text('DKI JAKARTA'), findsOneWidget);
        expect(find.text('Pilih kabupaten/kota'), findsOneWidget);
        expect(find.text('Pilih kecamatan'), findsOneWidget);
        expect(find.text('Pilih desa/kelurahan'), findsOneWidget);
      },
    );

    testWidgets(
      'JagaTanahRegionSheet menampilkan loading, error+Coba Lagi, empty+Muat Ulang, dan daftar hasil',
      (tester) async {
        final completer =
            Completer<Either<Failure, List<JagaTanahRegionEntity>>>();
        final forceRefreshFlags = <bool>[];
        var attempt = 0;
        JagaTanahRegionEntity? picked;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    JagaTanahRegionSheet.show(
                      context,
                      title: 'Pilih Provinsi',
                      searchHint: 'Cari provinsi...',
                      loader: ({bool forceRefresh = false}) async {
                        forceRefreshFlags.add(forceRefresh);
                        attempt++;
                        if (attempt == 1) return completer.future;
                        if (attempt == 2) return const Right([]);
                        return const Right([
                          JagaTanahRegionEntity(id: '35', name: 'JAWA TIMUR'),
                        ]);
                      },
                      onSelected: (item) => picked = item,
                    );
                  },
                  child: const Text('Buka Sheet'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Buka Sheet'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        // 1. Loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Memuat daftar...'), findsOneWidget);

        // 2. Error + Coba Lagi
        completer.complete(const Left(ServerFailure('Server wilayah gagal')));
        await tester.pumpAndSettle();
        expect(find.text('Server wilayah gagal'), findsOneWidget);
        expect(find.text('Coba Lagi'), findsOneWidget);

        // 3. Empty + Muat Ulang
        await tester.tap(find.text('Coba Lagi'));
        await tester.pumpAndSettle();
        expect(forceRefreshFlags, [false, true]);
        expect(find.text('Data wilayah belum tersedia.'), findsOneWidget);
        expect(find.text('Muat Ulang'), findsOneWidget);

        // 4. Loaded list + select
        await tester.tap(find.text('Muat Ulang'));
        await tester.pumpAndSettle();
        expect(forceRefreshFlags, [false, true, true]);
        expect(find.text('JAWA TIMUR'), findsOneWidget);

        await tester.tap(find.text('JAWA TIMUR'));
        await tester.pumpAndSettle();
        expect(picked?.id, '35');
        expect(picked?.name, 'JAWA TIMUR');
      },
    );

    testWidgets(
      'sinkronisasi lokasi otomatis mengisi 4 wilayah resmi, menangani partial match, offline fallback, dan race guard',
      (tester) async {
        // 1. Ambil Lokasi full match -> tampil resmi & muncul di Review
        final repoFull = _FakeJagaTanahRepository();
        await goToStep2(
          tester,
          repository: repoFull,
          onFetchLocationOverride: (_) async => const LatLng(-7.56, 112.63),
          addressResolverOverride: (_) async => (
            province: 'Jawa Timur',
            regency: 'Kab. Mojokerto',
            district: 'Kec. Ngoro',
            village: 'Desa Sukomulyo',
            landmarkAddress: 'Jl. Merdeka',
          ),
          onPickPhotoOverride: (_) async => '/tmp/non_existent_region.webp',
        );

        await tester.ensureVisible(find.text('Ambil Lokasi'));
        await tester.tap(find.text('Ambil Lokasi'));
        await tester.pumpAndSettle();

        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);
        expect(find.text('NGORO'), findsOneWidget);
        expect(find.text('SUKOMULYO'), findsOneWidget);

        // Lengkapi foto + akses lokasi -> lanjut ke Review & verifikasi nama wilayah resmi
        final photoBtn = find.descendant(
          of: find.byType(JagaTanahAttachmentSection),
          matching: find.text('Foto'),
        );
        await tester.ensureVisible(photoBtn);
        await tester.tap(photoBtn);
        await tester.pumpAndSettle();

        Future<void> pickDropdown(String hint, String option) async {
          final target = find.text(hint);
          await tester.ensureVisible(target);
          await tester.tap(target);
          await tester.pumpAndSettle();
          await tester.tap(find.text(option));
          await tester.pumpAndSettle();
        }

        await pickDropdown('Pilih akses menuju lokasi', 'Jalan lingkungan');
        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();

        await pickDropdown(
          'Pilih kondisi utama di lapangan',
          'Sebagian dimanfaatkan',
        );
        await pickDropdown('Pilih penutup lahan dominan', 'Semak belukar');
        await pickDropdown('Pilih penggunaan yang terlihat', 'Perkebunan');
        await pickDropdown(
          'Pilih tingkat penggunaan lahan',
          'Rendah (< 25% dari luas)',
        );
        await pickDropdown(
          'Pilih kondisi pemeliharaan',
          'Tidak terpelihara (tidak ada aktivitas)',
        );
        await pickDropdown(
          'Pilih sumber informasi kondisi',
          'Pengamatan langsung oleh Aslinmas',
        );
        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();

        await pickDropdown(
          'Pilih sumber informasi penguasaan',
          'Papan di lokasi',
        );
        await pickDropdown(
          'Pilih tanda penguasaan di lokasi',
          'Ada papan, tanpa pagar',
        );
        await pickDropdown(
          'Pilih status informasi konflik',
          'Tidak ada informasi',
        );
        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();

        expect(find.byType(JagaTanahReviewStep), findsOneWidget);
        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);
        expect(find.text('NGORO'), findsOneWidget);
        expect(find.text('SUKOMULYO'), findsOneWidget);

        // 2. Partial match: desa tidak cocok -> Provinsi/Kabupaten/Kecamatan terisi, Desa kosong, catatan tampil
        final repoPartial = _FakeJagaTanahRepository();
        await goToStep2(
          tester,
          repository: repoPartial,
          onFetchLocationOverride: (_) async => const LatLng(-7.56, 112.63),
          addressResolverOverride: (_) async => (
            province: 'Jawa Timur',
            regency: 'Kab. Mojokerto',
            district: 'Kec. Ngoro',
            village: 'Desa Fiktif',
            landmarkAddress: 'Jl. Merdeka',
          ),
        );

        await tester.ensureVisible(find.text('Ambil Lokasi'));
        await tester.tap(find.text('Ambil Lokasi'));
        await tester.pumpAndSettle();

        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);
        expect(find.text('NGORO'), findsOneWidget);
        expect(find.text('Pilih desa/kelurahan'), findsOneWidget);
        expect(
          find.text(
            'Sebagian wilayah otomatis belum cocok. Silakan pilih sisanya secara manual.',
          ),
          findsOneWidget,
        );

        // 3. Offline fallback: API wilayah error + ada GPS -> tidak terblokir di Step 2
        final repoOffline = _FakeJagaTanahRepository()
          ..provincesOverride = const Left(NetworkFailure('Tidak ada koneksi'));
        await goToStep2(
          tester,
          repository: repoOffline,
          onFetchLocationOverride: (_) async => const LatLng(-7.56, 112.63),
          addressResolverOverride: (_) async => (
            province: 'Jawa Timur',
            regency: 'Kab. Mojokerto',
            district: 'Kec. Ngoro',
            village: 'Desa Sukomulyo',
            landmarkAddress: 'Jl. Merdeka',
          ),
          onPickPhotoOverride: (_) async => '/tmp/non_existent_offline.webp',
        );

        await tester.ensureVisible(find.text('Ambil Lokasi'));
        await tester.tap(find.text('Ambil Lokasi'));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Daftar wilayah sedang tidak dapat dimuat. Anda dapat memilih ulang saat online atau lanjut dengan koordinat GPS.',
          ),
          findsOneWidget,
        );
        final offlinePhotoBtn = find.descendant(
          of: find.byType(JagaTanahAttachmentSection),
          matching: find.text('Foto'),
        );
        await tester.ensureVisible(offlinePhotoBtn);
        await tester.tap(offlinePhotoBtn);
        await tester.pumpAndSettle();
        await pickDropdown('Pilih akses menuju lokasi', 'Jalan lingkungan');

        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();
        expect(find.text('Kondisi Penggunaan & Pemanfaatan'), findsOneWidget);

        // 3b. Cached Provinsi berhasil + child Regency gagal offline -> catatan tampil & tetap bisa lanjut ke Step 3
        final repoCachedProvOfflineReg = _FakeJagaTanahRepository()
          ..regenciesOverride = const Left(NetworkFailure('Tidak ada koneksi'));
        await goToStep2(
          tester,
          repository: repoCachedProvOfflineReg,
          onFetchLocationOverride: (_) async => const LatLng(-7.56, 112.63),
          addressResolverOverride: (_) async => (
            province: 'Jawa Timur',
            regency: 'Kab. Mojokerto',
            district: 'Kec. Ngoro',
            village: 'Desa Sukomulyo',
            landmarkAddress: 'Jl. Merdeka',
          ),
          onPickPhotoOverride: (_) async =>
              '/tmp/non_existent_cached_offline.webp',
        );

        await tester.ensureVisible(find.text('Ambil Lokasi'));
        await tester.tap(find.text('Ambil Lokasi'));
        await tester.pumpAndSettle();

        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('Pilih kabupaten/kota'), findsOneWidget);
        expect(
          find.text(
            'Daftar wilayah sedang tidak dapat dimuat. Anda dapat memilih ulang saat online atau lanjut dengan koordinat GPS.',
          ),
          findsOneWidget,
        );
        final cachedOfflinePhotoBtn = find.descendant(
          of: find.byType(JagaTanahAttachmentSection),
          matching: find.text('Foto'),
        );
        await tester.ensureVisible(cachedOfflinePhotoBtn);
        await tester.tap(cachedOfflinePhotoBtn);
        await tester.pumpAndSettle();
        await pickDropdown('Pilih akses menuju lokasi', 'Jalan lingkungan');

        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();
        expect(find.text('Kondisi Penggunaan & Pemanfaatan'), findsOneWidget);

        // 4. Race guard: auto-sync lambat tidak menimpa pilihan manual Provinsi
        final slowLocationCompleter = Completer<LatLng?>();
        final repoRace = _FakeJagaTanahRepository();
        await goToStep2(
          tester,
          repository: repoRace,
          autoFetchLocation: true,
          onFetchLocationOverride: (_) => slowLocationCompleter.future,
          addressResolverOverride: (_) async => (
            province: 'Jawa Timur',
            regency: 'Kab. Mojokerto',
            district: 'Kec. Ngoro',
            village: 'Desa Sukomulyo',
            landmarkAddress: 'Jl. Merdeka',
          ),
        );

        // User memilih Provinsi manual saat auto-sync masih berjalan
        await tester.tap(find.text('Pilih provinsi'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        await tester.tap(find.text('DKI JAKARTA'));
        await tester.pumpAndSettle();
        expect(find.text('DKI JAKARTA'), findsOneWidget);

        // Auto-sync selesai belakangan -> tidak boleh menimpa DKI JAKARTA
        slowLocationCompleter.complete(const LatLng(-7.56, 112.63));
        await tester.pumpAndSettle();
        expect(find.text('DKI JAKARTA'), findsOneWidget);
        expect(find.text('JAWA TIMUR'), findsNothing);
      },
    );

    testWidgets(
      'Step 2 region picker dan JagaTanahRegionSheet aman di 320x640 dengan zoom 200% pada Light dan Dark theme',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          final repository = _FakeJagaTanahRepository()
            ..provincesOverride = const Right([
              JagaTanahRegionEntity(id: '71', name: 'SULAWESI UTARA'),
            ])
            ..regenciesOverride = const Right([
              JagaTanahRegionEntity(
                id: '7109',
                name: 'KABUPATEN KEPULAUAN SIAU TAGULANDANG BIARO',
              ),
            ]);

          tester.platformDispatcher.clearTextScaleFactorTestValue();
          await tester.binding.setSurfaceSize(const Size(360, 780));
          await goToStep2(tester, repository: repository, theme: theme);

          await tester.tap(find.text('Pilih provinsi'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('SULAWESI UTARA'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Pilih kabupaten/kota'));
          await tester.pumpAndSettle();
          await tester.tap(
            find.text('KABUPATEN KEPULAUAN SIAU TAGULANDANG BIARO'),
          );
          await tester.pumpAndSettle();

          tester.platformDispatcher.textScaleFactorTestValue = 2.0;
          await tester.binding.setSurfaceSize(const Size(320, 640));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          await tester.ensureVisible(
            find.text('KABUPATEN KEPULAUAN SIAU TAGULANDANG BIARO'),
          );
          await tester.tap(
            find.text('KABUPATEN KEPULAUAN SIAU TAGULANDANG BIARO'),
          );
          await tester.pumpAndSettle();
          expect(find.byType(JagaTanahRegionSheet), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tester.tap(find.byTooltip('Tutup'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      },
    );

    testWidgets(
      'Tombol Ambil Lokasi memakai warna yang sama dengan Ubah Titik dan sejajar dengan Pilih dari Maps serta sinkron ke wilayah',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(390, 844));

        final repository = _FakeJagaTanahRepository();
        await goToStep2(
          tester,
          repository: repository,
          onPickMapLocationOverride:
              (context, {initialAddress, initialPosition}) async =>
                  const LocationPickerResult(
                    address: 'Jl. Pahlawan No. 10, Sukomulyo',
                    position: LatLng(-7.561, 112.631),
                  ),
          addressResolverOverride: (_) async => (
            province: 'Jawa Timur',
            regency: 'Kab. Mojokerto',
            district: 'Kec. Ngoro',
            village: 'Desa Sukomulyo',
            landmarkAddress: 'Jl. Pahlawan No. 10, Sukomulyo',
          ),
        );

        final ambilButtonFinder = find.ancestor(
          of: find.text('Ambil Lokasi'),
          matching: find.byType(OutlinedButton),
        );
        final pilihMapsButtonFinder = find.ancestor(
          of: find.text('Pilih dari Maps'),
          matching: find.byType(OutlinedButton),
        );
        final ubahTitikButtonFinder = find.ancestor(
          of: find.text('Tambahkan Arsiran'),
          matching: find.byType(OutlinedButton),
        );

        expect(ambilButtonFinder, findsOneWidget);
        expect(pilihMapsButtonFinder, findsOneWidget);
        expect(ubahTitikButtonFinder, findsOneWidget);

        final ambilRect = tester.getRect(ambilButtonFinder);
        final pilihMapsRect = tester.getRect(pilihMapsButtonFinder);
        expect((ambilRect.top - pilihMapsRect.top).abs(), lessThanOrEqualTo(2));
        expect(pilihMapsRect.left, greaterThan(ambilRect.right));

        final ambilStyle = tester
            .widget<OutlinedButton>(ambilButtonFinder)
            .style!;
        final pilihMapsStyle = tester
            .widget<OutlinedButton>(pilihMapsButtonFinder)
            .style!;
        final ubahTitikStyle = tester
            .widget<OutlinedButton>(ubahTitikButtonFinder)
            .style!;
        expect(
          ambilStyle.backgroundColor?.resolve({}),
          ubahTitikStyle.backgroundColor?.resolve({}),
        );
        expect(
          ambilStyle.foregroundColor?.resolve({}),
          ubahTitikStyle.foregroundColor?.resolve({}),
        );
        expect(
          pilihMapsStyle.backgroundColor?.resolve({}),
          ubahTitikStyle.backgroundColor?.resolve({}),
        );

        await tester.ensureVisible(pilihMapsButtonFinder);
        await tester.tap(pilihMapsButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('JAWA TIMUR'), findsOneWidget);
        expect(find.text('KABUPATEN MOJOKERTO'), findsOneWidget);
        expect(find.text('NGORO'), findsOneWidget);
        expect(find.text('SUKOMULYO'), findsOneWidget);
        expect(find.text('Jl. Pahlawan No. 10, Sukomulyo'), findsOneWidget);
        expect(find.text('Map -7.561'), findsOneWidget);
      },
    );
  });
}
