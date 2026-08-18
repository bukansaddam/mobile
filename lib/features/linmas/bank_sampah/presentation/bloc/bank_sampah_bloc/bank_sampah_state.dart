part of 'bank_sampah_bloc.dart';

enum BankSampahSortOption {
  terbaru('Terbaru', Icons.schedule_rounded),
  terlama('Terlama', Icons.history_rounded),
  bobotTerbanyak('Bobot Terbanyak', Icons.arrow_upward_rounded),
  bobotTersedikit('Bobot Tersedikit', Icons.arrow_downward_rounded),
  nilaiTertinggi('Nilai Tertinggi', Icons.payments_rounded);

  final String label;
  final IconData icon;
  const BankSampahSortOption(this.label, this.icon);
}

class BankSampahState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final bool isFetchingLocation;
  final String? errorMessage;
  final String? actionSuccessMessage;

  final List<BankSampahReportEntity> reports;
  final List<BankSampahLocationEntity> locations;

  final double? userLatitude;
  final double? userLongitude;

  final String searchQuery;
  final String? selectedJenisSampahFilter;
  final String? selectedBankSampahFilter;
  final BankSampahSortOption selectedSortOption;

  const BankSampahState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isFetchingLocation = false,
    this.errorMessage,
    this.actionSuccessMessage,
    this.reports = const [],
    this.locations = const [],
    this.userLatitude,
    this.userLongitude,
    this.searchQuery = '',
    this.selectedJenisSampahFilter,
    this.selectedBankSampahFilter,
    this.selectedSortOption = BankSampahSortOption.terbaru,
  });

  bool get hasActiveFilter =>
      selectedJenisSampahFilter != null ||
      selectedBankSampahFilter != null ||
      selectedSortOption != BankSampahSortOption.terbaru;

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
          report.petugasNama.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesJenis =
          selectedJenisSampahFilter == null ||
          selectedJenisSampahFilter!.isEmpty ||
          report.jenisSampah.toLowerCase() ==
              selectedJenisSampahFilter!.toLowerCase();

      final matchesBankSampah =
          selectedBankSampahFilter == null ||
          selectedBankSampahFilter!.isEmpty ||
          report.bankSampahNama.toLowerCase() ==
              selectedBankSampahFilter!.toLowerCase();

      return matchesSearch && matchesJenis && matchesBankSampah;
    }).toList();

    switch (selectedSortOption) {
      case BankSampahSortOption.terbaru:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case BankSampahSortOption.terlama:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case BankSampahSortOption.bobotTerbanyak:
        list.sort((a, b) => b.beratKg.compareTo(a.beratKg));
        break;
      case BankSampahSortOption.bobotTersedikit:
        list.sort((a, b) => a.beratKg.compareTo(b.beratKg));
        break;
      case BankSampahSortOption.nilaiTertinggi:
        list.sort((a, b) => b.nilaiRupiah.compareTo(a.nilaiRupiah));
        break;
    }

    return list;
  }

  int get totalLaporanCount => reports.length;

  double get totalBeratKg =>
      reports.fold(0.0, (sum, item) => sum + item.beratKg);

  double get totalNilaiRupiah =>
      reports.fold(0.0, (sum, item) => sum + item.nilaiRupiah);

  BankSampahState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isFetchingLocation,
    String? errorMessage,
    String? actionSuccessMessage,
    List<BankSampahReportEntity>? reports,
    List<BankSampahLocationEntity>? locations,
    double? userLatitude,
    double? userLongitude,
    String? searchQuery,
    String? selectedJenisSampahFilter,
    bool clearJenisFilter = false,
    String? selectedBankSampahFilter,
    bool clearBankSampahFilter = false,
    BankSampahSortOption? selectedSortOption,
  }) {
    return BankSampahState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      errorMessage: errorMessage,
      actionSuccessMessage: actionSuccessMessage,
      reports: reports ?? this.reports,
      locations: locations ?? this.locations,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedJenisSampahFilter: clearJenisFilter
          ? null
          : (selectedJenisSampahFilter ?? this.selectedJenisSampahFilter),
      selectedBankSampahFilter: clearBankSampahFilter
          ? null
          : (selectedBankSampahFilter ?? this.selectedBankSampahFilter),
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
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
    userLatitude,
    userLongitude,
    searchQuery,
    selectedJenisSampahFilter,
    selectedBankSampahFilter,
    selectedSortOption,
  ];
}
