import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/data/datasources/jaga_tanah_remote_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/create_jaga_tanah_report_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_categories_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_my_jaga_tanah_reports_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
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

    test(
      'mengelompokkan anak berdasarkan parent_id bila field children kosong dan melewati item nonaktif',
      () {
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
      },
    );
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
    test(
      'memuat kategori, retry saat gagal, dan meneruskan categoryId + subCategoryId',
      () async {
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
            conditionInfoSource: 'Pengamatan langsung oleh Linmas',
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
          'Pengamatan langsung oleh Linmas',
        );
        expect(repository.lastTenureInfoSource, 'Papan di lokasi');
        expect(repository.lastPossessionMarkers, 'Ada papan, tanpa pagar');
        expect(repository.lastConflictInfo, 'Tidak ada informasi');
        expect(repository.lastIdempotencyKey, 'jgt-test-key-001');
        expect(state.submittedReport?.ticketNumber, 'PGD-2026-00089');
      },
    );
  });

  group('JagaTanahRemoteDatasourceImpl.createReport', () {
    test(
      'mengirim multipart FormData lengkap + X-Idempotency-Key ke POST /api/jaga-tanah-reports dan mengurai root 201 ticketNumber',
      () async {
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
                'message':
                    'Laporan Jaga Tanah berhasil dikirim dan sedang diproses untuk verifikasi (< 24 jam).',
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
          conditionInfoSource: 'Pengamatan langsung oleh Linmas',
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
          'Pengamatan langsung oleh Linmas',
        );
        expect(fields['tenure_info_source'], 'Papan di lokasi');
        expect(fields['possession_markers'], 'Ada papan, tanpa pagar');
        expect(fields['conflict_info'], 'Tidak ada informasi');
        expect(formData.files.map((e) => e.key), contains('attachments[]'));
      },
    );

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
}
