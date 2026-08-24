import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:akar/features/linmas/demografi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_institusi_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_organisasi_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_tokoh_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_institusi_list_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_organisasi_list_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_tokoh_list_usecase.dart';

part 'demografi_event.dart';
part 'demografi_state.dart';

class DemografiBloc extends Bloc<DemografiEvent, DemografiState> {
  final GetTokohListUsecase getTokohListUsecase;
  final AddTokohUsecase addTokohUsecase;
  final GetInstitusiListUsecase getInstitusiListUsecase;
  final AddInstitusiUsecase addInstitusiUsecase;
  final GetOrganisasiListUsecase getOrganisasiListUsecase;
  final AddOrganisasiUsecase addOrganisasiListUsecase;

  DemografiBloc({
    required this.getTokohListUsecase,
    required this.addTokohUsecase,
    required this.getInstitusiListUsecase,
    required this.addInstitusiUsecase,
    required this.getOrganisasiListUsecase,
    required this.addOrganisasiListUsecase,
  }) : super(const DemografiState()) {
    on<FetchDemografiDataEvent>(_onFetchData);
    on<SetDemografiActiveTabEvent>(_onSetActiveTab);
    on<SetDemografiSearchQueryEvent>(_onSetSearchQuery);
    on<ClearDemografiSearchEvent>(_onClearSearch);
    on<SetDemografiProfesiFilterEvent>(_onSetProfesiFilter);
    on<SetDemografiScopeFilterEvent>(_onSetScopeFilter);
    on<SetDemografiAfiliasiFilterEvent>(_onSetAfiliasiFilter);
    on<SetDemografiInstitusiKategoriFilterEvent>(_onSetInstitusiKategoriFilter);
    on<SetDemografiInstitusiScopeFilterEvent>(_onSetInstitusiScopeFilter);
    on<SetDemografiOrganisasiBidangFilterEvent>(_onSetOrganisasiBidangFilter);
    on<SetDemografiSortOptionEvent>(_onSetSortOption);
    on<ResetDemografiFiltersEvent>(_onResetFilters);
    on<AddTokohEvent>(_onAddTokoh);
    on<AddInstitusiEvent>(_onAddInstitusi);
    on<AddOrganisasiEvent>(_onAddOrganisasi);

    add(FetchDemografiDataEvent());
  }

  Future<void> _onFetchData(
    FetchDemografiDataEvent event,
    Emitter<DemografiState> emit,
  ) async {
    emit(state.copyWith(status: DemografiStatus.loading, errorMessage: null));

    final resTokoh = await getTokohListUsecase.call();
    final resInstitusi = await getInstitusiListUsecase.call();
    final resOrganisasi = await getOrganisasiListUsecase.call();

    List<TokohEntity> tokoh = state.tokohList;
    List<InstitusiEntity> institusi = state.institusiList;
    List<OrganisasiEntity> organisasi = state.organisasiList;
    String? errorMsg;

    resTokoh.fold((f) => errorMsg = f.message, (data) => tokoh = data);

    resInstitusi.fold(
      (f) => errorMsg ??= f.message,
      (data) => institusi = data,
    );

    resOrganisasi.fold(
      (f) => errorMsg ??= f.message,
      (data) => organisasi = data,
    );

    if (errorMsg != null &&
        tokoh.isEmpty &&
        institusi.isEmpty &&
        organisasi.isEmpty) {
      emit(
        state.copyWith(status: DemografiStatus.failure, errorMessage: errorMsg),
      );
    } else {
      emit(
        state.copyWith(
          status: DemografiStatus.success,
          tokohList: tokoh,
          institusiList: institusi,
          organisasiList: organisasi,
        ),
      );
    }
  }

  void _onSetActiveTab(
    SetDemografiActiveTabEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(state.copyWith(activeTabIndex: event.index));
  }

