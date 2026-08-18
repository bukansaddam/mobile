import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/domain/entities/auth_mapper.dart';
import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_location_model.dart';
import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_report_model.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_mapper.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_mapper.dart';
import 'package:akar/features/linmas/demografi/data/models/institusi_model.dart';
import 'package:akar/features/linmas/demografi/data/models/organisasi_model.dart';
import 'package:akar/features/linmas/demografi/data/models/tokoh_model.dart';
import 'package:akar/features/linmas/demografi/domain/entities/institusi_mapper.dart';
import 'package:akar/features/linmas/demografi/domain/entities/organisasi_mapper.dart';
import 'package:akar/features/linmas/demografi/domain/entities/tokoh_mapper.dart';
import 'package:akar/features/linmas/panic/data/models/panic_model.dart';
import 'package:akar/features/linmas/panic/domain/entities/panic_mapper.dart';
import 'package:akar/features/linmas/presensi/data/models/presensi_model.dart';
import 'package:akar/features/linmas/presensi/domain/entities/presensi_mapper.dart';
import 'package:akar/features/linmas/ronda_malam/data/models/ronda_laporan_model.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_mapper.dart';
import 'package:akar/features/linmas/tracking/data/models/tracking_response_model.dart';
import 'package:akar/features/linmas/tracking/domain/entities/tracking_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Mapper Tests', () {
    test('AuthModel and UserModel toDomain & toModel mapping', () {
      final userModel = UserModel(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        username: 'johndoe',
        phoneNumber: '08123456789',
        nik: '1234567890123456',
        role: 'officer',
        latitude: -6.2,
        longitude: 106.8,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
        villageMembersId: 10,
      );

      final authModel = AuthModel(
        message: 'Login successful',
        accessToken: 'token_123',
        tokenType: 'Bearer',
        user: userModel,
      );

      final authEntity = authModel.toDomain();
      expect(authEntity.message, 'Login successful');
      expect(authEntity.accessToken, 'token_123');
      expect(authEntity.tokenType, 'Bearer');
      expect(authEntity.user.id, 1);
      expect(authEntity.user.name, 'John Doe');
      expect(authEntity.user.isOfficer, true);

      final mappedBackModel = authEntity.toModel();
      expect(mappedBackModel.accessToken, authModel.accessToken);
      expect(mappedBackModel.user.id, authModel.user.id);
      expect(mappedBackModel.user.phoneNumber, authModel.user.phoneNumber);
    });
  });

  group('Presensi Mapper Tests', () {
    test('PresensiDataModel toDomain & toModel mapping', () {
      final model = PresensiDataModel(
        id: 'PRS-001',
        userName: 'Budi Santoso',
        address: 'Jl. Merdeka No. 1',
        kecamatan: 'Gambir',
        kelurahan: 'Kebon Kelapa',
        rt: '001',
        rw: '002',
        latitude: -6.1754,
        longitude: 106.8272,
        timestamp: DateTime(2026, 8, 18, 8, 0),
        isSuccess: true,
      );

      final entity = model.toDomain();
      expect(entity.id, 'PRS-001');
      expect(entity.userName, 'Budi Santoso');
      expect(entity.address, 'Jl. Merdeka No. 1');
      expect(entity.latitude, -6.1754);
      expect(entity.isSuccess, true);

      final mappedBack = entity.toModel();
      expect(mappedBack.id, model.id);
      expect(mappedBack.userName, model.userName);
      expect(mappedBack.isSuccess, model.isSuccess);
    });
  });

  group('Ronda Laporan Mapper Tests', () {
    test('RondaLaporanModel toDomain & toModel mapping', () {
      final model = RondaLaporanModel(
        id: 'RND-001',
        sampahMenumpuk: 2,
        selokanMampet: 1,
        fasilitasRusak: 3,
        kegiatanMengganggu: 1,
        potensiBahaya: 2,
        jalanBerlubang: 3,
        lampuMati: 2,
        laporanKeamanan: 1,
        wargaBertengkar: 1,
        tempatKurangAman: 2,
        kerumunanTidakTertib: 1,
        perluBantuanPetugas: 2,
        gangguanKamtibmas: 1,
        aktivitasMencurigakan: 2,
        kehilanganLingkungan: 1,
        wargaButuhBantuan: 2,
        kelompokBerselisih: 1,
        keluhanWarga: 2,
        kejadianMenggangguWarga: 1,
        perluTerusanRTRW: 2,
        permasalahanSosial: 1,
        kasusPerzinahan: 1,
        orangTerlantar: 1,
        keterangan: 'Patroli selesai aman',
        timestamp: DateTime(2026, 8, 18, 23, 0),
      );

      final entity = model.toDomain();
      expect(entity.id, 'RND-001');
      expect(entity.sampahMenumpuk, 2);
      expect(entity.keterangan, 'Patroli selesai aman');

      final mappedBack = entity.toModel();
      expect(mappedBack.id, model.id);
      expect(mappedBack.keterangan, model.keterangan);
      expect(mappedBack.jalanBerlubang, model.jalanBerlubang);
    });
  });

  group('Panic Mapper Tests', () {
    test('NearbyMemberModel & PanicAlertResultModel toDomain & toModel', () {
      final memberModel = NearbyMemberModel(
        id: 'mem_1',
        name: 'Agus',
        role: 'Linmas',
        distanceText: '150 m dari lokasi',
        latitude: -6.2,
        longitude: 106.8,
        phone: '0812345678',
        isOnline: true,
      );

      final memberEntity = memberModel.toDomain();
      expect(memberEntity.id, 'mem_1');
      expect(memberEntity.name, 'Agus');
      expect(memberEntity.distanceText, '150 m dari lokasi');

      final memberBack = memberEntity.toModel();
      expect(memberBack.id, memberModel.id);
      expect(memberBack.name, memberModel.name);

      final alertModel = PanicAlertResultModel(
        isSuccess: true,
        alertId: 'SOS-999',
        timestamp: DateTime(2026, 8, 18, 10, 0),
        message: 'SOS Terkirim',
      );

      final alertEntity = alertModel.toDomain();
      expect(alertEntity.isSuccess, true);
      expect(alertEntity.alertId, 'SOS-999');

      final alertBack = alertEntity.toModel();
      expect(alertBack.alertId, alertModel.alertId);
    });
  });

  group('Tracking Mapper Tests', () {
    test('TrackingResponseModel toDomain & toModel mapping', () {
      final model = TrackingResponseModel(
        success: true,
        message: 'Lokasi berhasil diperbarui',
      );

      final entity = model.toDomain();
      expect(entity.success, true);
      expect(entity.message, 'Lokasi berhasil diperbarui');

      final back = entity.toModel();
      expect(back.success, model.success);
      expect(back.message, model.message);
    });
  });

  group('Demografi Mapper Tests', () {
    test('InstitusiModel toDomain & toModel mapping', () {
      final model = InstitusiModel(
        id: 'INS-01',
        nama: 'Polsek Menteng',
        scope: 'Kecamatan',
        alamat: 'Jl. Menteng',
        createdAt: DateTime(2026, 1, 1),
      );

      final entity = model.toDomain();
      expect(entity.id, 'INS-01');
      expect(entity.nama, 'Polsek Menteng');
      expect(entity.scope, 'Kecamatan');

      final back = entity.toModel();
      expect(back.id, model.id);
      expect(back.nama, model.nama);
    });

    test('TokohModel toDomain & toModel mapping', () {
      final model = TokohModel(
        id: 'TKH-01',
        nama: 'H. Sudirman',
        noTelp: '0812345678',
        jenisKelamin: 'Laki-laki',
        profesi: 'Tokoh Masyarakat',
        wilayah: 'Lokal',
        afiliasi: 'Agama',
        namaOrganisasi: 'MUI',
        jabatanOrganisasi: 'Ketua',
        suku: 'Jawa',
        createdAt: DateTime(2026, 1, 1),
      );

      final entity = model.toDomain();
      expect(entity.id, 'TKH-01');
      expect(entity.nama, 'H. Sudirman');
      expect(entity.afiliasi, 'Agama');

      final back = entity.toModel();
      expect(back.id, model.id);
      expect(back.nama, model.nama);
      expect(back.suku, model.suku);
    });

    test('OrganisasiModel toDomain & toModel mapping', () {
      final model = OrganisasiModel(
        id: 'ORG-01',
        nama: 'Karang Taruna',
        jumlahAnggota: 50,
        bidang: 'Kepemudaan',
        alamatSekretariat: 'Balai Warga',
        createdAt: DateTime(2026, 1, 1),
      );

      final entity = model.toDomain();
      expect(entity.id, 'ORG-01');
      expect(entity.nama, 'Karang Taruna');
      expect(entity.jumlahAnggota, 50);

      final back = entity.toModel();
      expect(back.id, model.id);
      expect(back.nama, model.nama);
      expect(back.bidang, model.bidang);
    });
  });

  group('Bank Sampah Mapper Tests', () {
    test('BankSampahReportModel toDomain & toModel mapping', () {
      final model = BankSampahReportModel(
        id: 'RPT-01',
        bankSampahId: 'BS-01',
        bankSampahNama: 'Bank Sampah Mandiri',
        jenisSampah: 'Organik',
        beratKg: 10.5,
        nilaiRupiah: 52500,
        petugasNama: 'Linmas Budi',
        catatan: 'Sampah daun kering',
        createdAt: DateTime(2026, 8, 18),
      );

      final entity = model.toDomain();
      expect(entity.id, 'RPT-01');
      expect(entity.bankSampahNama, 'Bank Sampah Mandiri');
      expect(entity.beratKg, 10.5);
      expect(entity.nilaiRupiah, 52500);

      final back = entity.toModel();
      expect(back.id, model.id);
      expect(back.beratKg, model.beratKg);
      expect(back.nilaiRupiah, model.nilaiRupiah);
    });

    test('BankSampahLocationModel toDomain & toModel mapping', () {
      final model = BankSampahLocationModel(
        id: 'LOC-01',
        nama: 'Bank Sampah Asri',
        alamat: 'Jl. Asri No. 10',
        kelurahan: 'Asri',
        pengelola: 'Ibu Siti',
        kontak: '0812345678',
        latitude: -6.2,
        longitude: 106.8,
        distanceMeters: 450,
      );

      final entity = model.toDomain();
      expect(entity.id, 'LOC-01');
      expect(entity.nama, 'Bank Sampah Asri');
      expect(entity.formattedDistance, '450 m');

      final back = entity.toModel();
      expect(back.id, model.id);
      expect(back.nama, model.nama);
    });
  });
}
