part of 'bank_sampah_bloc.dart';

enum BankSampahSortBy {
  date('date', 'Tanggal', Icons.calendar_today_rounded),
  weight('weight', 'Bobot', Icons.scale_rounded),
  price('price', 'Nilai', Icons.payments_rounded),
  time('time', 'Waktu', Icons.schedule_rounded);

  final String apiValue;
  final String label;
  final IconData icon;
  const BankSampahSortBy(this.apiValue, this.label, this.icon);

  static BankSampahSortBy fromApiValue(String? val) {
    return BankSampahSortBy.values.firstWhere(
      (e) => e.apiValue == val,
      orElse: () => BankSampahSortBy.date,
    );
  }
}

enum BankSampahSortDirection {
  desc('desc', 'Menurun', Icons.south_rounded),
  asc('asc', 'Menaik', Icons.north_rounded);

  final String apiValue;
  final String label;
  final IconData icon;
  const BankSampahSortDirection(this.apiValue, this.label, this.icon);

  static BankSampahSortDirection fromApiValue(String? val) {
    return BankSampahSortDirection.values.firstWhere(
      (e) => e.apiValue == val,
      orElse: () => BankSampahSortDirection.desc,
    );
  }
}

enum BankSampahSortOption {
  terbaru('Terbaru', Icons.schedule_rounded, BankSampahSortBy.date, BankSampahSortDirection.desc),
  terlama('Terlama', Icons.history_rounded, BankSampahSortBy.date, BankSampahSortDirection.asc),
  bobotTerbanyak('Bobot Terbanyak', Icons.arrow_upward_rounded, BankSampahSortBy.weight, BankSampahSortDirection.desc),
  bobotTersedikit('Bobot Tersedikit', Icons.arrow_downward_rounded, BankSampahSortBy.weight, BankSampahSortDirection.asc),
  nilaiTertinggi('Nilai Tertinggi', Icons.payments_rounded, BankSampahSortBy.price, BankSampahSortDirection.desc);

  final String label;
  final IconData icon;
  final BankSampahSortBy sortBy;
  final BankSampahSortDirection sortDirection;
  const BankSampahSortOption(this.label, this.icon, this.sortBy, this.sortDirection);
}

class BankSampahState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final bool isFetchingLocation;
  final String? errorMessage;
  final String? actionSuccessMessage;

  final List<BankSampahReportEntity> reports;
  final List<BankSampahLocationEntity> locations;
  final BankSampahSummaryEntity? summary;

  final double? userLatitude;
  final double? userLongitude;

  final String searchQuery;
  final String? selectedJenisSampahFilter;
  final String? selectedBankSampahFilter;
  final int? selectedBankId;
  final BankSampahSortBy sortBy;
  final BankSampahSortDirection sortDirection;

  const BankSampahState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isFetchingLocation = false,
    this.errorMessage,
    this.actionSuccessMessage,
    this.reports = const [],
    this.locations = const [],
    this.summary,
    this.userLatitude,
    this.userLongitude,
    this.searchQuery = '',
    this.selectedJenisSampahFilter,
    this.selectedBankSampahFilter,
    this.selectedBankId,
    this.sortBy = BankSampahSortBy.date,
    this.sortDirection = BankSampahSortDirection.desc,
  });

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
    if (locations.isEmpty) return null;
    return locations.first;
  }

  List<BankSampahReportEntity> get filteredReports {
    final list = reports.where((report) {
      final matchesSearch =
          searchQuery.isEmpty ||
          report.bankSampahNama.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          report.jenisSampah.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          report.catatan.toLowerCase().contains(searchQuery.toLowerCase()) ||
          report.statusLabel.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesJenis =
          selectedJenisSampahFilter == null ||
          selectedJenisSampahFilter!.isEmpty ||
          report.jenisSampah.toLowerCase() ==
              selectedJenisSampahFilter!.toLowerCase();

      final matchesBankSampah =
          (selectedBankId == null &&
              (selectedBankSampahFilter == null ||
                  selectedBankSampahFilter!.isEmpty)) ||
          (selectedBankId != null &&
              report.bankSampahId == selectedBankId.toString()) ||
          (selectedBankSampahFilter != null &&
              selectedBankSampahFilter!.isNotEmpty &&
              report.bankSampahNama.toLowerCase() ==
                  selectedBankSampahFilter!.toLowerCase());

      return matchesSearch && matchesJenis && matchesBankSampah;
    }).toList();

    switch (sortBy) {
      case BankSampahSortBy.date:
        list.sort((a, b) => sortDirection == BankSampahSortDirection.desc
            ? b.createdAt.compareTo(a.createdAt)
            : a.createdAt.compareTo(b.createdAt));
        break;
      case BankSampahSortBy.weight:
        list.sort((a, b) => sortDirection == BankSampahSortDirection.desc
            ? b.beratKg.compareTo(a.beratKg)
            : a.beratKg.compareTo(b.beratKg));
        break;
      case BankSampahSortBy.price:
        list.sort((a, b) => sortDirection == BankSampahSortDirection.desc
            ? b.nilaiRupiah.compareTo(a.nilaiRupiah)
            : a.nilaiRupiah.compareTo(b.nilaiRupiah));
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

  int get totalLaporanCount => summary?.totalSetoran ?? reports.length;

  double get totalBeratKg =>
      summary?.totalKg ?? reports.fold(0.0, (sum, item) => sum + item.beratKg);

  double get totalNilaiRupiah =>
      summary?.totalPendapatan ??
      reports.fold(0.0, (sum, item) => sum + item.nilaiRupiah);

  BankSampahState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isFetchingLocation,
    String? errorMessage,
    String? actionSuccessMessage,
    List<BankSampahReportEntity>? reports,
    List<BankSampahLocationEntity>? locations,
    BankSampahSummaryEntity? summary,
    double? userLatitude,
    double? userLongitude,
    String? searchQuery,
    String? selectedJenisSampahFilter,
    bool clearJenisFilter = false,
    String? selectedBankSampahFilter,
    bool clearBankSampahFilter = false,
    int? selectedBankId,
    bool clearBankId = false,
    BankSampahSortBy? sortBy,
    BankSampahSortDirection? sortDirection,
    BankSampahSortOption? selectedSortOption,
  }) {
    var resolvedSortBy = sortBy ?? this.sortBy;
    var resolvedSortDirection = sortDirection ?? this.sortDirection;
    if (selectedSortOption != null && sortBy == null && sortDirection == null) {
      resolvedSortBy = selectedSortOption.sortBy;
      resolvedSortDirection = selectedSortOption.sortDirection;
    }
    return BankSampahState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      errorMessage: errorMessage,
      actionSuccessMessage: actionSuccessMessage,
      reports: reports ?? this.reports,
      locations: locations ?? this.locations,
      summary: summary ?? this.summary,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedJenisSampahFilter: clearJenisFilter
          ? null
          : (selectedJenisSampahFilter ?? this.selectedJenisSampahFilter),
      selectedBankSampahFilter: clearBankSampahFilter
          ? null
          : (selectedBankSampahFilter ?? this.selectedBankSampahFilter),
      selectedBankId: (clearBankSampahFilter || clearBankId)
          ? null
          : (selectedBankId ?? this.selectedBankId),
      sortBy: resolvedSortBy,
      sortDirection: resolvedSortDirection,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    isFetchingLocation,
    errorMessage,
    actionSuccessMessage,
    reports,
    locations,
    summary,
    userLatitude,
    userLongitude,
    searchQuery,
    selectedJenisSampahFilter,
    selectedBankSampahFilter,
    selectedBankId,
    sortBy,
    sortDirection,
  ];
}
