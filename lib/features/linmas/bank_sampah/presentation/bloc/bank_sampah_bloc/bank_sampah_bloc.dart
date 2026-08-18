import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:akar/features/linmas/bank_sampah/core/constants/bank_sampah_constants.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_location_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/delete_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_locations_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_reports_usecase.dart';

part 'bank_sampah_event.dart';
part 'bank_sampah_state.dart';

class BankSampahBloc extends Bloc<BankSampahEvent, BankSampahState> {
  final GetBankSampahReportsUsecase getReportsUsecase;
  final AddBankSampahReportUsecase addReportUsecase;
  final DeleteBankSampahReportUsecase deleteReportUsecase;
  final GetBankSampahLocationsUsecase getLocationsUsecase;
  final AddBankSampahLocationUsecase addLocationUsecase;

  BankSampahBloc({
    required this.getReportsUsecase,
    required this.addReportUsecase,
    required this.deleteReportUsecase,
    required this.getLocationsUsecase,
    required this.addLocationUsecase,
  }) : super(const BankSampahState()) {
    on<FetchBankSampahDataEvent>(_onFetchData);
    on<RefreshBankSampahDataEvent>(_onRefreshData);
    on<UpdateBankSampahUserLocationEvent>(_onUpdateUserLocation);
    on<SetBankSampahSearchQueryEvent>(_onSetSearchQuery);
    on<SetBankSampahJenisFilterEvent>(_onSetJenisFilter);
    on<SetBankSampahLocationFilterEvent>(_onSetLocationFilter);
    on<SetBankSampahSortOptionEvent>(_onSetSortOption);
    on<ResetBankSampahFiltersEvent>(_onResetFilters);
    on<AddBankSampahReportEvent>(_onAddReport);
    on<DeleteBankSampahReportEvent>(_onDeleteReport);
    on<AddBankSampahLocationEvent>(_onAddLocation);

    add(FetchBankSampahDataEvent());
  }

  Future<void> _onFetchData(
    FetchBankSampahDataEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final repResult = await getReportsUsecase();
    final locResult = await getLocationsUsecase();

    List<BankSampahReportEntity> reports = state.reports;
    List<BankSampahLocationEntity> locations = state.locations;
    String? errorMsg;

    repResult.fold((f) => errorMsg = f.message, (data) => reports = data);

    locResult.fold(
      (f) => errorMsg ??= f.message,
      (data) => locations = List<BankSampahLocationEntity>.from(data),
    );

    locations = _calculateOrApplyDistances(
      locations,
      state.userLatitude,
      state.userLongitude,
    );

    emit(
      state.copyWith(
        isLoading: false,
        reports: reports,
        locations: locations,
        errorMessage: errorMsg,
      ),
    );

    add(const UpdateBankSampahUserLocationEvent(silent: true));
  }

  Future<void> _onRefreshData(
    RefreshBankSampahDataEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    final repResult = await getReportsUsecase();
    final locResult = await getLocationsUsecase();

    List<BankSampahReportEntity> reports = state.reports;
    List<BankSampahLocationEntity> locations = state.locations;

    repResult.fold((_) {}, (data) => reports = data);
    locResult.fold(
      (_) {},
      (data) => locations = List<BankSampahLocationEntity>.from(data),
    );

    locations = _calculateOrApplyDistances(
      locations,
      state.userLatitude,
      state.userLongitude,
    );

    emit(state.copyWith(reports: reports, locations: locations));

    add(const UpdateBankSampahUserLocationEvent(silent: true));
  }

