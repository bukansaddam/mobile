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

abstract class BankSampahState extends Equatable {
  const BankSampahState();

  @override
  List<Object?> get props => [];
}

class BankSampahInitial extends BankSampahState {}

class BankSampahLoading extends BankSampahState {}

class BankSampahLoaded extends BankSampahState {
  final BankSampahPaginatedEntity paginatedEntity;

  const BankSampahLoaded(this.paginatedEntity);

  @override
  List<Object?> get props => [paginatedEntity];
}

class BankSampahFailure extends BankSampahState {
  final String message;

  const BankSampahFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class BankSampahActionLoading extends BankSampahState {}

class BankSampahActionSuccess extends BankSampahState {
  final BankSampahReportEntity? report;
  final BankSampahLocationEntity? location;
  final String message;

  const BankSampahActionSuccess({
    this.report,
    this.location,
    required this.message,
  });

  @override
  List<Object?> get props => [report, location, message];
}

class BankSampahActionFailure extends BankSampahState {
  final String message;

  const BankSampahActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
