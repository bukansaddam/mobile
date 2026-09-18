part of 'organisasi_bloc.dart';

abstract class OrganisasiEvent extends Equatable {
  const OrganisasiEvent();

  @override
  List<Object?> get props => [];
}

class GetOrganisasiEvent extends OrganisasiEvent {
  final String? search;
  final String? field;
  final OrganisasiSortOption? sort;

  const GetOrganisasiEvent({this.search, this.field, this.sort});

  @override
  List<Object?> get props => [search, field, sort];
}

class RefreshOrganisasiEvent extends OrganisasiEvent {
  final String? search;
  final String? field;
  final OrganisasiSortOption? sort;

  const RefreshOrganisasiEvent({this.search, this.field, this.sort});

  @override
  List<Object?> get props => [search, field, sort];
}

class SetOrganisasiFilterEvent extends OrganisasiEvent {
  final String? field;
  final bool hasField;
  final OrganisasiSortOption? sort;
  final String? search;

  const SetOrganisasiFilterEvent({
    this.field,
    this.hasField = false,
    this.sort,
    this.search,
  });

  const SetOrganisasiFilterEvent.field(this.field)
    : hasField = true,
      sort = null,
      search = null;

  const SetOrganisasiFilterEvent.sort(this.sort)
    : field = null,
      hasField = false,
      search = null;

  const SetOrganisasiFilterEvent.search(this.search)
    : field = null,
      hasField = false,
      sort = null;

  @override
  List<Object?> get props => [field, hasField, sort, search];
}

class ResetOrganisasiFilterEvent extends OrganisasiEvent {
  const ResetOrganisasiFilterEvent();
}

class CreateOrganisasiEvent extends OrganisasiEvent {
  final String nama;
  final int jumlahAnggota;
  final String bidang;
  final String? alamatSekretariat;
  final int? provinceId;
  final int? regencyId;
  final int? districtId;
  final int? villageId;

  const CreateOrganisasiEvent({
    required this.nama,
    required this.jumlahAnggota,
    required this.bidang,
    this.alamatSekretariat,
    this.provinceId,
    this.regencyId,
    this.districtId,
    this.villageId,
  });

  @override
  List<Object?> get props => [
    nama,
    jumlahAnggota,
    bidang,
    alamatSekretariat,
    provinceId,
    regencyId,
    districtId,
    villageId,
  ];
}

class UpdateOrganisasiEvent extends OrganisasiEvent {
  final String id;
  final String nama;
  final int jumlahAnggota;
  final String bidang;
  final String? alamatSekretariat;
  final int? provinceId;
  final int? regencyId;
  final int? districtId;
  final int? villageId;

  const UpdateOrganisasiEvent({
    required this.id,
    required this.nama,
    required this.jumlahAnggota,
    required this.bidang,
    this.alamatSekretariat,
    this.provinceId,
    this.regencyId,
    this.districtId,
    this.villageId,
  });

  @override
  List<Object?> get props => [
    id,
    nama,
    jumlahAnggota,
    bidang,
    alamatSekretariat,
    provinceId,
    regencyId,
    districtId,
    villageId,
  ];
}

typedef AddOrganisasiEvent = CreateOrganisasiEvent;
