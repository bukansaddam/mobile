import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/models/ktp_ocr_model.dart';
import 'package:akar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:akar/features/auth/data/mappers/ktp_ocr_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastOptions = options;
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

class _FakeAuthLocalDatasource extends Fake implements AuthLocalDatasource {}

ResponseBody _jsonResponse(Map<String, dynamic> body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

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

  test('hasReadableData true jika ada field terbaca dan false jika kosong', () {
    expect(const KtpOcrModel().hasReadableData, isFalse);
    expect(const KtpOcrModel(nik: '3201234567890001').hasReadableData, isTrue);
    expect(const KtpOcrModel(name: 'BUDI').hasReadableData, isTrue);
  });

  group('AuthRemoteDatasourceImpl.scanKtp classification', () {
    late Directory tempDir;
    late File tempJpg;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ktp_ocr_test_');
      tempJpg = File('${tempDir.path}/ktp.jpg')
        ..writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10]);
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    AuthRepositoryImpl buildRepo(_StubAdapter adapter) {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      return AuthRepositoryImpl(
        remoteDatasource: AuthRemoteDatasourceImpl(dioClient: dio),
        localDatasource: _FakeAuthLocalDatasource(),
      );
    }

    test('valid KTP uppercase document_type dan omitted document_type berhasil dengan timeout 30s', () async {
      final adapter = _StubAdapter(
        (_) async => _jsonResponse({
          'success': true,
          'data': {
            'document_type': 'KTP',
            'all_fields': {'nik': '3201234567890001', 'nama': 'BUDI'},
          },
        }),
      );
      final repo = buildRepo(adapter);

      final result = await repo.scanKtp(tempJpg);
      expect(result.isRight, isTrue);
      expect(result.right.nik, '3201234567890001');
      expect(adapter.lastOptions?.sendTimeout, const Duration(seconds: 30));
      expect(adapter.lastOptions?.receiveTimeout, const Duration(seconds: 30));

      final flatAdapter = _StubAdapter(
        (_) async => _jsonResponse({
          'success': true,
          'nik': '3201234567890002',
          'all_fields': {'nama': 'SITI'},
        }),
      );
      final flatResult = await buildRepo(flatAdapter).scanKtp(tempJpg);
      expect(flatResult.isRight, isTrue);
      expect(flatResult.right.name, 'SITI');
    });

    test('HTTP 422 dengan key error dipetakan ke ValidationFailure dengan pesan server', () async {
      final adapter = _StubAdapter(
        (_) async => _jsonResponse(
          {'error': 'Dokumen bukan e-KTP'},
          statusCode: 422,
        ),
      );
      final result = await buildRepo(adapter).scanKtp(tempJpg);

      expect(result.isLeft, isTrue);
      expect(result.left, isA<ValidationFailure>());
      expect(result.left.message, 'Dokumen bukan e-KTP');
    });

    test('HTTP 200 success false dipetakan ke ValidationFailure', () async {
      final adapter = _StubAdapter(
        (_) async => _jsonResponse({
          'success': false,
          'message': 'Gambar buram bukan KTP',
        }),
      );
      final result = await buildRepo(adapter).scanKtp(tempJpg);

      expect(result.isLeft, isTrue);
      expect(result.left, isA<ValidationFailure>());
      expect(result.left.message, 'Gambar buram bukan KTP');
    });

    test('HTTP 200 document_type bukan ktp dipetakan ke ValidationFailure', () async {
      final adapter = _StubAdapter(
        (_) async => _jsonResponse({
          'success': true,
          'data': {
            'document_type': 'sim',
            'all_fields': {'nama': 'BUDI'},
          },
        }),
      );
      final result = await buildRepo(adapter).scanKtp(tempJpg);

      expect(result.isLeft, isTrue);
      expect(result.left, isA<ValidationFailure>());
      expect(result.left.message, contains('bukan e-KTP'));
    });

    test('HTTP 200 semua field KTP kosong dipetakan ke ValidationFailure', () async {
      final adapter = _StubAdapter(
        (_) async => _jsonResponse({
          'success': true,
          'data': {'document_type': 'ktp', 'all_fields': {}},
        }),
      );
      final result = await buildRepo(adapter).scanKtp(tempJpg);

      expect(result.isLeft, isTrue);
      expect(result.left, isA<ValidationFailure>());
      expect(result.left.message, contains('tidak dapat terbaca'));
    });

    test('receiveTimeout dipetakan ke NetworkFailure', () async {
      final adapter = _StubAdapter(
        (options) => Future.error(
          DioException(
            requestOptions: options,
            type: DioExceptionType.receiveTimeout,
          ),
        ),
      );
      final result = await buildRepo(adapter).scanKtp(tempJpg);

      expect(result.isLeft, isTrue);
      expect(result.left, isA<NetworkFailure>());
    });

    test('HTTP 500 dipetakan ke ServerFailure', () async {
      final adapter = _StubAdapter(
        (_) async => _jsonResponse(
          {'message': 'Internal Server Error'},
          statusCode: 500,
        ),
      );
      final result = await buildRepo(adapter).scanKtp(tempJpg);

      expect(result.isLeft, isTrue);
      expect(result.left, isA<ServerFailure>());
    });

    test('scanKtp langsung melempar ValidationException saat non-KTP', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _StubAdapter(
          (_) async => _jsonResponse({'success': false, 'message': 'Bukan KTP'}),
        );
      final ds = AuthRemoteDatasourceImpl(dioClient: dio);

      expect(() => ds.scanKtp(tempJpg), throwsA(isA<ValidationException>()));
    });
  });
}
