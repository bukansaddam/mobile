import 'package:equatable/equatable.dart';

class TokohEntity extends Equatable {
  final String? id;
  final String nama;
  final String noTelp;
  final String jenisKelamin; // Laki-laki, Perempuan
  final String profesi;
  final String wilayah; // Scope
  final int? instituteId;
  final String namaInstitusi;
  final String jabatanInstitusi;
  final String afiliasi; // Politik, Ormas, Agama, Budaya, Pemuda, Pengusaha
  final int? organizationId;
  final String namaOrganisasi;
  final String jabatanOrganisasi;
  final String suku;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TokohEntity({
    this.id,
    required this.nama,
    this.noTelp = '',
    this.jenisKelamin = 'Laki-laki',
    required this.profesi,
    this.wilayah = 'Nasional',
    this.instituteId,
    this.namaInstitusi = '',
    this.jabatanInstitusi = '',
    required this.afiliasi,
    this.organizationId,
    this.namaOrganisasi = '',
    this.jabatanOrganisasi = '',
    required this.suku,
    this.createdAt,
    this.updatedAt,
  });

  TokohEntity copyWith({
    String? id,
    String? nama,
    String? noTelp,
    String? jenisKelamin,
    String? profesi,
    String? wilayah,
    int? instituteId,
    String? namaInstitusi,
    String? jabatanInstitusi,
    String? afiliasi,
    int? organizationId,
    String? namaOrganisasi,
    String? jabatanOrganisasi,
    String? suku,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TokohEntity(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      noTelp: noTelp ?? this.noTelp,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      profesi: profesi ?? this.profesi,
      wilayah: wilayah ?? this.wilayah,
      instituteId: instituteId ?? this.instituteId,
      namaInstitusi: namaInstitusi ?? this.namaInstitusi,
      jabatanInstitusi: jabatanInstitusi ?? this.jabatanInstitusi,
      afiliasi: afiliasi ?? this.afiliasi,
      organizationId: organizationId ?? this.organizationId,
      namaOrganisasi: namaOrganisasi ?? this.namaOrganisasi,
      jabatanOrganisasi: jabatanOrganisasi ?? this.jabatanOrganisasi,
      suku: suku ?? this.suku,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    nama,
    noTelp,
    jenisKelamin,
    profesi,
    wilayah,
    instituteId,
    namaInstitusi,
    jabatanInstitusi,
    afiliasi,
    organizationId,
    namaOrganisasi,
    jabatanOrganisasi,
    suku,
    createdAt,
    updatedAt,
  ];
}

class TokohPaginatedEntity extends Equatable {
  final bool success;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final List<TokohEntity> data;
  final String? message;

  const TokohPaginatedEntity({
    this.success = false,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.data = const [],
    this.message,
  });

  @override
  List<Object?> get props => [
    success,
    total,
    currentPage,
    lastPage,
    perPage,
    data,
    message,
  ];
}
