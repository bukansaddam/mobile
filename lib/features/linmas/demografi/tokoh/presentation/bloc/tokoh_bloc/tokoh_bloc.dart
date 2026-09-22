import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/usecases/add_tokoh_usecase.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/usecases/get_tokoh_list_usecase.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/usecases/update_tokoh_usecase.dart';

part 'tokoh_event.dart';
part 'tokoh_state.dart';

class TokohBloc extends Bloc<TokohEvent, TokohState> {
  final GetTokohListUsecase getTokohListUsecase;
  final AddTokohUsecase addTokohUsecase;
  final UpdateTokohUsecase updateTokohUsecase;

  List<TokohEntity> listTokoh = [];
  int? page = 1;
  int limit = 10;
  int total = 0;

  String searchQuery = '';
  String? selectedProfesiFilter; // GET param 'field'
  String? selectedAfiliasiFilter; // GET param 'label'
  TokohSortOption selectedSortOption = TokohSortOption.terbaru;

  bool get hasActiveFilter =>
      selectedProfesiFilter != null ||
      selectedAfiliasiFilter != null ||
      selectedSortOption != TokohSortOption.terbaru;

  List<TokohEntity> get displayList {
    List<TokohEntity> list = List.from(listTokoh);
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((t) => t.nama.toLowerCase().contains(q)).toList();
    }
    if (selectedProfesiFilter != null &&
        selectedProfesiFilter!.trim().isNotEmpty) {
      list = list
          .where(
            (t) =>
                t.profesi.toLowerCase() == selectedProfesiFilter!.toLowerCase(),
          )
          .toList();
    }
    if (selectedAfiliasiFilter != null &&
        selectedAfiliasiFilter!.trim().isNotEmpty) {
      list = list
          .where(
            (t) =>
                t.afiliasi.toLowerCase() ==
                selectedAfiliasiFilter!.toLowerCase(),
          )
          .toList();
    }
    switch (selectedSortOption) {
      case TokohSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case TokohSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case TokohSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }
    return list;
  }

  TokohBloc({
    required this.getTokohListUsecase,
    required this.addTokohUsecase,
    required this.updateTokohUsecase,
  }) : super(TokohInitial()) {
    on<GetTokohEvent>(_onGetTokoh);
    on<RefreshTokohEvent>(_onRefreshTokoh);
    on<SetTokohFilterEvent>(_onSetFilter);
    on<ResetTokohFilterEvent>(_onResetFilter);
    on<CreateTokohEvent>(_onCreateTokoh);
    on<UpdateTokohEvent>(_onUpdateTokoh);

    add(const RefreshTokohEvent());
  }

  Future<void> _onGetTokoh(
    GetTokohEvent event,
    Emitter<TokohState> emit,
  ) async {
    if (page == null) return;

    if (page == 1) {
      emit(TokohLoading());
    }

    final querySearch = (event.search != null)
        ? (event.search!.trim().isNotEmpty ? event.search!.trim() : null)
        : (searchQuery.trim().isNotEmpty ? searchQuery.trim() : null);
    final filterField = (event.field != null)
        ? (event.field!.trim().isNotEmpty ? event.field!.trim() : null)
        : (selectedProfesiFilter?.trim().isNotEmpty == true
              ? selectedProfesiFilter!.trim()
              : null);
    final filterLabel = (event.label != null)
        ? (event.label!.trim().isNotEmpty ? event.label!.trim() : null)
        : (selectedAfiliasiFilter?.trim().isNotEmpty == true
              ? selectedAfiliasiFilter!.trim()
              : null);

    final result = await getTokohListUsecase.call(
      page: page!,
      perPage: limit,
      field: filterField,
      label: filterLabel,
      name: querySearch,
    );

    result.fold(
      (failure) {
        emit(TokohFailure(failure.message));
      },
      (paginated) {
        listTokoh.addAll(paginated.data);
        total = paginated.total;
        emit(TokohLoaded(paginated));

        if (paginated.data.length < limit ||
            paginated.currentPage >= paginated.lastPage) {
          page = null;
        } else {
          page = paginated.currentPage + 1;
        }
      },
    );
  }

  Future<void> _onRefreshTokoh(
    RefreshTokohEvent event,
    Emitter<TokohState> emit,
  ) async {
    page = 1;
    listTokoh.clear();
    if (event.search != null) searchQuery = event.search!;
    if (event.field != null) selectedProfesiFilter = event.field;
    if (event.label != null) selectedAfiliasiFilter = event.label;
    if (event.sort != null) selectedSortOption = event.sort!;

    add(
      GetTokohEvent(
        search: searchQuery,
        field: selectedProfesiFilter,
        label: selectedAfiliasiFilter,
        sort: selectedSortOption,
      ),
    );
  }

  void _onSetFilter(SetTokohFilterEvent event, Emitter<TokohState> emit) {
    if (event.hasField) {
      selectedProfesiFilter = event.field;
    }
    if (event.hasLabel) {
      selectedAfiliasiFilter = event.label;
    }
    if (event.sort != null) {
      selectedSortOption = event.sort!;
    }
    if (event.search != null) {
      searchQuery = event.search!;
    }
    add(
      RefreshTokohEvent(
        search: searchQuery,
        field: selectedProfesiFilter,
        label: selectedAfiliasiFilter,
        sort: selectedSortOption,
      ),
    );
  }

  void _onResetFilter(ResetTokohFilterEvent event, Emitter<TokohState> emit) {
    selectedProfesiFilter = null;
    selectedAfiliasiFilter = null;
    selectedSortOption = TokohSortOption.terbaru;
    add(
      RefreshTokohEvent(
        search: searchQuery,
        field: null,
        label: null,
        sort: TokohSortOption.terbaru,
      ),
    );
  }

  Future<void> _onCreateTokoh(
    CreateTokohEvent event,
    Emitter<TokohState> emit,
  ) async {
    emit(TokohActionLoading());
    final result = await addTokohUsecase.call(event.tokoh);

    result.fold(
      (failure) {
        emit(TokohActionFailure(failure.message));
      },
      (createdTokoh) {
        emit(
          TokohActionSuccess(
            tokoh: createdTokoh,
            message: 'Tokoh masyarakat berhasil ditambahkan',
          ),
        );
        add(const RefreshTokohEvent());
      },
    );
  }

  Future<void> _onUpdateTokoh(
    UpdateTokohEvent event,
    Emitter<TokohState> emit,
  ) async {
    emit(TokohActionLoading());
    final result = await updateTokohUsecase.call(event.id, event.tokoh);

    result.fold(
      (failure) {
        emit(TokohActionFailure(failure.message));
      },
      (updatedTokoh) {
        emit(
          TokohActionSuccess(
            tokoh: updatedTokoh,
            message: 'Data tokoh berhasil diperbarui',
          ),
        );
        add(const RefreshTokohEvent());
      },
    );
  }
}