  void _onSetSearchQuery(
    SetDemografiSearchQueryEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onClearSearch(
    ClearDemografiSearchEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(state.copyWith(searchQuery: ''));
  }

  void _onSetProfesiFilter(
    SetDemografiProfesiFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProfesiFilter: event.profesi,
        clearProfesi: event.profesi == null,
      ),
    );
  }

  void _onSetScopeFilter(
    SetDemografiScopeFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(
      state.copyWith(
        selectedScopeFilter: event.scope,
        clearScope: event.scope == null,
      ),
    );
  }

  void _onSetAfiliasiFilter(
    SetDemografiAfiliasiFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAfiliasiFilter: event.afiliasi,
        clearAfiliasi: event.afiliasi == null,
      ),
    );
  }

  void _onSetInstitusiKategoriFilter(
    SetDemografiInstitusiKategoriFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(
      state.copyWith(
        selectedInstitusiKategoriFilter: event.kategori,
        clearInstitusiKategori: event.kategori == null,
      ),
    );
  }

  void _onSetInstitusiScopeFilter(
    SetDemografiInstitusiScopeFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(
      state.copyWith(
        selectedInstitusiScopeFilter: event.scope,
        clearInstitusiScope: event.scope == null,
      ),
    );
  }

  void _onSetOrganisasiBidangFilter(
    SetDemografiOrganisasiBidangFilterEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(
      state.copyWith(
        selectedOrganisasiBidangFilter: event.bidang,
        clearOrganisasiBidang: event.bidang == null,
      ),
    );
  }

  void _onSetSortOption(
    SetDemografiSortOptionEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(state.copyWith(selectedSortOption: event.option));
  }

  void _onResetFilters(
    ResetDemografiFiltersEvent event,
    Emitter<DemografiState> emit,
  ) {
    emit(
      state.copyWith(
        clearProfesi: true,
        clearScope: true,
        clearAfiliasi: true,
        clearInstitusiKategori: true,
        clearInstitusiScope: true,
        clearOrganisasiBidang: true,
        selectedSortOption: DemografiSortOption.terbaru,
      ),
    );
  }

  Future<void> _onAddTokoh(
    AddTokohEvent event,
    Emitter<DemografiState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        actionSuccessMessage: null,
      ),
    );

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
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
      },
      (newTokoh) {
        final list = List<TokohEntity>.from(state.tokohList)
          ..insert(0, newTokoh);
        emit(
          state.copyWith(
            isSubmitting: false,
            tokohList: list,
            actionSuccessMessage: 'Tokoh masyarakat berhasil ditambahkan',
          ),
        );
      },
    );
  }

  Future<void> _onAddInstitusi(
    AddInstitusiEvent event,
    Emitter<DemografiState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        actionSuccessMessage: null,
      ),
    );

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
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
      },
      (newInstitusi) {
        final list = List<InstitusiEntity>.from(state.institusiList)
          ..insert(0, newInstitusi);
        emit(
          state.copyWith(
            isSubmitting: false,
            institusiList: list,
            actionSuccessMessage: 'Institusi berhasil ditambahkan',
          ),
        );
      },
    );
  }

  Future<void> _onAddOrganisasi(
    AddOrganisasiEvent event,
    Emitter<DemografiState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        actionSuccessMessage: null,
      ),
    );

    final entity = OrganisasiEntity(
      nama: event.nama,
      jumlahAnggota: event.jumlahAnggota,
      bidang: event.bidang,
      alamatSekretariat: event.alamatSekretariat,
      createdAt: DateTime.now(),
    );

    final result = await addOrganisasiListUsecase.call(entity);

    result.fold(
      (failure) {
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
      },
      (newOrganisasi) {
        final list = List<OrganisasiEntity>.from(state.organisasiList)
          ..insert(0, newOrganisasi);
        emit(
          state.copyWith(
            isSubmitting: false,
            organisasiList: list,
            actionSuccessMessage: 'Organisasi berhasil ditambahkan',
          ),
        );
      },
    );
  }
}
