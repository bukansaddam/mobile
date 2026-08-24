part of 'demografi_bloc.dart';

abstract class DemografiEvent extends Equatable {
  const DemografiEvent();

  @override
  List<Object?> get props => [];
}

class FetchDemografiDataEvent extends DemografiEvent {}

class SetDemografiActiveTabEvent extends DemografiEvent {
  final int index;

  const SetDemografiActiveTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SetDemografiSearchQueryEvent extends DemografiEvent {
  final String query;

  const SetDemografiSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearDemografiSearchEvent extends DemografiEvent {}

class SetDemografiProfesiFilterEvent extends DemografiEvent {
  final String? profesi;

  const SetDemografiProfesiFilterEvent(this.profesi);

  @override
  List<Object?> get props => [profesi];
}

class SetDemografiScopeFilterEvent extends DemografiEvent {
  final String? scope;

  const SetDemografiScopeFilterEvent(this.scope);

  @override
  List<Object?> get props => [scope];
}

class SetDemografiAfiliasiFilterEvent extends DemografiEvent {
  final String? afiliasi;

  const SetDemografiAfiliasiFilterEvent(this.afiliasi);

  @override
  List<Object?> get props => [afiliasi];
}

class SetDemografiInstitusiScopeFilterEvent extends DemografiEvent {
  final String? scope;

  const SetDemografiInstitusiScopeFilterEvent(this.scope);

  @override
  List<Object?> get props => [scope];
}

class SetDemografiOrganisasiBidangFilterEvent extends DemografiEvent {
  final String? bidang;

  const SetDemografiOrganisasiBidangFilterEvent(this.bidang);

  @override
  List<Object?> get props => [bidang];
}

class SetDemografiSortOptionEvent extends DemografiEvent {
  final DemografiSortOption option;

  const SetDemografiSortOptionEvent(this.option);

  @override
  List<Object?> get props => [option];
}

class ResetDemografiFiltersEvent extends DemografiEvent {}

class AddTokohEvent extends DemografiEvent {
  final String nama;
  final String noTelp;
  final String jenisKelamin;
  final String profesi;
  final String wilayah;
  final String namaInstitusi;
  final String jabatanInstitusi;
  final String afiliasi;
  final String namaOrganisasi;
  final String jabatanOrganisasi;
  final String suku;

  const AddTokohEvent({
    required this.nama,
    this.noTelp = '',
    this.jenisKelamin = 'Laki-laki',
    required this.profesi,
    this.wilayah = 'Nasional',
    this.namaInstitusi = '',
    this.jabatanInstitusi = '',
    required this.afiliasi,
    this.namaOrganisasi = '',
    this.jabatanOrganisasi = '',
    required this.suku,
  });

  @override
  List<Object?> get props => [
    nama,
    noTelp,
    jenisKelamin,
    profesi,
    wilayah,
    namaInstitusi,
    jabatanInstitusi,
    afiliasi,
    namaOrganisasi,
    jabatanOrganisasi,
    suku,
  ];
}

class SetDemografiInstitusiKategoriFilterEvent extends DemografiEvent {
  final String? kategori;

  const SetDemografiInstitusiKategoriFilterEvent(this.kategori);

  @override
  List<Object?> get props => [kategori];
}

class AddInstitusiEvent extends DemografiEvent {
  final String nama;
  final String kategori;
  final String scope;
  final String? alamat;

  const AddInstitusiEvent({
    required this.nama,
    this.kategori = 'Pemerintahan & Birokrasi',
    required this.scope,
    this.alamat,
  });

  @override
  List<Object?> get props => [nama, kategori, scope, alamat];
}

class AddOrganisasiEvent extends DemografiEvent {
  final String nama;
  final int jumlahAnggota;
  final String bidang;
  final String? alamatSekretariat;

  const AddOrganisasiEvent({
    required this.nama,
    required this.jumlahAnggota,
    required this.bidang,
    this.alamatSekretariat,
  });

  @override
  List<Object?> get props => [nama, jumlahAnggota, bidang, alamatSekretariat];
}
