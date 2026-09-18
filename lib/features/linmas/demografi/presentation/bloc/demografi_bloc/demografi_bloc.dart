import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:akar/features/linmas/demografi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_institusi_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_tokoh_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_institusi_list_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_tokoh_list_usecase.dart';

part 'demografi_event.dart';
part 'demografi_state.dart';

class DemografiBloc extends Bloc<DemografiEvent, DemografiState> {
  final GetTokohListUsecase getTokohListUsecase;
  final AddTokohUsecase addTokohUsecase;
  final GetInstitusiListUsecase getInstitusiListUsecase;
  final AddInstitusiUsecase addInstitusiUsecase;

  DemografiBloc({
    required this.getTokohListUsecase,
    required this.addTokohUsecase,
    required this.getInstitusiListUsecase,
    required this.addInstitusiUsecase,
  }) : super(const DemografiInitialState()) {
    on<FetchDemografiDataEvent>(_onFetchData);
    on<SetDemografiActiveTabEvent>(_onSetActiveTab);
    on<SetDemografiSearchQueryEvent>(_onSetSearchQuery);
    on<ClearDemografiSearchEvent>(_onClearSearch);
    on<SetDemografiProfesiFilterEvent>(_onSetProfesiFilter);
    on<SetDemografiScopeFilterEvent>(_onSetScopeFilter);
    on<SetDemografiAfiliasiFilterEvent>(_onSetAfiliasiFilter);
    on<SetDemografiInstitusiKategoriFilterEvent>(_onSetInstitusiKategoriFilter);
    on<SetDemografiInstitusiScopeFilterEvent>(_onSetInstitusiScopeFilter);
    on<SetDemografiSortOptionEvent>(_onSetSortOption);
    on<ResetDemografiFiltersEvent>(_onResetFilters);
    on<AddTokohEvent>(_onAddTokoh);
    on<AddInstitusiEvent>(_onAddInstitusi);

    add(const FetchDemografiDataEvent());
  }

  Future<void> _onFetchData(
    FetchDemografiDataEvent event,
    Emitter<DemografiState> emit,
  ) async {
    final currentState = state;

    if (currentState is! DemografiLoadedState) {
      emit(const DemografiLoadingState());
    }

    final resTokoh = await getTokohListUsecase.call();
    final resInstitusi = await getInstitusiListUsecase.call();

    List<TokohEntity> tokoh = currentState.tokohList;
    List<InstitusiEntity> institusi = currentState.institusiList;
    String? errorMsg;

    resTokoh.fold((f) => errorMsg = f.message, (data) => tokoh = data);

    resInstitusi.fold(
      (f) => errorMsg ??= f.message,
      (data) => institusi = data,
    );

    if (errorMsg != null && tokoh.isEmpty && institusi.isEmpty) {
      emit(DemografiFailureState(errorMsg!));
    } else {
      if (currentState is DemografiLoadedState) {
        emit(currentState.copyWith(tokohList: tokoh, institusiList: institusi));
      } else {
        emit(DemografiLoadedState(tokohList: tokoh, institusiList: institusi));
      }
    }
  }

