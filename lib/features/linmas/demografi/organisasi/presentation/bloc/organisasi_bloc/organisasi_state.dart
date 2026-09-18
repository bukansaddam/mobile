part of 'organisasi_bloc.dart';

enum OrganisasiSortOption {
  terbaru('Terbaru', Icons.schedule_rounded),
  namaAz('Nama (A - Z)', Icons.sort_by_alpha_rounded),
  namaZa('Nama (Z - A)', Icons.sort_by_alpha_rounded);

  final String label;
  final IconData icon;

  const OrganisasiSortOption(this.label, this.icon);
}

abstract class OrganisasiState extends Equatable {
  const OrganisasiState();

  @override
  List<Object?> get props => [];
}

class OrganisasiInitial extends OrganisasiState {}

class OrganisasiLoading extends OrganisasiState {}

class OrganisasiLoaded extends OrganisasiState {
  final OrganisasiPaginatedEntity organisasiPaginatedEntity;

  const OrganisasiLoaded(this.organisasiPaginatedEntity);

  @override
  List<Object?> get props => [organisasiPaginatedEntity];
}

class OrganisasiFailure extends OrganisasiState {
  final String message;

  const OrganisasiFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class OrganisasiActionLoading extends OrganisasiState {}

class OrganisasiActionSuccess extends OrganisasiState {
  final OrganisasiEntity organisasi;
  final String message;

  const OrganisasiActionSuccess({
    required this.organisasi,
    required this.message,
  });

  @override
  List<Object?> get props => [organisasi, message];
}

class OrganisasiActionFailure extends OrganisasiState {
  final String message;

  const OrganisasiActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
