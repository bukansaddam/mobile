import '../../domain/entities/tokoh_entity.dart';

class TokohMetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const TokohMetaModel({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
  });

  factory TokohMetaModel.fromJson(Map<String, dynamic> json) {
    return TokohMetaModel(
      currentPage: json['current_page'] is int
          ? json['current_page'] as int
          : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: json['last_page'] is int
          ? json['last_page'] as int
          : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      perPage: json['per_page'] is int
          ? json['per_page'] as int
          : int.tryParse(json['per_page']?.toString() ?? '10') ?? 10,
      total: json['total'] is int
          ? json['total'] as int
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

class TokohResponseModel {
  final bool success;
  final String? message;
  final List<TokohModel> data;
  final TokohMetaModel? meta;

  const TokohResponseModel({
    this.success = false,
    this.message,
    this.data = const [],
    this.meta,
  });

  factory TokohResponseModel.fromJson(Map<String, dynamic> json) {
    List<TokohModel> list = [];
    final rawData = json['data'];
    if (rawData is List) {
      list = rawData
          .whereType<Map>()
          .map((e) => TokohModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    TokohMetaModel? meta;
    if (json['meta'] is Map) {
      meta = TokohMetaModel.fromJson(
        Map<String, dynamic>.from(json['meta'] as Map),
      );
    } else if (json['current_page'] != null) {
      meta = TokohMetaModel.fromJson(json);
    }

    return TokohResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      data: list,
      meta: meta,
    );
  }
}

class TokohModel extends TokohEntity {
  const TokohModel({
    super.id,
    required super.nama,
    super.noTelp = '',
    super.jenisKelamin = 'Laki-laki',
    required super.profesi,
    super.wilayah = 'Nasional',
    super.instituteId,
    super.namaInstitusi = '',
    super.jabatanInstitusi = '',
    required super.afiliasi,
    super.organizationId,
    super.namaOrganisasi = '',
    super.jabatanOrganisasi = '',
    required super.suku,
    super.createdAt,
    super.updatedAt,
  });

  factory TokohModel.fromJson(Map<String, dynamic> json) {
    // 1. Parsing Nama
    final name = (json['name'] ?? json['nama'] ?? '').toString();

    // 2. Parsing Phone
    final phone = (json['phone'] ?? json['no_telp'] ?? json['noTelp'] ?? '')
        .toString();

    // 3. Parsing Gender
    final rawGender =
        (json['gender'] ??
                json['jenis_kelamin'] ??
                json['jenisKelamin'] ??
                'laki_laki')
            .toString()
            .toLowerCase();
    final String gender =
        (rawGender.contains('perempuan') || rawGender.contains('wanita'))
        ? 'Perempuan'
        : 'Laki-laki';

    // 4. Parsing Institusi ID & Nama & Jabatan
    int? instId;
    final rawInstId =
        json['institute_id'] ?? json['institution_id'] ?? json['institusi_id'];
    if (rawInstId is int) {
      instId = rawInstId;
    } else if (rawInstId is String) {
      instId = int.tryParse(rawInstId);
    }

    String instName = (json['institute_name'] ?? json['namaInstitusi'] ?? '')
        .toString();
    if (instName.isEmpty && json['institute'] is Map) {
      instName = (json['institute']['name'] ?? json['institute']['nama'] ?? '')
          .toString();
      if (instId == null && json['institute']['id'] != null) {
        instId = int.tryParse(json['institute']['id'].toString());
      }
    } else if (instName.isEmpty && json['institution'] is Map) {
      instName =
          (json['institution']['name'] ?? json['institution']['nama'] ?? '')
              .toString();
      if (instId == null && json['institution']['id'] != null) {
        instId = int.tryParse(json['institution']['id'].toString());
      }
    }

    final instPos =
        (json['institute_position'] ??
                json['institution_position'] ??
                json['jabatan_institusi'] ??
                json['jabatanInstitusi'] ??
                '')
            .toString();

    // 5. Parsing Organisasi ID & Nama & Jabatan
    int? orgId;
    final rawOrgId = json['organization_id'] ?? json['organisasi_id'];
    if (rawOrgId is int) {
      orgId = rawOrgId;
    } else if (rawOrgId is String) {
      orgId = int.tryParse(rawOrgId);
    }

    String orgName = (json['organization_name'] ?? json['namaOrganisasi'] ?? '')
        .toString();
    if (orgName.isEmpty && json['organization'] is Map) {
      orgName =
          (json['organization']['name'] ?? json['organization']['nama'] ?? '')
              .toString();
      if (orgId == null && json['organization']['id'] != null) {
        orgId = int.tryParse(json['organization']['id'].toString());
      }
    }

    final orgPos =
        (json['organization_position'] ??
                json['jabatan_organisasi'] ??
                json['jabatanOrganisasi'] ??
                '')
            .toString();

    // 6. Parsing Profesi, Afiliasi, Suku, Wilayah
    final prof =
        (json['professions'] ??
                json['profession'] ??
                json['profesi'] ??
                'Pejabat')
            .toString();
    final afil =
        (json['affiliations'] ??
                json['affiliation'] ??
                json['afiliasi'] ??
                'Politik')
            .toString();
    final ethnic = (json['ethnic'] ?? json['suku'] ?? '').toString();
    final wil = (json['wilayah'] ?? json['scope'] ?? 'Nasional').toString();

    // 7. Parsing Dates
    DateTime? created;
    final rawCreated = json['created_at'] ?? json['createdAt'];
    if (rawCreated is String) {
      created = DateTime.tryParse(rawCreated);
    } else if (rawCreated is DateTime) {
      created = rawCreated;
    }

    DateTime? updated;
    final rawUpdated = json['updated_at'] ?? json['updatedAt'];
    if (rawUpdated is String) {
      updated = DateTime.tryParse(rawUpdated);
    } else if (rawUpdated is DateTime) {
      updated = rawUpdated;
    }

    return TokohModel(
      id: json['id']?.toString(),
      nama: name,
      noTelp: phone,
      jenisKelamin: gender,
      profesi: prof,
      wilayah: wil,
      instituteId: instId,
      namaInstitusi: instName,
      jabatanInstitusi: instPos,
      afiliasi: afil,
      organizationId: orgId,
      namaOrganisasi: orgName,
      jabatanOrganisasi: orgPos,
      suku: ethnic,
      createdAt: created,
      updatedAt: updated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'noTelp': noTelp,
      'jenisKelamin': jenisKelamin,
      'profesi': profesi,
      'wilayah': wilayah,
      'instituteId': instituteId,
      'namaInstitusi': namaInstitusi,
      'jabatanInstitusi': jabatanInstitusi,
      'afiliasi': afiliasi,
      'organizationId': organizationId,
      'namaOrganisasi': namaOrganisasi,
      'jabatanOrganisasi': jabatanOrganisasi,
      'suku': suku,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toApiJson() {
    String apiGender = 'laki_laki';
    final g = jenisKelamin
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    if (g.contains('perempuan') || g.contains('wanita')) {
      apiGender = 'perempuan';
    } else {
      apiGender = 'laki_laki';
    }

    return {
      'name': nama,
      'phone': noTelp,
      'gender': apiGender,
      'institute_id': instituteId ?? 0,
      'institute_position': jabatanInstitusi.trim(),
      'affiliations': afiliasi.trim(),
      'professions': profesi.trim(),
      'organization_id': organizationId ?? 0,
      'organization_position': jabatanOrganisasi.trim(),
      'ethnic': suku.trim(),
    };
  }

  factory TokohModel.fromEntity(TokohEntity entity) {
    return TokohModel(
      id: entity.id,
      nama: entity.nama,
      noTelp: entity.noTelp,
      jenisKelamin: entity.jenisKelamin,
      profesi: entity.profesi,
      wilayah: entity.wilayah,
      instituteId: entity.instituteId,
      namaInstitusi: entity.namaInstitusi,
      jabatanInstitusi: entity.jabatanInstitusi,
      afiliasi: entity.afiliasi,
      organizationId: entity.organizationId,
      namaOrganisasi: entity.namaOrganisasi,
      jabatanOrganisasi: entity.jabatanOrganisasi,
      suku: entity.suku,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
