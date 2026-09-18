import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/usecases/add_organisasi_usecase.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/usecases/get_organisasi_list_usecase.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/usecases/update_organisasi_usecase.dart';

part 'organisasi_event.dart';
part 'organisasi_state.dart';

class OrganisasiBloc extends Bloc<OrganisasiEvent, OrganisasiState> {
  final GetOrganisasiListUsecase getOrganisasiListUsecase;
  final AddOrganisasiUsecase addOrganisasiUsecase;
  final UpdateOrganisasiUsecase updateOrganisasiUsecase;

  List<OrganisasiEntity> listOrganisasi = [];
  int? page = 1;
  int limit = 10;
  int total = 0;

  String searchQuery = '';
  String? selectedBidangFilter;
  OrganisasiSortOption selectedSortOption = OrganisasiSortOption.terbaru;

  bool get hasActiveFilter =>
      selectedBidangFilter != null ||
      selectedSortOption != OrganisasiSortOption.terbaru;

  List<OrganisasiEntity> get displayList {
    List<OrganisasiEntity> list = List.from(listOrganisasi);
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((org) => org.nama.toLowerCase().contains(q)).toList();
    }
    if (selectedBidangFilter != null &&
        selectedBidangFilter!.trim().isNotEmpty) {
      list = list
          .where(
            (o) =>
                o.bidang.toLowerCase() == selectedBidangFilter!.toLowerCase(),
          )
          .toList();
    }
    switch (selectedSortOption) {
      case OrganisasiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case OrganisasiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case OrganisasiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }
    return list;
  }

  OrganisasiBloc({
    required this.getOrganisasiListUsecase,
    required this.addOrganisasiUsecase,
    required this.updateOrganisasiUsecase,
  }) : super(OrganisasiInitial()) {
    on<GetOrganisasiEvent>(_onGetOrganisasi);
    on<RefreshOrganisasiEvent>(_onRefreshOrganisasi);
    on<SetOrganisasiFilterEvent>(_onSetFilter);
    on<ResetOrganisasiFilterEvent>(_onResetFilter);
    on<CreateOrganisasiEvent>(_onCreateOrganisasi);
    on<UpdateOrganisasiEvent>(_onUpdateOrganisasi);

    add(const RefreshOrganisasiEvent());
  }

  Future<void> _onGetOrganisasi(
    GetOrganisasiEvent event,
    Emitter<OrganisasiState> emit,
  ) async {
    if (page == null) return;

    if (page == 1) {
      emit(OrganisasiLoading());
    }

    final querySearch = (event.search != null)
        ? (event.search!.trim().isNotEmpty ? event.search!.trim() : null)
        : (searchQuery.trim().isNotEmpty ? searchQuery.trim() : null);
    final filterField = (event.field != null)
        ? (event.field!.trim().isNotEmpty ? event.field!.trim() : null)
        : (selectedBidangFilter?.trim().isNotEmpty == true
              ? selectedBidangFilter!.trim()
              : null);

    final result = await getOrganisasiListUsecase.call(
      page: page!,
      perPage: limit,
      field: filterField,
      name: querySearch,
    );

    result.fold(
      (failure) {
        emit(OrganisasiFailure(failure.message));
      },
      (paginated) {
        listOrganisasi.addAll(paginated.data);
        total = paginated.total;
        emit(OrganisasiLoaded(paginated));

        if (paginated.data.length < limit ||
            paginated.currentPage >= paginated.lastPage) {
          page = null;
        } else {
          page = page! + 1;
        }
      },
    );
  }

  Future<void> _onRefreshOrganisasi(
    RefreshOrganisasiEvent event,
    Emitter<OrganisasiState> emit,
  ) async {
    listOrganisasi.clear();
    page = 1;
    if (event.search != null) {
      searchQuery = event.search!;
    }
    if (event.field != null) {
      selectedBidangFilter = event.field!.trim().isNotEmpty
          ? event.field!.trim()
          : null;
    }
    if (event.sort != null) {
      selectedSortOption = event.sort!;
    }
    add(
      GetOrganisasiEvent(
        search: searchQuery,
        field: selectedBidangFilter,
        sort: selectedSortOption,
      ),
    );
  }

  void _onSetFilter(
    SetOrganisasiFilterEvent event,
    Emitter<OrganisasiState> emit,
  ) {
    if (event.hasField) {
      selectedBidangFilter =
          (event.field != null && event.field!.trim().isNotEmpty)
          ? event.field!.trim()
          : null;
    }
    if (event.sort != null) {
      selectedSortOption = event.sort!;
    }
    if (event.search != null) {
      searchQuery = event.search!;
    }
    add(
      RefreshOrganisasiEvent(
        search: searchQuery,
        field: selectedBidangFilter,
        sort: selectedSortOption,
      ),
    );
  }

  void _onResetFilter(
    ResetOrganisasiFilterEvent event,
    Emitter<OrganisasiState> emit,
  ) {
    selectedBidangFilter = null;
    selectedSortOption = OrganisasiSortOption.terbaru;
    searchQuery = '';
    add(
      const RefreshOrganisasiEvent(
        search: '',
        field: '',
        sort: OrganisasiSortOption.terbaru,
      ),
    );
  }

  Future<void> _onCreateOrganisasi(
    CreateOrganisasiEvent event,
    Emitter<OrganisasiState> emit,
  ) async {
    emit(OrganisasiActionLoading());

    final entity = OrganisasiEntity(
      nama: event.nama,
      jumlahAnggota: event.jumlahAnggota,
      bidang: event.bidang,
      alamatSekretariat: event.alamatSekretariat,
      provinceId: event.provinceId,
      regencyId: event.regencyId,
      districtId: event.districtId,
      villageId: event.villageId,
      createdAt: DateTime.now(),
    );

    final result = await addOrganisasiUsecase.call(entity);

    result.fold(
      (failure) {
        emit(OrganisasiActionFailure(failure.message));
      },
      (newOrganisasi) {
        listOrganisasi.insert(0, newOrganisasi);
        total += 1;
        emit(
          OrganisasiActionSuccess(
            organisasi: newOrganisasi,
            message: 'Organisasi berhasil ditambahkan',
          ),
        );
      },
    );
  }

  Future<void> _onUpdateOrganisasi(
    UpdateOrganisasiEvent event,
    Emitter<OrganisasiState> emit,
  ) async {
    emit(OrganisasiActionLoading());

    final entity = OrganisasiEntity(
      id: event.id,
      nama: event.nama,
      jumlahAnggota: event.jumlahAnggota,
      bidang: event.bidang,
      alamatSekretariat: event.alamatSekretariat,
      provinceId: event.provinceId,
      regencyId: event.regencyId,
      districtId: event.districtId,
      villageId: event.villageId,
      updatedAt: DateTime.now(),
    );

    final result = await updateOrganisasiUsecase.call(
      id: event.id,
      entity: entity,
    );

    result.fold(
      (failure) {
        emit(OrganisasiActionFailure(failure.message));
      },
      (updatedOrganisasi) {
        final index = listOrganisasi.indexWhere((o) => o.id == event.id);
        if (index != -1) {
          listOrganisasi[index] = updatedOrganisasi;
        } else {
          listOrganisasi.insert(0, updatedOrganisasi);
        }
        emit(
          OrganisasiActionSuccess(
            organisasi: updatedOrganisasi,
            message: 'Organisasi berhasil diperbarui',
          ),
        );
      },
    );
  }
}
