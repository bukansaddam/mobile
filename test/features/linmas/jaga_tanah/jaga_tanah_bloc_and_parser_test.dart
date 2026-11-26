import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/data/datasources/jaga_tanah_remote_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/data/models/jaga_tanah_detail_model.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/create_jaga_tanah_report_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_detail_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_my_jaga_tanah_reports_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_detail_bloc/jaga_tanah_detail_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_list_bloc/jaga_tanah_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDioAdapter implements HttpClientAdapter {
  _FakeDioAdapter(this.onFetch);

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => onFetch(options);

  @override
  void close({bool force = false}) {}
}

class _FakeJagaTanahRepository implements JagaTanahRepository {
  Either<Failure, ComplaintPaginatedEntity>? listResult;
  Either<Failure, List<JagaTanahCategoryEntity>> categoriesResult = const Right(
    [
      JagaTanahCategoryEntity(
        id: 20,
        code: 'tanah_kas_desa',
        label: 'Tanah Kas Desa',
        colorHex: '#10B981',
        sortOrder: 1,
      ),
      JagaTanahCategoryEntity(
        id: 21,
        code: 'tanah_pemda',
        label: 'Tanah Pemda',
        colorHex: '#3B82F6',
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
    ],
  );
  Either<Failure, ComplaintReportEntity> createResult = const Right(
    ComplaintReportEntity(id: '89', ticketNumber: 'PGD-2026-00089'),
  );
  Either<Failure, JagaTanahDetailEntity> detailResult = const Right(
    JagaTanahDetailEntity(
      id: '89',
      ticketNumber: 'JGT-2611200001',
      title: 'Laporan Tanah 89',
    ),
  );

  int listCalls = 0;
  int categoryCalls = 0;
  int createCalls = 0;
  String? lastStatusFilter;
  String? lastCategoryFilter;
  String? lastTitle;
  String? lastDescription;
  String? lastAddress;
  double? lastLatitude;
  double? lastLongitude;
  List<File>? lastAttachments;
  int? lastCategoryId;
  int? lastSubCategoryId;
  String? lastType;
  String? lastLocationAccess;
  String? lastFieldCondition;
  String? lastDominantLandCover;
  String? lastVisibleUsage;
  String? lastUsageLevel;
  String? lastMaintenanceStatus;
  String? lastConditionInfoSource;
  String? lastTenureInfoSource;
  String? lastPossessionMarkers;
  String? lastConflictInfo;
  Map<String, dynamic>? lastBoundaryGeojson;
  String? lastEstimatedArea;
  String? lastIdempotencyKey;

  ComplaintReportEntity _sampleReport(String id) => ComplaintReportEntity(
    id: id,
    ticketNumber: 'PGD-2026-000$id',
    title: 'Laporan Tanah $id',
    category: 'Tanah Kas Desa',
    status: 'new',
    statusLabel: 'Laporan Masuk',
  );

  @override
  Future<Either<Failure, ComplaintPaginatedEntity>> getMyReports({
    int page = 1,
    int perPage = 20,
    String? status,
    String? category,
  }) async {
    listCalls++;
    lastStatusFilter = status;
    lastCategoryFilter = category;
    return listResult ??
        Right(
          ComplaintPaginatedEntity(
            data: [_sampleReport('$page')],
            currentPage: page,
            lastPage: 2,
            total: 2,
          ),
        );
  }

  @override
  Future<Either<Failure, List<JagaTanahCategoryEntity>>> getCategories() async {
    categoryCalls++;
    return categoriesResult;
  }

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getProvinces({
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getRegencies(
    String provinceId, {
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getDistricts(
    String regencyId, {
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<JagaTanahRegionEntity>>> getVillages(
    String districtId, {
    bool forceRefresh = false,
  }) async => const Right([]);

  String? lastDetailId;
  int detailCalls = 0;

  @override
  Future<Either<Failure, JagaTanahDetailEntity>> getReportDetail(
    String id,
  ) async {
    detailCalls++;
    lastDetailId = id;
    return detailResult;
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
    lastTitle = title;
    lastDescription = description;
    lastAddress = address;
    lastLatitude = latitude;
    lastLongitude = longitude;
    lastAttachments = attachments;
    lastCategoryId = categoryId;
    lastSubCategoryId = subCategoryId;
    lastType = type;
    lastLocationAccess = locationAccess;
    lastFieldCondition = fieldCondition;
    lastDominantLandCover = dominantLandCover;
    lastVisibleUsage = visibleUsage;
    lastUsageLevel = usageLevel;
    lastMaintenanceStatus = maintenanceStatus;
    lastConditionInfoSource = conditionInfoSource;
    lastTenureInfoSource = tenureInfoSource;
    lastPossessionMarkers = possessionMarkers;
    lastConflictInfo = conflictInfo;
    lastBoundaryGeojson = boundaryGeojson;
    lastEstimatedArea = estimatedArea;
    lastIdempotencyKey = idempotencyKey;
    return createResult;
  }
}

void main() {
  group('JagaTanahRemoteDatasourceImpl.parseCategoryTree', () {
    test(
      'mengurai kategori bertingkat dan menduplikasi baris anak dengan benar',
      () {
        final rawPayload = {
          'success': true,
          'data': [
            {
              'id': 20,
              'label': 'Tanah Kas Desa',
              'code': 'tanah_kas_desa',
              'is_active': true,
              'sort_order': 1,
              'parent_id': null,
              'color': '#10B981',
              'children': [],
            },
            {
              'id': 21,
              'label': 'Tanah Pemda',
              'code': 'tanah_pemda',
              'is_active': true,
              'sort_order': 2,
              'parent_id': null,
              'color': '#3B82F6',
              'children': [
                {
                  'id': 22,
                  'label': 'Kabupaten/Kota',
                  'code': 'tanah_pemda_kabupaten_kota',
                  'is_active': true,
                  'parent_id': 21,
                  'sort_order': 1,
                },
                {
                  'id': 23,
                  'label': 'Provinsi',
                  'code': 'tanah_pemda_provinsi',
                  'is_active': true,
                  'parent_id': 21,
                  'sort_order': 2,
                },
                {
                  'id': 24,
                  'label': 'Kecamatan',
                  'code': 'tanah_pemda_kecamatan',
                  'is_active': true,
                  'parent_id': 21,
                  'sort_order': 3,
                },
              ],
            },
            {
              'id': 22,
              'label': 'Kabupaten/Kota',
              'code': 'tanah_pemda_kabupaten_kota',
              'is_active': true,
              'parent_id': 21,
              'sort_order': 1,
            },
            {
              'id': 23,
              'label': 'Provinsi',
              'code': 'tanah_pemda_provinsi',
              'is_active': true,
              'parent_id': 21,
              'sort_order': 2,
            },
          ],
        };

        final categories = JagaTanahRemoteDatasourceImpl.parseCategoryTree(
          rawPayload,
        );

        expect(categories, hasLength(2));
        expect(categories[0].label, 'Tanah Kas Desa');
        expect(categories[0].hasSubCategories, isFalse);
        expect(categories[1].label, 'Tanah Pemda');
        expect(categories[1].hasSubCategories, isTrue);
        expect(categories[1].children.map((c) => c.id), [22, 23, 24]);
      },
    );

    test('mengelompokkan anak berdasarkan parent_id bila field children kosong dan melewati item nonaktif', () {
      final rawPayload = {
        'data': [
          {
            'id': 21,
            'label': 'Tanah Pemda',
            'code': 'tanah_pemda',
            'is_active': true,
            'sort_order': 2,
            'parent_id': null,
          },
          {
            'id': 24,
            'label': 'Kecamatan',
            'code': 'tanah_pemda_kecamatan',
            'is_active': true,
            'parent_id': 21,
            'sort_order': 3,
          },
          {
            'id': 99,
            'label': 'Nonaktif',
            'code': 'disabled',
            'is_active': false,
            'parent_id': 21,
            'sort_order': 1,
          },
        ],
      };

      final categories = JagaTanahRemoteDatasourceImpl.parseCategoryTree(
        rawPayload,
      );

      expect(categories, hasLength(1));
      expect(categories.single.children, hasLength(1));
      expect(categories.single.children.single.label, 'Kecamatan');
    });
  });

  group('JagaTanahListBloc', () {
    test('memuat list, pagination, search lokal, dan filter server', () async {
      final repository = _FakeJagaTanahRepository();
      final bloc = JagaTanahListBloc(
        getMyReports: GetMyJagaTanahReportsUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      );
      addTearDown(bloc.close);

      bloc.add(const FetchJagaTanahReportsEvent());
      var state = await bloc.stream.firstWhere(
        (s) => s.status == JagaTanahListStatus.loaded,
      );
      expect(state.items, hasLength(1));
      expect(state.hasReachedMax, isFalse);

      bloc.add(const LoadMoreJagaTanahReportsEvent());
      state = await bloc.stream.firstWhere(
        (s) => s.items.length == 2 && !s.isLoadingMore,
      );
      expect(state.currentPage, 2);
      expect(state.hasReachedMax, isTrue);

      bloc.add(const SearchJagaTanahReportsEvent('Tanah 2'));
      state = await bloc.stream.firstWhere((s) => s.searchQuery == 'Tanah 2');
      expect(state.filteredItems.single.id, '2');

      bloc.add(
        const ApplyJagaTanahFilterEvent(
          status: 'in_progress',
          category: 'tanah_pemda_kabupaten_kota',
        ),
      );
      state = await bloc.stream.firstWhere(
        (s) =>
            s.status == JagaTanahListStatus.loaded &&
            s.statusFilter == 'in_progress' &&
            s.categoryFilter == 'tanah_pemda_kabupaten_kota',
      );
      expect(repository.lastStatusFilter, 'in_progress');
      expect(repository.lastCategoryFilter, 'tanah_pemda_kabupaten_kota');
      expect(state.activeFilterCount, 2);
    });
  });

  group('CreateJagaTanahBloc', () {
    test('memuat kategori, retry saat gagal, dan meneruskan categoryId + subCategoryId', () async {
      final repository = _FakeJagaTanahRepository()
        ..categoriesResult = const Left(ServerFailure('Gagal kategori'));
      final bloc = CreateJagaTanahBloc(
        createReport: CreateJagaTanahReportUsecase(repository),
        getCategories: GetJagaTanahCategoriesUsecase(repository),
      );
      addTearDown(bloc.close);

      bloc.add(const LoadJagaTanahCategoriesEvent());
      var state = await bloc.stream.firstWhere(
        (s) => !s.isLoadingCategories && s.categoryError != null,
      );
      expect(state.categoryError, 'Gagal kategori');

      repository.categoriesResult = const Right([
        JagaTanahCategoryEntity(
          id: 21,
          code: 'tanah_pemda',
          label: 'Tanah Pemda',
          children: [
            JagaTanahCategoryEntity(
              id: 22,
              code: 'tanah_pemda_kabupaten_kota',
              label: 'Kabupaten/Kota',
              parentId: 21,
            ),
          ],
        ),
      ]);
      bloc.add(const LoadJagaTanahCategoriesEvent(force: true));
      state = await bloc.stream.firstWhere(
        (s) => !s.isLoadingCategories && s.categories.isNotEmpty,
      );
      expect(state.categories.single.hasSubCategories, isTrue);

      bloc.add(
        SubmitJagaTanahReportEvent(
          title: 'Patok batas rusak',
          description: 'Patok batas tanah pemda mengalami pergeseran.',
          address: 'Jl. Merdeka Selatan',
          latitude: -6.18,
          longitude: 106.82,
          attachments: [File('/tmp/foto.jpg')],
          categoryId: 21,
          subCategoryId: 22,
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
          idempotencyKey: 'jgt-test-key-001',
        ),
      );
      state = await bloc.stream.firstWhere(
        (s) => s.submitStatus == CreateJagaTanahSubmitStatus.success,
      );
      expect(repository.createCalls, 1);
      expect(repository.lastTitle, 'Patok batas rusak');
      expect(
        repository.lastDescription,
        'Patok batas tanah pemda mengalami pergeseran.',
      );
      expect(repository.lastAddress, 'Jl. Merdeka Selatan');
      expect(repository.lastLatitude, -6.18);
      expect(repository.lastLongitude, 106.82);
      expect(repository.lastCategoryId, 21);
      expect(repository.lastSubCategoryId, 22);
      expect(repository.lastType, 'point');
      expect(repository.lastLocationAccess, 'Jalan lingkungan');
      expect(repository.lastFieldCondition, 'Sebagian dimanfaatkan');
      expect(repository.lastDominantLandCover, 'Semak belukar');
      expect(repository.lastVisibleUsage, 'Perkebunan');
      expect(repository.lastUsageLevel, 'Rendah (< 25% dari luas)');
      expect(
        repository.lastMaintenanceStatus,
        'Tidak terpelihara (tidak ada aktivitas)',
      );
      expect(
        repository.lastConditionInfoSource,
        'Pengamatan langsung oleh Aslinmas',
      );
      expect(repository.lastTenureInfoSource, 'Papan di lokasi');
      expect(repository.lastPossessionMarkers, 'Ada papan, tanpa pagar');
      expect(repository.lastConflictInfo, 'Tidak ada informasi');
      expect(repository.lastIdempotencyKey, 'jgt-test-key-001');
      expect(state.submittedReport?.ticketNumber, 'PGD-2026-00089');
    });
  });

  group('JagaTanahRemoteDatasourceImpl.createReport', () {
    test('mengirim multipart FormData lengkap + X-Idempotency-Key ke POST /api/jaga-tanah-reports dan mengurai root 201 ticketNumber', () async {
      final tempDir = Directory.systemTemp.createTempSync('jaga_tanah_ds_');
      addTearDown(() => tempDir.deleteSync(recursive: true));
      final sampleVideo = File('${tempDir.path}/evidence.mp4')
        ..writeAsBytesSync(const [0, 0, 0, 24, 102, 116, 121, 112]);

      RequestOptions? capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((options) async {
          capturedOptions = options;
          return ResponseBody.fromString(
            jsonEncode({
              'id': 89,
              'ticketNumber': 'JGT-2611200001',
              'message': 'Laporan Jaga Tanah berhasil dikirim dan sedang diproses untuk verifikasi (< 24 jam).',
              'success': true,
            }),
            201,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });
      final datasource = JagaTanahRemoteDatasourceImpl(dio: dio);

      final result = await datasource.createReport(
        title: 'Indikasi okupasi tanah kas desa',
        description: 'Terdapat patok baru di sisi selatan',
        address: '± 500 m arah barat Balai Desa',
        latitude: -7.983921,
        longitude: 112.621508,
        attachments: [sampleVideo],
        categoryId: 21,
        subCategoryId: 22,
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
        idempotencyKey: 'jgt-idemp-001',
      );

      expect(result.id?.toString(), '89');
      expect(result.ticketNumber, 'JGT-2611200001');
      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.method, 'POST');
      expect(capturedOptions!.path, ApiConstants.jagaTanahReports);
      expect(
        capturedOptions!.headers['X-Idempotency-Key'],
        equals('jgt-idemp-001'),
      );

      final formData = capturedOptions!.data as FormData;
      final fields = Map.fromEntries(formData.fields);
      expect(fields['category_id'], '21');
      expect(fields['sub_category_id'], '22');
      expect(fields['title'], 'Indikasi okupasi tanah kas desa');
      expect(fields['description'], 'Terdapat patok baru di sisi selatan');
      expect(fields['address'], '± 500 m arah barat Balai Desa');
      expect(fields['type'], 'point');
      expect(fields['latitude'], '-7.983921');
      expect(fields['longitude'], '112.621508');
      expect(fields['location_access'], 'Jalan lingkungan');
      expect(fields['field_condition'], 'Sebagian dimanfaatkan');
      expect(fields['dominant_land_cover'], 'Semak belukar');
      expect(fields['visible_usage'], 'Perkebunan');
      expect(fields['usage_level'], 'Rendah (< 25% dari luas)');
      expect(
        fields['maintenance_status'],
        'Tidak terpelihara (tidak ada aktivitas)',
      );
      expect(
        fields['condition_info_source'],
        'Pengamatan langsung oleh Aslinmas',
      );
      expect(fields['tenure_info_source'], 'Papan di lokasi');
      expect(fields['possession_markers'], 'Ada papan, tanpa pagar');
      expect(fields['conflict_info'], 'Tidak ada informasi');
      expect(formData.files.map((e) => e.key), contains('attachments[]'));
    });

    test('melempar ValidationException saat server membalas 422', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((_) async {
          return ResponseBody.fromString(
            jsonEncode({
              'success': false,
              'message': 'Validasi gagal.',
              'errors': [
                {
                  'field': 'latitude',
                  'error': 'The latitude field is required.',
                },
              ],
            }),
            422,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });
      final datasource = JagaTanahRemoteDatasourceImpl(dio: dio);

      await expectLater(
        datasource.createReport(
          title: 'Tes validasi',
          description: '',
          address: 'Jl. Uji',
          latitude: -6.2,
          longitude: 106.8,
          attachments: const [],
          categoryId: 20,
        ),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.message,
            'message',
            'Validasi gagal.: The latitude field is required.',
          ),
        ),
      );
    });

    test(
      'melempar ServerException saat server membalas 409 conflict',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
          ..httpClientAdapter = _FakeDioAdapter((_) async {
            return ResponseBody.fromString(
              jsonEncode({
                'success': false,
                'message':
                    'Laporan dengan idempotency key ini sedang diproses.',
              }),
              409,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          });
        final datasource = JagaTanahRemoteDatasourceImpl(dio: dio);

        await expectLater(
          datasource.createReport(
            title: 'Tes conflict',
            description: '',
            address: 'Jl. Uji',
            latitude: -6.2,
            longitude: 106.8,
            attachments: const [],
            categoryId: 20,
            idempotencyKey: 'dup-key',
          ),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Laporan dengan idempotency key ini sedang diproses.',
            ),
          ),
        );
      },
    );
  });

  group('JagaTanahDetailModel.fromJson', () {
    test('mengurai struktur nested detail Jaga Tanah lengkap dengan bpn_feedback dan timeline', () {
      final detail = JagaTanahDetailModel.fromJson({
        'report': {
          'id': 89,
          'ticketNumber': 'JGT-2611200001',
          'title': 'Lahan Kas Desa Sukomulyo',
          'description': 'Sebagian lahan semak belukar',
          'status': 'bpn_forwarded',
          'statusLabel': 'Diteruskan ke BPN',
          'category': {
            'id': 22,
            'label': 'Kabupaten/Kota',
            'parent': {'id': 21, 'label': 'Tanah Pemda'},
          },
          'reportedAt': '2026-11-20T08:00:00+00:00',
          'escalation_level': 1,
        },
        'location': {
          'address': '± 500 m arah barat Balai Desa',
          'province': 'Jawa Timur',
          'regency': 'Kab. Mojokerto',
          'district': 'Ngoro',
          'village': 'Sukomulyo',
          'latitude': -7.983921,
          'longitude': 112.621508,
          'object_shape': 'Satu bidang tanah',
          'estimated_area': '> 5 - 10 Ha',
          'location_access': 'Jalan lingkungan',
        },
        'condition': {
          'field_condition': 'Sebagian dimanfaatkan',
          'dominant_land_cover': 'Semak belukar',
          'visible_usage': 'Perkebunan',
          'usage_level': 'Rendah (< 25% dari luas)',
          'maintenance_status': 'Tidak terpelihara (tidak ada aktivitas)',
          'condition_info_source': 'Pengamatan langsung oleh Aslinmas',
        },
        'tenure': {
          'tenure_info_source': 'Papan di lokasi',
          'possession_markers': 'Ada papan, tanpa pagar',
          'conflict_info': 'Tidak ada informasi',
        },
        'verification': {
          'verifier_unit': 'DPC Kab. Mojokerto',
          'verification_method': 'both',
          'verification_summary': 'Titik sesuai batas fisik.',
        },
        'follow_up': {
          'follow_up_decision': 'bpn',
          'follow_up_notes': 'Koordinasi cek sertifikat ke Kantah.',
          'bpn_action_type': 'cek_status_hak',
        },
        'bpn_feedbacks': [
          {
            'source_institution': 'BPN Kab. Mojokerto',
            'land_right_type': 'HP',
            'land_right_number_nib': 'HP-12.01.00045',
            'bpn_reference_number': 'BPN/2026/89',
            'status': 'certificate_checked',
            'summary': 'Tercatat atas nama Pemkab.',
          },
        ],
        'attachments': [
          {
            'id': 12,
            'mime_type': 'image/jpeg',
            'file_url': '/api/jaga-tanah-reports/attachments/12/file',
          },
        ],
        'timeline': [
          {
            'type': 'submitted',
            'description': 'Laporan Jaga Tanah dikirim.',
            'actor': {'name': 'Petugas A'},
            'created_at': '2026-11-20T08:00:00+00:00',
          },
        ],
      }).entity;

      expect(detail.id, '89');
      expect(detail.ticketNumber, 'JGT-2611200001');
      expect(detail.category, 'Tanah Pemda');
      expect(detail.subCategory, 'Kabupaten/Kota');
      expect(detail.escalationLevel, 1);
      expect(detail.province, 'Jawa Timur');
      expect(detail.locationAccess, 'Jalan lingkungan');
      expect(detail.fieldCondition, 'Sebagian dimanfaatkan');
      expect(detail.tenureInfoSource, 'Papan di lokasi');
      expect(detail.verifierUnit, 'DPC Kab. Mojokerto');
      expect(detail.landRightType, 'HP');
      expect(detail.landRightNumberNib, 'HP-12.01.00045');
      expect(
        detail.attachments.single.url,
        '${ApiConstants.baseUrl}/api/jaga-tanah-reports/attachments/12/file',
      );
      expect(detail.timeline.single.actorName, 'Petugas A');
    });

    test('mengurai payload flat snake_case dan fallback URL lampiran ID', () {
      final detail = JagaTanahDetailModel.fromJson({
        'id': 90,
        'ticket_number': 'JGT-2611200002',
        'title': 'Tanah Kas Desa Barat',
        'status': 'verified',
        'category': 'Tanah Kas Desa',
        'address': 'Dusun Krajan',
        'latitude': '-7.500000',
        'longitude': '112.100000',
        'location_access': 'Jalan aspal / utama',
        'attachments': [
          {'id': 55, 'file_name': 'video_bukti.mp4'},
        ],
      }).entity;

      expect(detail.id, '90');
      expect(detail.ticketNumber, 'JGT-2611200002');
      expect(detail.latitude, closeTo(-7.5, 0.0001));
      expect(detail.longitude, closeTo(112.1, 0.0001));
      expect(detail.locationAccess, 'Jalan aspal / utama');
      expect(detail.attachments.single.isVideo, isTrue);
      expect(
        detail.attachments.single.url,
        '${ApiConstants.baseUrl}/api/jaga-tanah-reports/attachments/55/file',
      );
    });

    test('mengurai wrapper spatialAndCondition dari response detail live', () {
      final detail = JagaTanahDetailModel.fromJson({
        'report': {
          'id': 91,
          'ticketNumber': 'JGT-2611200003',
          'title': 'Tanah Fasos RW 04',
          'status': 'submitted',
        },
        'spatialAndCondition': {
          'objectShape': null,
          'estimatedArea': null,
          'locationAccess': 'Jalan tanah / setapak',
          'fieldCondition': 'Sebagian dimanfaatkan',
          'dominantLandCover': 'Bangunan permanen',
          'visibleUsage': 'Fasilitas umum / sosial',
          'usageLevel': 'Sedang (25% - 75% dari luas)',
          'maintenanceStatus': 'Kurang terpelihara',
          'conditionInfoSource': 'Informasi perangkat desa / kelurahan',
          'tenureInfoSource': 'Papan di lokasi',
          'possessionMarkers': 'Ada pagar / patok, tanpa papan',
          'conflictInfo': 'Ada indikasi konflik / sengketa',
        },
      }).entity;

      expect(detail.objectShape, isNull);
      expect(detail.estimatedArea, isNull);
      expect(detail.locationAccess, 'Jalan tanah / setapak');
      expect(detail.fieldCondition, 'Sebagian dimanfaatkan');
      expect(detail.dominantLandCover, 'Bangunan permanen');
      expect(detail.visibleUsage, 'Fasilitas umum / sosial');
      expect(detail.usageLevel, 'Sedang (25% - 75% dari luas)');
      expect(detail.maintenanceStatus, 'Kurang terpelihara');
      expect(
        detail.conditionInfoSource,
        'Informasi perangkat desa / kelurahan',
      );
      expect(detail.tenureInfoSource, 'Papan di lokasi');
      expect(detail.possessionMarkers, 'Ada pagar / patok, tanpa papan');
      expect(detail.conflictInfo, 'Ada indikasi konflik / sengketa');
    });
  });

  group('JagaTanahRemoteDatasourceImpl.getReportDetail', () {
    test('mengambil detail dari GET /api/jaga-tanah-reports/{id} dan melempar NotFoundException pada 404', () async {
      RequestOptions? capturedOptions;
      var returnNotFound = false;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((options) async {
          capturedOptions = options;
          if (returnNotFound) {
            return ResponseBody.fromString(
              jsonEncode({'success': false, 'message': 'Laporan tidak ada.'}),
              404,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'id': 89,
                'ticketNumber': 'JGT-2611200001',
                'title': 'Okupasi Lahan',
                'status': 'submitted',
                'field_condition': 'Terbengkalai / tidak dimanfaatkan',
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });
      final datasource = JagaTanahRemoteDatasourceImpl(dio: dio);

      final detailModel = await datasource.getReportDetail('89');
      expect(capturedOptions!.method, 'GET');
      expect(capturedOptions!.path, ApiConstants.jagaTanahReportDetail('89'));
      expect(detailModel.entity.ticketNumber, 'JGT-2611200001');
      expect(
        detailModel.entity.fieldCondition,
        'Terbengkalai / tidak dimanfaatkan',
      );

      returnNotFound = true;
      await expectLater(
        datasource.getReportDetail('999'),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('JagaTanahDetailBloc', () {
    test(
      'memuat detail dan mempertahankan detail lama saat refresh gagal',
      () async {
        final repository = _FakeJagaTanahRepository();
        final bloc = JagaTanahDetailBloc(
          getReportDetail: GetJagaTanahDetailUsecase(repository),
        );
        addTearDown(bloc.close);

        bloc.add(const FetchJagaTanahDetailEvent('89'));
        var state = await bloc.stream.firstWhere(
          (s) => s.status == JagaTanahDetailStatus.loaded,
        );
        expect(repository.lastDetailId, '89');
        expect(state.detail?.ticketNumber, 'JGT-2611200001');

        repository.detailResult = const Left(ServerFailure('Jaringan putus'));
        bloc.add(const FetchJagaTanahDetailEvent('89', isRefresh: true));
        state = await bloc.stream.firstWhere(
          (s) => s.status == JagaTanahDetailStatus.failure,
        );
        expect(state.detail?.ticketNumber, 'JGT-2611200001');
        expect(state.errorMessage, 'Jaringan putus');
        expect(state.isRefreshing, isFalse);
      },
    );
  });

  group('JagaTanahDetailModel hybrid points parsing', () {
    test('parses points_awarded from nested report or root and keeps null when absent', () {
      final withNestedPoints = JagaTanahDetailModel.fromJson({
        'report': {
          'id': 91,
          'ticket_number': 'JGT-2611200091',
          'title': 'Lahan Desa',
          'status': 'verified',
          'points_awarded': 15,
        },
      });
      expect(withNestedPoints.entity.pointsAwarded, 15);

      final withoutPoints = JagaTanahDetailModel.fromJson({
        'id': 92,
        'ticket_number': 'JGT-2611200092',
        'title': 'Lahan Pemda',
        'status': 'submitted',
      });
      expect(withoutPoints.entity.pointsAwarded, isNull);
    });
  });

  group('JagaTanahRemoteDatasourceImpl.createReport boundary_geojson', () {
    test('serializes boundary_geojson as JSON string in FormData when provided and omits when null', () async {
      final capturedFields = <Map<String, String>>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((options) async {
          final formData = options.data as FormData;
          capturedFields.add(Map.fromEntries(formData.fields));
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'data': {'id': 101, 'ticket_number': 'JGT-101'},
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });
      final datasource = JagaTanahRemoteDatasourceImpl(dio: dio);

      const boundary = {
        'type': 'Polygon',
        'coordinates': [
          [
            [106.8477468, -6.1719736],
            [106.8483068, -6.1719736],
            [106.8483068, -6.1715336],
            [106.8477468, -6.1715336],
            [106.8477468, -6.1719736],
          ],
        ],
      };

      await datasource.createReport(
        title: 'Lahan Dengan Arsiran',
        description: '',
        address: 'Jl. Merdeka',
        latitude: -6.1717,
        longitude: 106.848,
        attachments: const [],
        categoryId: 20,
        type: 'geometries',
        boundaryGeojson: boundary,
        estimatedArea: '± 2.900 m²',
        skipMediaPreparation: true,
      );

      await datasource.createReport(
        title: 'Lahan Tanpa Arsiran',
        description: '',
        address: 'Jl. Merdeka',
        latitude: -6.1717,
        longitude: 106.848,
        attachments: const [],
        categoryId: 20,
        skipMediaPreparation: true,
      );

      expect(capturedFields, hasLength(2));
      expect(capturedFields[0]['type'], 'geometries');
      expect(capturedFields[0]['estimated_area'], '± 2.900 m²');
      expect(
        jsonDecode(capturedFields[0]['boundary_geojson']!),
        equals(boundary),
      );
      expect(capturedFields[1]['type'], 'point');
      expect(capturedFields[1].containsKey('boundary_geojson'), isFalse);
      expect(capturedFields[1].containsKey('estimated_area'), isFalse);
    });
  });

  group('JagaTanahDetailModel boundaryGeoJson parsing', () {
    test('parses location.boundaryGeoJson closed Polygon ring into distinct LatLng vertices and supports postgisAreaSqm fallback', () {
      final parsed = JagaTanahDetailModel.fromJson({
        'report': {
          'id': 88,
          'ticketNumber': 'JGT-2611250001',
          'title': 'Penyalahgunaan Tanah',
          'status': 'submitted',
        },
        'spatialAndCondition': {'estimatedArea': '± 236 m²'},
        'location': {
          'address': 'Jalan Keselamatan II, Manggarai Selatan',
          'type': 'geometries',
          'geometryType': 'geometries',
          'latitude': -6.220704,
          'longitude': 106.8485926,
          'boundaryGeoJson': {
            'type': 'Polygon',
            'coordinates': [
              [
                [106.84864025563002, -6.22079498492423],
                [106.84866204857826, -6.220641666018301],
                [106.84854470193386, -6.220608002513408],
                [106.84852324426174, -6.220771320487323],
                [106.84864025563002, -6.22079498492423],
              ],
            ],
          },
          'postgisAreaSqm': 234.63,
        },
      }).entity;

      expect(parsed.hasPolygon, isTrue);
      expect(parsed.polygonPoints, hasLength(4));
      expect(parsed.polygonPoints.first.latitude, closeTo(-6.220795, 1e-6));
      expect(parsed.polygonPoints.first.longitude, closeTo(106.848640, 1e-6));
      expect(parsed.estimatedArea, '± 236 m²');

      final fromJsonString = JagaTanahDetailModel.fromJson({
        'id': 89,
        'title': 'Tanah String GeoJSON',
        'location': {
          'boundary_geojson': jsonEncode({
            'type': 'Polygon',
            'coordinates': [
              [
                [112.6, -7.5],
                [112.601, -7.5],
                [112.601, -7.501],
                [112.6, -7.5],
              ],
            ],
          }),
          'postgisAreaSqm': 234.63,
        },
      }).entity;

      expect(fromJsonString.hasPolygon, isTrue);
      expect(fromJsonString.hasSpatialCoordinates, isTrue);
      expect(fromJsonString.polygonPoints, hasLength(3));
      expect(fromJsonString.estimatedArea, '± 235 m²');
    });
  });
}
