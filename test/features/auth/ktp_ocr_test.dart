import 'package:akar/features/auth/data/models/ktp_ocr_model.dart';
import 'package:akar/features/auth/domain/entities/ktp_ocr_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('respons data.all_fields terpetakan ke entity', () {
    final entity = KtpOcrModel.fromJson(const {
      'success': true,
      'data': {
        'document_type': 'ktp',
        'nik': '3201234567890001',
        'all_fields': {
          'nik': '3201234567890001',
          'nama': 'SADDAM HUSSEIN',
          'tempat_lahir': 'JAKARTA',
          'tanggal_lahir': '15-08-1995',
          'alamat': 'JL. MERDEKA NO. 12',
          'rt': '001',
          'rw': '002',
          'kel_desa': 'CILANDAK',
          'kecamatan': 'PASAR MINGGU',
          'kab_kota': 'KOTA JAKARTA SELATAN',
          'provinsi': 'DKI JAKARTA',
        },
      },
    }).toDomain();

    expect(entity.nik, '3201234567890001');
    expect(entity.name, 'SADDAM HUSSEIN');
    expect(entity.birthPlace, 'JAKARTA');
    expect(entity.birthDate, DateTime(1995, 8, 15));
    expect(
      entity.address,
      'JL. MERDEKA NO. 12, RT 001/RW 002, CILANDAK, PASAR MINGGU, '
      'KOTA JAKARTA SELATAN, DKI JAKARTA',
    );
  });

  test('respons server nyata dengan raw_texts diekstrak', () {
    final entity = KtpOcrModel.fromJson({
      'success': true,
      'message': 'Dokumen berhasil dipindai.',
      'data': {
        'document_type': 'ktp',
        'nik': '3271063010020008',
        'raw_texts': const [
          'PROVINSI JAWA BARAT',
          'KOTA BOGOR',
          'NIK : 3271063010020008',
          'Nama MUCHAMMAD ABDUROHIM',
          'Tempat/Tgl Lahir : BOGOR, 30-10-2002 Jenis kelamın LAKI LAKI Gol Darah',
          'Alamat KEDUNG BADAK NO 16',
          'RT/RW 008/002',
          'Kel/Desa KEDUNG BADAK',
          'Kecamatan TANAH SAREAL',
          'Agama ISLAM',
          'Status Perkawnan : BELUM KAWIN Pekerjaan PELAJAR/MAHASISWA KOTA BOGOR',
          'Kewaiganegaraan : WNI 06-11-2020',
          'Berlaku Hingga SEUMUR HIDUP',
        ],
        'all_fields': const {
          'nik': '3271063010020008',
          'provinsi': 'JAWA BARAT',
          'kab_kota': 'KOTA BOGOR',
          'nama': 'MUCHAMMAD ABDUROHIM',
          'tempat_lahir': 'BOGOR',
          'tanggal_lahir': '30-10-2002',
          'ttl': 'BOGOR, 30-10-2002',
          'jenis_kelamin': 'LAKI-LAKI',
          'alamat': 'KEDUNG BADAK NO 16',
          'rt_rw': '008/002',
          'rt': '008',
          'rw': '002',
          'kel_desa': 'KEDUNG BADAK',
          'kecamatan': 'TANAH SAREAL',
          'agama': 'ISLAM',
          'status': 'BELUM KAWIN',
          'pekerjaan': 'PELAJAR/MAHASISWA',
          'kewarganegaraan': 'WNI',
          'berlaku_hingga': 'SEUMUR HIDUP',
        },
        'auto_cropped': true,
        'selected_variant': 'cropped_base',
      },
    }).toDomain();

    expect(entity.nik, '3271063010020008');
    expect(entity.name, 'MUCHAMMAD ABDUROHIM');
    expect(entity.birthPlace, 'BOGOR');
    expect(entity.birthDate, DateTime(2002, 10, 30));
    expect(
      entity.address,
      'KEDUNG BADAK NO 16, RT 008/RW 002, KEDUNG BADAK, TANAH SAREAL, '
      'KOTA BOGOR, JAWA BARAT',
    );
  });

  test('respons flat memakai nik root dan ttl gabungan', () {
    final entity = KtpOcrModel.fromJson(const {
      'success': true,
      'nik': '3201234567890002',
      'all_fields': {'nama': 'BUDI', 'ttl': 'BANDUNG, 01/02/1990'},
    }).toDomain();

    expect(entity.nik, '3201234567890002');
    expect(entity.name, 'BUDI');
    expect(entity.birthPlace, 'BANDUNG');
    expect(entity.birthDate, DateTime(1990, 2, 1));
    expect(entity.address, '');
  });

  test('tanggal lahir tidak dikenal dibiarkan null', () {
    final entity = KtpOcrModel.fromJson(const {
      'all_fields': {'tanggal_lahir': 'tidak terbaca'},
    }).toDomain();

    expect(entity.birthDate, isNull);
  });
}
