import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  List<BankSampahReportEntity> listReports = [];
  List<BankSampahLocationEntity> listLocations = [];
  BankSampahSummaryEntity? summary;

  int? page = 1;
  int limit = 10;
  int total = 0;

  double? userLatitude;
  double? userLongitude;
  bool isFetchingLocation = false;

  String? selectedJenisSampahFilter;
  String? selectedBankSampahFilter;
  int? selectedBankId;
  BankSampahSortBy sortBy = BankSampahSortBy.date;
  BankSampahSortDirection sortDirection = BankSampahSortDirection.desc;

  BankSampahSortOption get selectedSortOption {
    if (sortBy == BankSampahSortBy.date &&
        sortDirection == BankSampahSortDirection.desc) {
      return BankSampahSortOption.terbaru;
    }
    if (sortBy == BankSampahSortBy.date &&
        sortDirection == BankSampahSortDirection.asc) {
      return BankSampahSortOption.terlama;
    }
    if (sortBy == BankSampahSortBy.weight &&
        sortDirection == BankSampahSortDirection.desc) {
      return BankSampahSortOption.bobotTerbanyak;
    }
    if (sortBy == BankSampahSortBy.weight &&
        sortDirection == BankSampahSortDirection.asc) {
      return BankSampahSortOption.bobotTersedikit;
    }
    if (sortBy == BankSampahSortBy.price &&
        sortDirection == BankSampahSortDirection.desc) {
      return BankSampahSortOption.nilaiTertinggi;
    }
    return BankSampahSortOption.terbaru;
  }

  bool get hasActiveFilter =>
      selectedJenisSampahFilter != null ||
      selectedBankSampahFilter != null ||
      selectedBankId != null ||
      sortBy != BankSampahSortBy.date ||
      sortDirection != BankSampahSortDirection.desc;

  BankSampahLocationEntity? get nearestLocation {
    if (listLocations.isEmpty) return null;
    return listLocations.first;
  }

  int get totalLaporanCount => summary?.totalSetoran ?? total;

  double get totalBeratKg =>
      summary?.totalKg ??
      listReports.fold(0.0, (sum, item) => sum + item.beratKg);

  double get totalNilaiRupiah =>
      summary?.totalPendapatan ??
      listReports.fold(0.0, (sum, item) => sum + item.nilaiRupiah);

  List<BankSampahReportEntity> get displayList {
    List<BankSampahReportEntity> list = List.from(listReports);
    if (selectedJenisSampahFilter != null &&
        selectedJenisSampahFilter!.trim().isNotEmpty) {
      final j = selectedJenisSampahFilter!.toLowerCase();
      list = list
          .where((report) => report.jenisSampah.toLowerCase() == j)
          .toList();
    }
    if (selectedBankId != null) {
      list = list
          .where((report) => report.bankSampahId == selectedBankId.toString())
          .toList();
    } else if (selectedBankSampahFilter != null &&
        selectedBankSampahFilter!.trim().isNotEmpty) {
      final b = selectedBankSampahFilter!.toLowerCase();
      list = list
          .where((report) => report.bankSampahNama.toLowerCase() == b)
          .toList();
    }
    switch (sortBy) {
      case BankSampahSortBy.date:
        list.sort(
          (a, b) => sortDirection == BankSampahSortDirection.desc
              ? b.createdAt.compareTo(a.createdAt)
              : a.createdAt.compareTo(b.createdAt),
        );
        break;
      case BankSampahSortBy.weight:
        list.sort(
          (a, b) => sortDirection == BankSampahSortDirection.desc
              ? b.beratKg.compareTo(a.beratKg)
              : a.beratKg.compareTo(b.beratKg),
        );
        break;
      case BankSampahSortBy.price:
        list.sort(
          (a, b) => sortDirection == BankSampahSortDirection.desc
              ? b.nilaiRupiah.compareTo(a.nilaiRupiah)
              : a.nilaiRupiah.compareTo(b.nilaiRupiah),
        );
        break;
      case BankSampahSortBy.time:
        list.sort((a, b) {
          final timeA = a.createdAt.hour * 60 + a.createdAt.minute;
          final timeB = b.createdAt.hour * 60 + b.createdAt.minute;
          return sortDirection == BankSampahSortDirection.desc
              ? timeB.compareTo(timeA)
              : timeA.compareTo(timeB);
        });
        break;
    }
    return list;
  }

  BankSampahBloc({
    required this.getReportsUsecase,
    required this.addReportUsecase,
    required this.deleteReportUsecase,
    required this.getLocationsUsecase,
    required this.addLocationUsecase,
  }) : super(BankSampahInitial()) {
    on<GetBankSampahReportsEvent>(_onGetReports);
    on<RefreshBankSampahReportsEvent>(_onRefreshReports);
    on<SetBankSampahFilterEvent>(_onSetFilter);
    on<ResetBankSampahFilterEvent>(_onResetFilter);
    on<CreateBankSampahReportEvent>(_onCreateReport);
    on<DeleteBankSampahReportEvent>(_onDeleteReport);
    on<AddBankSampahLocationEvent>(_onAddLocation);
    on<UpdateBankSampahUserLocationEvent>(_onUpdateUserLocation);
    on<GetBankSampahLocationsEvent>(_onGetLocations);

    add(const RefreshBankSampahReportsEvent());
    add(const GetBankSampahLocationsEvent());
  }

  Future<void> _onGetReports(
    GetBankSampahReportsEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    if (page == null) return;

    if (page == 1) {
      emit(BankSampahLoading());
    }

    final filterJenis =
        (event.jenisSampah != null && event.jenisSampah!.trim().isNotEmpty)
        ? event.jenisSampah!.trim()
        : (selectedJenisSampahFilter?.trim().isNotEmpty == true
              ? selectedJenisSampahFilter!.trim()
              : null);

    final filterBankId = event.bankId ?? selectedBankId;

    final sortB = event.sortBy ?? (event.sortOption?.sortBy ?? sortBy);
    final sortD =
        event.sortDirection ??
        (event.sortOption?.sortDirection ?? sortDirection);

    final result = await getReportsUsecase.call(
      page: page!,
      perPage: limit,
      sortBy: sortB.apiValue,
      sortDirection: sortD.apiValue,
      bankId: filterBankId,
      wasteType: filterJenis,
    );

    result.fold(
      (failure) {
        emit(BankSampahFailure(failure.message));
      },
      (paginated) {
        listReports.addAll(paginated.data);
        summary = paginated.summary ?? summary;
        total = paginated.total;

        emit(BankSampahLoaded(paginated));

        if (paginated.data.length < limit ||
            paginated.currentPage >= paginated.lastPage) {
          page = null;
        } else {
          page = paginated.currentPage + 1;
        }
      },
    );
  }

  Future<void> _onRefreshReports(
    RefreshBankSampahReportsEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    page = 1;
    listReports.clear();

    if (event.jenisSampah != null) {
      selectedJenisSampahFilter = event.jenisSampah;
    }
    if (event.bankId != null) selectedBankId = event.bankId;
    if (event.bankSampahNama != null) {
      selectedBankSampahFilter = event.bankSampahNama;
    }
    if (event.sortBy != null) sortBy = event.sortBy!;
    if (event.sortDirection != null) sortDirection = event.sortDirection!;
    if (event.sortOption != null) {
      sortBy = event.sortOption!.sortBy;
      sortDirection = event.sortOption!.sortDirection;
    }

    add(
      GetBankSampahReportsEvent(
        jenisSampah: selectedJenisSampahFilter,
        bankId: selectedBankId,
        bankSampahNama: selectedBankSampahFilter,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
  }

  void _onSetFilter(
    SetBankSampahFilterEvent event,
    Emitter<BankSampahState> emit,
  ) {
    if (event.hasJenisSampah) {
      selectedJenisSampahFilter = event.jenisSampah;
    }
    if (event.hasBankSampah) {
      selectedBankId = event.bankId;
      selectedBankSampahFilter = event.bankSampahNama;
      if (selectedBankId == null && selectedBankSampahFilter != null) {
        final found = listLocations
            .cast<BankSampahLocationEntity?>()
            .firstWhere(
              (loc) =>
                  loc?.nama.toLowerCase() ==
                  selectedBankSampahFilter!.toLowerCase(),
              orElse: () => null,
            );
        if (found != null) {
          selectedBankId = int.tryParse(found.id);
        }
      }
    }
    if (event.sortBy != null) {
      sortBy = event.sortBy!;
    }
    if (event.sortDirection != null) {
      sortDirection = event.sortDirection!;
    }
    if (event.sortOption != null) {
      sortBy = event.sortOption!.sortBy;
      sortDirection = event.sortOption!.sortDirection;
    }

    add(
      RefreshBankSampahReportsEvent(
        jenisSampah: selectedJenisSampahFilter,
        bankId: selectedBankId,
        bankSampahNama: selectedBankSampahFilter,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
  }

  void _onResetFilter(
    ResetBankSampahFilterEvent event,
    Emitter<BankSampahState> emit,
  ) {
    selectedJenisSampahFilter = null;
    selectedBankSampahFilter = null;
    selectedBankId = null;
    sortBy = BankSampahSortBy.date;
    sortDirection = BankSampahSortDirection.desc;

    add(const RefreshBankSampahReportsEvent());
  }

  Future<void> _onCreateReport(
    CreateBankSampahReportEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    emit(BankSampahActionLoading());
    final result = await addReportUsecase.call(event.report);

    result.fold(
      (failure) {
        emit(BankSampahActionFailure(failure.message));
      },
      (created) {
        emit(
          BankSampahActionSuccess(
            report: created,
            message: 'Laporan bank sampah berhasil disimpan',
          ),
        );
        add(const RefreshBankSampahReportsEvent());
      },
    );
  }

  Future<void> _onDeleteReport(
    DeleteBankSampahReportEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    emit(BankSampahActionLoading());
    final result = await deleteReportUsecase.call(event.id);

    result.fold(
      (failure) {
        emit(BankSampahActionFailure(failure.message));
      },
      (success) {
        listReports.removeWhere((item) => item.id == event.id);
        emit(
          const BankSampahActionSuccess(message: 'Laporan berhasil dihapus'),
        );
        add(const RefreshBankSampahReportsEvent());
      },
    );
  }

  Future<void> _onGetLocations(
    GetBankSampahLocationsEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    final result = await getLocationsUsecase.call();
    result.fold((_) {}, (locations) {
      listLocations = List<BankSampahLocationEntity>.from(locations);
      listLocations = _calculateOrApplyDistances(
        listLocations,
        userLatitude,
        userLongitude,
      );
    });
    add(const UpdateBankSampahUserLocationEvent(silent: true));
  }

  Future<void> _onAddLocation(
    AddBankSampahLocationEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    emit(BankSampahActionLoading());
    final result = await addLocationUsecase.call(event.location);
    result.fold(
      (failure) {
        emit(BankSampahActionFailure(failure.message));
      },
      (added) {
        listLocations.insert(0, added);
        emit(
          BankSampahActionSuccess(
            location: added,
            message: 'Lokasi bank sampah berhasil ditambahkan',
          ),
        );
      },
    );
  }

  Future<void> _onUpdateUserLocation(
    UpdateBankSampahUserLocationEvent event,
    Emitter<BankSampahState> emit,
  ) async {
    if (!event.silent) {
      isFetchingLocation = true;
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isFetchingLocation = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isFetchingLocation = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isFetchingLocation = false;
        return;
      }

      Position? pos = await Geolocator.getLastKnownPosition();
      pos ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      userLatitude = pos.latitude;
      userLongitude = pos.longitude;
      isFetchingLocation = false;

      listLocations = _calculateDistances(
        listLocations,
        userLatitude!,
        userLongitude!,
      );
    } catch (_) {
      isFetchingLocation = false;
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
    return locations;
  }

  List<BankSampahLocationEntity> _calculateDistances(
    List<BankSampahLocationEntity> locations,
    double userLat,
    double userLng,
  ) {
    final list = locations.map<BankSampahLocationEntity>((loc) {
      if (loc.latitude != null && loc.longitude != null) {
        final distance = Geolocator.distanceBetween(
          userLat,
          userLng,
          loc.latitude!,
          loc.longitude!,
        );
        return loc.copyWith(distanceMeters: distance);
      }
      return loc;
    }).toList();

    list.sort((a, b) {
      final distA = a.distanceMeters ?? double.infinity;
      final distB = b.distanceMeters ?? double.infinity;
      return distA.compareTo(distB);
    });

    return list;
  }
}
