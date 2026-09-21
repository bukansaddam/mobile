import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_category_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/usecases/add_institusi_usecase.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/usecases/get_institusi_categories_usecase.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/usecases/get_institusi_list_usecase.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/usecases/update_institusi_usecase.dart';

part 'institusi_event.dart';
part 'institusi_state.dart';

enum InstitusiSortOption {
  terbaru('Terbaru'),
  namaAz('Nama (A-Z)'),
  namaZa('Nama (Z-A)');

  final String label;
  const InstitusiSortOption(this.label);
}

class InstitusiBloc extends Bloc<InstitusiEvent, InstitusiState> {
  final GetInstitusiListUsecase getInstitusiListUsecase;
  final AddInstitusiUsecase addInstitusiUsecase;
  final UpdateInstitusiUsecase updateInstitusiUsecase;
  final GetInstitusiCategoriesUsecase getCategoriesUsecase;

  List<InstitusiCategoryEntity> categories = [];
  bool isCategoriesLoading = false;

  List<String> get categoryOptions {
    if (categories.isNotEmpty) {
      return categories.map((c) => c.label).toList();
    }
    return DemografiConstants.institusiKategoriOptions;
  }

  List<InstitusiEntity> listInstitusi = [];
  int? page = 1;
  int limit = 10;
  int total = 0;

  String searchQuery = '';
  String? selectedScopeFilter;
  String? selectedKategoriFilter;
  InstitusiSortOption selectedSortOption = InstitusiSortOption.terbaru;

  bool get hasActiveFilter =>
      selectedScopeFilter != null ||
      selectedKategoriFilter != null ||
      selectedSortOption != InstitusiSortOption.terbaru;

