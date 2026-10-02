part of 'bank_sampah_bloc.dart';

abstract class BankSampahEvent extends Equatable {
  const BankSampahEvent();

  @override
  List<Object?> get props => [];
}

class GetBankSampahReportsEvent extends BankSampahEvent {
  final String? jenisSampah;
  final int? bankId;
  final String? bankSampahNama;
  final BankSampahSortBy? sortBy;
  final BankSampahSortDirection? sortDirection;
  final BankSampahSortOption? sortOption;

  const GetBankSampahReportsEvent({
    this.jenisSampah,
    this.bankId,
    this.bankSampahNama,
    this.sortBy,
    this.sortDirection,
    this.sortOption,
  });

  @override
  List<Object?> get props => [
    jenisSampah,
    bankId,
    bankSampahNama,
    sortBy,
    sortDirection,
    sortOption,
  ];
}

class RefreshBankSampahReportsEvent extends BankSampahEvent {
  final String? jenisSampah;
  final int? bankId;
  final String? bankSampahNama;
  final BankSampahSortBy? sortBy;
  final BankSampahSortDirection? sortDirection;
  final BankSampahSortOption? sortOption;

  const RefreshBankSampahReportsEvent({
    this.jenisSampah,
    this.bankId,
    this.bankSampahNama,
    this.sortBy,
    this.sortDirection,
    this.sortOption,
  });

  @override
  List<Object?> get props => [
    jenisSampah,
    bankId,
    bankSampahNama,
    sortBy,
    sortDirection,
    sortOption,
  ];
}

class SetBankSampahFilterEvent extends BankSampahEvent {
  final String? jenisSampah;
  final bool hasJenisSampah;
  final int? bankId;
  final String? bankSampahNama;
  final bool hasBankSampah;
  final BankSampahSortBy? sortBy;
  final BankSampahSortDirection? sortDirection;
  final BankSampahSortOption? sortOption;

  const SetBankSampahFilterEvent({
    this.jenisSampah,
    this.hasJenisSampah = false,
    this.bankId,
    this.bankSampahNama,
    this.hasBankSampah = false,
    this.sortBy,
    this.sortDirection,
    this.sortOption,
  });

  const SetBankSampahFilterEvent.jenis(this.jenisSampah)
    : hasJenisSampah = true,
      bankId = null,
      bankSampahNama = null,
      hasBankSampah = false,
      sortBy = null,
      sortDirection = null,
      sortOption = null;

  const SetBankSampahFilterEvent.bank({this.bankId, this.bankSampahNama})
    : hasJenisSampah = false,
      jenisSampah = null,
      hasBankSampah = true,
      sortBy = null,
      sortDirection = null,
      sortOption = null;

  const SetBankSampahFilterEvent.sort({this.sortBy, this.sortDirection})
    : hasJenisSampah = false,
      jenisSampah = null,
      bankId = null,
      bankSampahNama = null,
      hasBankSampah = false,
      sortOption = null;

  const SetBankSampahFilterEvent.sortOption(this.sortOption)
    : hasJenisSampah = false,
      jenisSampah = null,
      bankId = null,
      bankSampahNama = null,
      hasBankSampah = false,
      sortBy = null,
      sortDirection = null;

  @override
  List<Object?> get props => [
    jenisSampah,
    hasJenisSampah,
    bankId,
    bankSampahNama,
    hasBankSampah,
    sortBy,
    sortDirection,
    sortOption,
  ];
}

class ResetBankSampahFilterEvent extends BankSampahEvent {
  const ResetBankSampahFilterEvent();
}

class CreateBankSampahReportEvent extends BankSampahEvent {
  final BankSampahReportEntity report;

  const CreateBankSampahReportEvent(this.report);

  @override
  List<Object?> get props => [report];
}

class DeleteBankSampahReportEvent extends BankSampahEvent {
  final String id;

  const DeleteBankSampahReportEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddBankSampahLocationEvent extends BankSampahEvent {
  final BankSampahLocationEntity location;

  const AddBankSampahLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}

class UpdateBankSampahUserLocationEvent extends BankSampahEvent {
  final bool silent;

  const UpdateBankSampahUserLocationEvent({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

class GetBankSampahLocationsEvent extends BankSampahEvent {
  const GetBankSampahLocationsEvent();
}

typedef RefreshBankSampahDataEvent = RefreshBankSampahReportsEvent;
