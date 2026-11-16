import 'dart:io';

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
import 'package:flutter_test/flutter_test.dart';

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
  String? lastStatusFilter;
  String? lastCategoryFilter;
  int? lastCategoryId;
  int? lastSubCategoryId;

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
  }) async {
    lastCategoryId = categoryId;
    lastSubCategoryId = subCategoryId;
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
          ),
        );
        state = await bloc.stream.firstWhere(
          (s) => s.submitStatus == CreateJagaTanahSubmitStatus.success,
        );
        expect(repository.lastCategoryId, 21);
        expect(repository.lastSubCategoryId, 22);
        expect(state.submittedReport?.ticketNumber, 'PGD-2026-00089');
      },
    );
  });
}