  List<InstitusiEntity> get displayList {
    List<InstitusiEntity> list = List.from(listInstitusi);
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((inst) => inst.nama.toLowerCase().contains(q)).toList();
    }
    if (selectedScopeFilter != null && selectedScopeFilter!.trim().isNotEmpty) {
      list = list
          .where(
            (i) =>
                i.scope.toLowerCase().replaceAll('/', '_') ==
                selectedScopeFilter!.toLowerCase().replaceAll('/', '_'),
          )
          .toList();
    }
    if (selectedKategoriFilter != null &&
        selectedKategoriFilter!.trim().isNotEmpty) {
      list = list
          .where(
            (i) =>
                i.displayKategori.toLowerCase() ==
                selectedKategoriFilter!.toLowerCase(),
          )
          .toList();
    }
    switch (selectedSortOption) {
      case InstitusiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case InstitusiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case InstitusiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }
    return list;
  }

  InstitusiBloc({
    required this.getInstitusiListUsecase,
    required this.addInstitusiUsecase,
    required this.updateInstitusiUsecase,
    required this.getCategoriesUsecase,
  }) : super(InstitusiInitial()) {
    on<GetInstitusiCategoriesEvent>(_onGetCategories);
    on<GetInstitusiEvent>(_onGetInstitusi);
    on<RefreshInstitusiEvent>(_onRefreshInstitusi);
    on<SetInstitusiFilterEvent>(_onSetFilter);
    on<ResetInstitusiFilterEvent>(_onResetFilter);
    on<CreateInstitusiEvent>(_onCreateInstitusi);
    on<UpdateInstitusiEvent>(_onUpdateInstitusi);

    add(const GetInstitusiCategoriesEvent());
    add(const RefreshInstitusiEvent());
  }

  Future<void> _onGetCategories(
    GetInstitusiCategoriesEvent event,
    Emitter<InstitusiState> emit,
  ) async {
    isCategoriesLoading = true;
    final result = await getCategoriesUsecase.call(domain: event.domain);
    result.fold(
      (failure) {
        isCategoriesLoading = false;
      },
      (data) {
        categories = data.where((c) => c.isActive).toList();
        isCategoriesLoading = false;
        if (state is InstitusiLoaded) {
          emit(
            InstitusiLoaded((state as InstitusiLoaded).paginated, categories),
          );
        } else {
          emit(InstitusiLoaded(null, categories));
        }
      },
    );
  }

  Future<void> _onGetInstitusi(
    GetInstitusiEvent event,
    Emitter<InstitusiState> emit,
  ) async {
    if (page == null) return;

    if (page == 1) {
      emit(InstitusiLoading());
    }

    final querySearch = (event.search != null)
        ? (event.search!.trim().isNotEmpty ? event.search!.trim() : null)
        : (searchQuery.trim().isNotEmpty ? searchQuery.trim() : null);
    final filterScope = (event.scope != null)
        ? (event.scope!.trim().isNotEmpty ? event.scope!.trim() : null)
        : (selectedScopeFilter?.trim().isNotEmpty == true
              ? selectedScopeFilter!.trim()
              : null);
    final filterKategori = (event.kategori != null)
        ? (event.kategori!.trim().isNotEmpty ? event.kategori!.trim() : null)
        : (selectedKategoriFilter?.trim().isNotEmpty == true
              ? selectedKategoriFilter!.trim()
              : null);

    final result = await getInstitusiListUsecase.call(
      page: page!,
      perPage: limit,
      scope: filterScope,
      name: querySearch,
      label: filterKategori,
    );

    result.fold(
      (failure) {
        emit(InstitusiFailure(failure.message));
      },
      (paginated) {
        listInstitusi.addAll(paginated.data);
        total = paginated.total;
        emit(InstitusiLoaded(paginated, categories));

        if (paginated.data.length < limit ||
            paginated.currentPage >= paginated.lastPage) {
          page = null;
        } else {
          page = page! + 1;
        }
      },
    );
  }

  Future<void> _onRefreshInstitusi(
    RefreshInstitusiEvent event,
    Emitter<InstitusiState> emit,
  ) async {
    listInstitusi.clear();
    page = 1;
    if (event.search != null) {
      searchQuery = event.search!;
    }
    if (event.scope != null) {
      selectedScopeFilter = event.scope!.trim().isNotEmpty
          ? event.scope!.trim()
          : null;
    }
    if (event.kategori != null) {
      selectedKategoriFilter = event.kategori!.trim().isNotEmpty
          ? event.kategori!.trim()
          : null;
    }
    if (event.sort != null) {
      selectedSortOption = event.sort!;
    }
    add(
      GetInstitusiEvent(
        search: searchQuery,
        scope: selectedScopeFilter,
        kategori: selectedKategoriFilter,
        sort: selectedSortOption,
      ),
    );
  }

  void _onSetFilter(
    SetInstitusiFilterEvent event,
    Emitter<InstitusiState> emit,
  ) {
    if (event.hasScope) {
      selectedScopeFilter =
          (event.scope != null && event.scope!.trim().isNotEmpty)
          ? event.scope!.trim()
          : null;
    }
    if (event.hasKategori) {
      selectedKategoriFilter =
          (event.kategori != null && event.kategori!.trim().isNotEmpty)
          ? event.kategori!.trim()
          : null;
    }
    if (event.sort != null) {
      selectedSortOption = event.sort!;
    }
    if (event.search != null) {
      searchQuery = event.search!;
    }
    add(
      RefreshInstitusiEvent(
        search: searchQuery,
        scope: selectedScopeFilter,
        kategori: selectedKategoriFilter,
        sort: selectedSortOption,
      ),
    );
  }

  void _onResetFilter(
    ResetInstitusiFilterEvent event,
    Emitter<InstitusiState> emit,
  ) {
    selectedScopeFilter = null;
    selectedKategoriFilter = null;
    selectedSortOption = InstitusiSortOption.terbaru;
    searchQuery = '';
    add(
      const RefreshInstitusiEvent(
        search: '',
        scope: '',
        kategori: '',
        sort: InstitusiSortOption.terbaru,
      ),
    );
  }

  Future<void> _onCreateInstitusi(
    CreateInstitusiEvent event,
    Emitter<InstitusiState> emit,
  ) async {
    emit(InstitusiActionLoading());

    int? catId = event.categoryId;
    if (catId == null && event.kategori != null && event.kategori!.isNotEmpty) {
      final match = categories.where(
        (c) => c.label.toLowerCase() == event.kategori!.toLowerCase(),
      );
      if (match.isNotEmpty) {
        catId = match.first.id;
      }
    }

    final entity = InstitusiEntity(
      nama: event.nama,
      scope: event.scope,
      kategori: event.kategori,
      categoryId: catId,
      alamat: event.alamat,
      provinceId: event.provinceId,
      regencyId: event.regencyId,
      districtId: event.districtId,
      villageId: event.villageId,
      createdAt: DateTime.now(),
    );

    final result = await addInstitusiUsecase.call(entity);

    result.fold(
      (failure) {
        emit(InstitusiActionFailure(message: failure.message));
      },
      (newInstitusi) {
        final merged = newInstitusi.copyWith(
          kategori:
              (newInstitusi.kategori != null &&
                  newInstitusi.kategori != 'Pemerintahan & Birokrasi')
              ? newInstitusi.kategori
              : (event.kategori ?? 'Institusi'),
          categoryId: newInstitusi.categoryId ?? catId,
        );
        listInstitusi.insert(0, merged);
        total += 1;
        emit(
          InstitusiActionSuccess(
            institusi: merged,
            message: 'Institusi berhasil ditambahkan',
          ),
        );
      },
    );
  }

  Future<void> _onUpdateInstitusi(
    UpdateInstitusiEvent event,
    Emitter<InstitusiState> emit,
  ) async {
    emit(InstitusiActionLoading());

    int? catId = event.categoryId;
    if (catId == null && event.kategori != null && event.kategori!.isNotEmpty) {
      final match = categories.where(
        (c) => c.label.toLowerCase() == event.kategori!.toLowerCase(),
      );
      if (match.isNotEmpty) {
        catId = match.first.id;
      }
    }

    final entity = InstitusiEntity(
      id: event.id,
      nama: event.nama,
      scope: event.scope,
      kategori: event.kategori,
      categoryId: catId,
      alamat: event.alamat,
      provinceId: event.provinceId,
      regencyId: event.regencyId,
      districtId: event.districtId,
      villageId: event.villageId,
      updatedAt: DateTime.now(),
    );

    final result = await updateInstitusiUsecase.call(
      id: event.id,
      entity: entity,
    );

    result.fold(
      (failure) {
        emit(InstitusiActionFailure(message: failure.message));
      },
      (updatedInstitusi) {
        final index = listInstitusi.indexWhere((i) => i.id == event.id);
        if (index != -1) {
          final existing = listInstitusi[index];
          final merged = updatedInstitusi.copyWith(
            kategori:
                (updatedInstitusi.kategori != null &&
                    updatedInstitusi.kategori != 'Pemerintahan & Birokrasi')
                ? updatedInstitusi.kategori
                : (event.kategori ?? existing.kategori),
            categoryId:
                updatedInstitusi.categoryId ?? catId ?? existing.categoryId,
            province: updatedInstitusi.province ?? existing.province,
            regency: updatedInstitusi.regency ?? existing.regency,
            district: updatedInstitusi.district ?? existing.district,
            village: updatedInstitusi.village ?? existing.village,
            createdAt: updatedInstitusi.createdAt ?? existing.createdAt,
          );
          listInstitusi[index] = merged;
          emit(
            InstitusiActionSuccess(
              institusi: merged,
              message: 'Institusi berhasil diperbarui',
            ),
          );
        } else {
          listInstitusi.insert(0, updatedInstitusi);
          emit(
            InstitusiActionSuccess(
              institusi: updatedInstitusi,
              message: 'Institusi berhasil diperbarui',
            ),
          );
        }
      },
    );
  }
}
