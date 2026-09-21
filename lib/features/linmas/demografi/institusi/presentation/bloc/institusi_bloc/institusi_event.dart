part of 'institusi_bloc.dart';

abstract class InstitusiEvent extends Equatable {
  const InstitusiEvent();

  @override
  List<Object?> get props => [];
}

class GetInstitusiCategoriesEvent extends InstitusiEvent {
  final String domain;

  const GetInstitusiCategoriesEvent({this.domain = 'institution'});

  @override
  List<Object?> get props => [domain];
}

class GetInstitusiEvent extends InstitusiEvent {
  final String? search;
  final String? scope;
  final String? kategori;
  final InstitusiSortOption? sort;

  const GetInstitusiEvent({this.search, this.scope, this.kategori, this.sort});

  @override
  List<Object?> get props => [search, scope, kategori, sort];
}

class RefreshInstitusiEvent extends InstitusiEvent {
  final String? search;
  final String? scope;
  final String? kategori;
  final InstitusiSortOption? sort;

  const RefreshInstitusiEvent({
    this.search,
    this.scope,
    this.kategori,
    this.sort,
  });

  @override
  List<Object?> get props => [search, scope, kategori, sort];
}

class SetInstitusiFilterEvent extends InstitusiEvent {
  final String? scope;
  final bool hasScope;
  final String? kategori;
  final bool hasKategori;
  final InstitusiSortOption? sort;
  final String? search;

  const SetInstitusiFilterEvent({
    this.scope,
    this.hasScope = false,
    this.kategori,
    this.hasKategori = false,
    this.sort,
    this.search,
  });

  const SetInstitusiFilterEvent.scope(this.scope)
    : hasScope = true,
      kategori = null,
      hasKategori = false,
      sort = null,
      search = null;

  const SetInstitusiFilterEvent.kategori(this.kategori)
    : hasKategori = true,
      scope = null,
      hasScope = false,
      sort = null,
      search = null;

  const SetInstitusiFilterEvent.sort(this.sort)
    : scope = null,
      hasScope = false,
      kategori = null,
      hasKategori = false,
      search = null;

  const SetInstitusiFilterEvent.search(this.search)
    : scope = null,
      hasScope = false,
      kategori = null,
      hasKategori = false,
      sort = null;

  @override
  List<Object?> get props => [
    scope,
    hasScope,
    kategori,
    hasKategori,
    sort,
    search,
  ];
}

class ResetInstitusiFilterEvent extends InstitusiEvent {
  const ResetInstitusiFilterEvent();
}

class CreateInstitusiEvent extends InstitusiEvent {
  final String nama;
  final String scope;
  final String? kategori;
  final int? categoryId;
  final String? alamat;
  final int? provinceId;
  final int? regencyId;
  final int? districtId;
  final int? villageId;

  const CreateInstitusiEvent({
    required this.nama,
    required this.scope,
    this.kategori,
    this.categoryId,
    this.alamat,
    this.provinceId,
    this.regencyId,
    this.districtId,
    this.villageId,
  });

  @override
  List<Object?> get props => [
    nama,
    scope,
    kategori,
    categoryId,
    alamat,
    provinceId,
    regencyId,
    districtId,
    villageId,
  ];
}

class UpdateInstitusiEvent extends InstitusiEvent {
  final String id;
  final String nama;
  final String scope;
  final String? kategori;
  final int? categoryId;
  final String? alamat;
  final int? provinceId;
  final int? regencyId;
  final int? districtId;
  final int? villageId;

  const UpdateInstitusiEvent({
    required this.id,
    required this.nama,
    required this.scope,
    this.kategori,
    this.categoryId,
    this.alamat,
    this.provinceId,
    this.regencyId,
    this.districtId,
    this.villageId,
  });

  @override
  List<Object?> get props => [
    id,
    nama,
    scope,
    kategori,
    categoryId,
    alamat,
    provinceId,
    regencyId,
    districtId,
    villageId,
  ];
}

typedef AddInstitusiEvent = CreateInstitusiEvent;
