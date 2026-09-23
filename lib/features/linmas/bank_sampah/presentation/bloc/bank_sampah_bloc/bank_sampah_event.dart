part of 'bank_sampah_bloc.dart';

abstract class BankSampahEvent extends Equatable {
  const BankSampahEvent();

  @override
  List<Object?> get props => [];
}

class FetchBankSampahDataEvent extends BankSampahEvent {}

class RefreshBankSampahDataEvent extends BankSampahEvent {}

class UpdateBankSampahUserLocationEvent extends BankSampahEvent {
  final bool silent;

  const UpdateBankSampahUserLocationEvent({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

class SetBankSampahSearchQueryEvent extends BankSampahEvent {
  final String query;

  const SetBankSampahSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SetBankSampahJenisFilterEvent extends BankSampahEvent {
  final String? jenis;

  const SetBankSampahJenisFilterEvent(this.jenis);

  @override
  List<Object?> get props => [jenis];
}

class SetBankSampahLocationFilterEvent extends BankSampahEvent {
  final String? bankSampahNama;

  const SetBankSampahLocationFilterEvent(this.bankSampahNama);

  @override
  List<Object?> get props => [bankSampahNama];
}

class SetBankSampahSortOptionEvent extends BankSampahEvent {
  final BankSampahSortOption sortOption;

  const SetBankSampahSortOptionEvent(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

class ResetBankSampahFiltersEvent extends BankSampahEvent {}

class AddBankSampahReportEvent extends BankSampahEvent {
  final String bankSampahId;
  final String bankSampahNama;
  final String jenisSampah;
  final double beratKg;
  final String? fotoPath;
  final String? fotoUrl;
  final String catatan;
  final String petugasNama;
  final DateTime? reportDate;

  const AddBankSampahReportEvent({
    required this.bankSampahId,
    required this.bankSampahNama,
    required this.jenisSampah,
    required this.beratKg,
    this.fotoPath,
    this.fotoUrl,
    this.catatan = '',
    this.petugasNama = '',
    this.reportDate,
  });

  @override
  List<Object?> get props => [
    bankSampahId,
    bankSampahNama,
    jenisSampah,
    beratKg,
    fotoPath,
    fotoUrl,
    catatan,
    petugasNama,
    reportDate,
  ];
}

class DeleteBankSampahReportEvent extends BankSampahEvent {
  final String id;

  const DeleteBankSampahReportEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddBankSampahLocationEvent extends BankSampahEvent {
  final String nama;
  final String alamat;
  final String kelurahan;
  final String pengelola;
  final String kontak;

  const AddBankSampahLocationEvent({
    required this.nama,
    required this.alamat,
    this.kelurahan = '',
    this.pengelola = '',
    this.kontak = '',
  });

  @override
  List<Object?> get props => [nama, alamat, kelurahan, pengelola, kontak];
}