  Future<void> _onUpdateUserLocation(
    UpdateBankSampahUserLocationEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    if (!event.silent) {
      emit(state.copyWith(isFetchingLocation: true));
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final locs = _applyDefaultDistances(state.locations);
        emit(state.copyWith(isFetchingLocation: false, locations: locs));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          final locs = _applyDefaultDistances(state.locations);
          emit(state.copyWith(isFetchingLocation: false, locations: locs));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        final locs = _applyDefaultDistances(state.locations);
        emit(state.copyWith(isFetchingLocation: false, locations: locs));
        return;
      }

      Position? pos = await Geolocator.getLastKnownPosition();
      pos ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final userLat = pos.latitude;
      final userLng = pos.longitude;

      final updatedLocs = _calculateDistances(
        state.locations,
        userLat,
        userLng,
      );

      emit(
        state.copyWith(
          isFetchingLocation: false,
          userLatitude: userLat,
          userLongitude: userLng,
          locations: updatedLocs,
        ),
      );
    } catch (_) {
      final locs = _applyDefaultDistances(state.locations);
      emit(state.copyWith(isFetchingLocation: false, locations: locs));
    }
  }

  List<BankSampahLocationEntity> _calculateOrApplyDistances(
    List<BankSampahLocationEntity> locations,
    double? lat,
    double? lng,
  ) {
    if (lat != null && lng != null) {
      return _calculateDistances(locations, lat, lng);
    }
    return _applyDefaultDistances(locations);
  }

  List<BankSampahLocationEntity> _calculateDistances(
    List<BankSampahLocationEntity> locations,
    double userLat,
    double userLng,
  ) {
    final list = locations.map<BankSampahLocationEntity>((loc) {
      double targetLat = loc.latitude ?? (userLat + (loc.latOffset ?? 0.002));
      double targetLng = loc.longitude ?? (userLng + (loc.lngOffset ?? 0.002));

      final distance = Geolocator.distanceBetween(
        userLat,
        userLng,
        targetLat,
        targetLng,
      );

      return loc.copyWith(distanceMeters: distance);
    }).toList();

    list.sort((a, b) {
      final distA = a.distanceMeters ?? double.infinity;
      final distB = b.distanceMeters ?? double.infinity;
      return distA.compareTo(distB);
    });

    return list;
  }

  List<BankSampahLocationEntity> _applyDefaultDistances(
    List<BankSampahLocationEntity> locations,
  ) {
    const defaultMeters = [350.0, 750.0, 1200.0, 1800.0, 2600.0];
    final updatedList = <BankSampahLocationEntity>[];
    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];
      if (loc.distanceMeters == null) {
        final dist = i < defaultMeters.length
            ? defaultMeters[i]
            : (3000.0 + (i * 500));
        updatedList.add(loc.copyWith(distanceMeters: dist));
      } else {
        updatedList.add(loc);
      }
    }

    updatedList.sort((a, b) {
      final distA = a.distanceMeters ?? double.infinity;
      final distB = b.distanceMeters ?? double.infinity;
      return distA.compareTo(distB);
    });

    return updatedList;
  }

  void _onSetSearchQuery(
    SetBankSampahSearchQueryEvent event,
    Emitter<BankSampahState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query.trim()));
  }

  void _onSetJenisFilter(
    SetBankSampahJenisFilterEvent event,
    Emitter<BankSampahState> emit,
  ) {
    emit(
      state.copyWith(
        selectedJenisSampahFilter: event.jenis,
        clearJenisFilter: event.jenis == null,
      ),
    );
  }

  void _onSetLocationFilter(
    SetBankSampahLocationFilterEvent event,
    Emitter<BankSampahState> emit,
  ) {
    emit(
      state.copyWith(
        selectedBankSampahFilter: event.bankSampahNama,
        clearBankSampahFilter: event.bankSampahNama == null,
      ),
    );
  }

  void _onSetSortOption(
    SetBankSampahSortOptionEvent event,
    Emitter<BankSampahState> emit,
  ) {
    emit(state.copyWith(selectedSortOption: event.sortOption));
  }

  void _onResetFilters(
    ResetBankSampahFiltersEvent event,
    Emitter<BankSampahState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: '',
        clearJenisFilter: true,
        clearBankSampahFilter: true,
        selectedSortOption: BankSampahSortOption.terbaru,
      ),
    );
  }

  Future<void> _onAddReport(
    AddBankSampahReportEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        actionSuccessMessage: null,
      ),
    );

    final nilaiRupiah = event.beratKg * BankSampahConstants.hargaPerKg;
    final newReport = BankSampahReportEntity(
      id: '',
      bankSampahId: event.bankSampahId,
      bankSampahNama: event.bankSampahNama,
      jenisSampah: event.jenisSampah,
      beratKg: event.beratKg,
      nilaiRupiah: nilaiRupiah,
      fotoPath: event.fotoPath,
      fotoUrl: event.fotoUrl,
      catatan: event.catatan,
      petugasNama: event.petugasNama,
      createdAt: DateTime.now(),
    );

    final result = await addReportUsecase(newReport);

    result.fold(
      (failure) {
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
      },
      (added) {
        final list = List<BankSampahReportEntity>.from(state.reports)
          ..insert(0, added);
        emit(
          state.copyWith(
            isSubmitting: false,
            reports: list,
            actionSuccessMessage: 'Laporan bank sampah berhasil disimpan',
          ),
        );
      },
    );
  }

  Future<void> _onDeleteReport(
    DeleteBankSampahReportEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    final result = await deleteReportUsecase(event.id);
    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
      (success) {
        final list = List<BankSampahReportEntity>.from(state.reports)
          ..removeWhere((item) => item.id == event.id);
        emit(
          state.copyWith(
            reports: list,
            actionSuccessMessage: 'Laporan berhasil dihapus',
          ),
        );
      },
    );
  }

  Future<void> _onAddLocation(
    AddBankSampahLocationEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    final newLocation = BankSampahLocationEntity(
      id: '',
      nama: event.nama,
      alamat: event.alamat,
      kelurahan: event.kelurahan,
      pengelola: event.pengelola,
      kontak: event.kontak,
      distanceMeters: 450.0,
    );

    final result = await addLocationUsecase(newLocation);
    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
      (added) {
        final list = List<BankSampahLocationEntity>.from(state.locations)
          ..insert(0, added);
        emit(
          state.copyWith(
            locations: list,
            actionSuccessMessage: 'Lokasi bank sampah berhasil ditambahkan',
          ),
        );
      },
    );
  }
}