  void _onSetActiveTab(
    SetDemografiActiveTabEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          activeTabIndex: event.index,
          searchQuery: '',
        ),
      );
    } else {
      emit(DemografiLoadedState(activeTabIndex: event.index, searchQuery: ''));
    }
  }

  void _onSetSearchQuery(
    SetDemografiSearchQueryEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit((state as DemografiLoadedState).copyWith(searchQuery: event.query));
    } else {
      emit(DemografiLoadedState(searchQuery: event.query));
    }
  }

  void _onClearSearch(
    ClearDemografiSearchEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit((state as DemografiLoadedState).copyWith(searchQuery: ''));
    }
  }

  void _onSetProfesiFilter(
    SetDemografiProfesiFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          selectedProfesiFilter: event.profesi,
          clearProfesi: event.profesi == null,
        ),
      );
    }
  }

  void _onSetScopeFilter(
    SetDemografiScopeFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          selectedScopeFilter: event.scope,
          clearScope: event.scope == null,
        ),
      );
    }
  }

  void _onSetAfiliasiFilter(
    SetDemografiAfiliasiFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          selectedAfiliasiFilter: event.afiliasi,
          clearAfiliasi: event.afiliasi == null,
        ),
      );
    }
  }

  void _onSetInstitusiKategoriFilter(
    SetDemografiInstitusiKategoriFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          selectedInstitusiKategoriFilter: event.kategori,
          clearInstitusiKategori: event.kategori == null,
        ),
      );
    }
  }

  void _onSetInstitusiScopeFilter(
    SetDemografiInstitusiScopeFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          selectedInstitusiScopeFilter: event.scope,
          clearInstitusiScope: event.scope == null,
        ),
      );
    }
  }

  void _onSetSortOption(
    SetDemografiSortOptionEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          selectedSortOption: event.option,
        ),
      );
    }
  }

  void _onResetFilters(
    ResetDemografiFiltersEvent event,
    Emitter<DemografiState> emit,
  ) {
    if (state is DemografiLoadedState) {
      emit(
        (state as DemografiLoadedState).copyWith(
          clearProfesi: true,
          clearScope: true,
          clearAfiliasi: true,
          clearInstitusiKategori: true,
          clearInstitusiScope: true,
          selectedSortOption: DemografiSortOption.terbaru,
        ),
      );
    }
  }

  Future<void> _onAddTokoh(
    AddTokohEvent event,
    Emitter<DemografiState> emit,
  ) async {
    final currentState = state;
    if (currentState is DemografiLoadedState) {
      emit(
        currentState.copyWith(
          isSubmitting: true,
          errorMessage: null,
          actionSuccessMessage: null,
        ),
      );
    }

    final entity = TokohEntity(
      nama: event.nama,
      noTelp: event.noTelp,
      jenisKelamin: event.jenisKelamin,
      profesi: event.profesi,
      wilayah: event.wilayah,
      namaInstitusi: event.namaInstitusi,
      jabatanInstitusi: event.jabatanInstitusi,
      afiliasi: event.afiliasi,
      namaOrganisasi: event.namaOrganisasi,
      jabatanOrganisasi: event.jabatanOrganisasi,
      suku: event.suku,
      createdAt: DateTime.now(),
    );

    final result = await addTokohUsecase.call(entity);

    result.fold(
      (failure) {
        if (state is DemografiLoadedState) {
          emit(
            (state as DemografiLoadedState).copyWith(
              isSubmitting: false,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(DemografiFailureState(failure.message));
        }
      },
      (newTokoh) {
        if (state is DemografiLoadedState) {
          final loaded = state as DemografiLoadedState;
          final list = List<TokohEntity>.from(loaded.tokohList)
            ..insert(0, newTokoh);
          emit(
            loaded.copyWith(
              isSubmitting: false,
              tokohList: list,
              actionSuccessMessage: 'Tokoh masyarakat berhasil ditambahkan',
            ),
          );
        }
      },
    );
  }

  Future<void> _onAddInstitusi(
    AddInstitusiEvent event,
    Emitter<DemografiState> emit,
  ) async {
    final currentState = state;
    if (currentState is DemografiLoadedState) {
      emit(
        currentState.copyWith(
          isSubmitting: true,
          errorMessage: null,
          actionSuccessMessage: null,
        ),
      );
    }

    final entity = InstitusiEntity(
      nama: event.nama,
      kategori: event.kategori,
      scope: event.scope,
      alamat: event.alamat,
      createdAt: DateTime.now(),
    );

    final result = await addInstitusiUsecase.call(entity);

    result.fold(
      (failure) {
        if (state is DemografiLoadedState) {
          emit(
            (state as DemografiLoadedState).copyWith(
              isSubmitting: false,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(DemografiFailureState(failure.message));
        }
      },
      (newInstitusi) {
        if (state is DemografiLoadedState) {
          final loaded = state as DemografiLoadedState;
          final list = List<InstitusiEntity>.from(loaded.institusiList)
            ..insert(0, newInstitusi);
          emit(
            loaded.copyWith(
              isSubmitting: false,
              institusiList: list,
              actionSuccessMessage: 'Institusi berhasil ditambahkan',
            ),
          );
        }
      },
    );
  }
}
