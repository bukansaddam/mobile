import 'dart:convert';
import 'dart:io';

import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/features/linmas/bank_sampah/data/datasources/bank_sampah_remote_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/data/datasources/jaga_tanah_remote_datasource.dart';
import 'package:akar/features/masyarakat/complaint/data/datasources/complaint_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _ToggleDioAdapter implements HttpClientAdapter {
  bool shouldFail = false;
  dynamic responsePayload;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (shouldFail) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'Offline',
      );
    }
    return ResponseBody.fromString(
      jsonEncode(responsePayload),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Directory tempDir;
  late OfflineMasterCacheLocalDatasource masterCache;
  late _ToggleDioAdapter adapter;
  late Dio dio;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('swr_cache_fallback_test_');
    masterCache = OfflineMasterCacheLocalDatasource(
      rootDirectory: () async => tempDir,
    );
    adapter = _ToggleDioAdapter();
    dio = Dio()..httpClientAdapter = adapter;
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'JagaTanahRemoteDatasourceImpl caches categories and falls back offline',
    () async {
      adapter.responsePayload = {
        'data': [
          {
            'id': 1,
            'label': 'Tanah Sengketa',
            'code': 'tanah_sengketa',
            'children': [],
          },
        ],
      };

      final ds = JagaTanahRemoteDatasourceImpl(
        masterCache: masterCache,
        dio: dio,
      );

      final online = await ds.getCategories();
      expect(online.length, equals(1));
      expect(online.first.label, equals('Tanah Sengketa'));

      adapter.shouldFail = true;
      final offline = await ds.getCategories();
      expect(offline.length, equals(1));
      expect(offline.first.label, equals('Tanah Sengketa'));
    },
  );

  test('ComplaintRemoteDatasourceImpl caches incident categories and falls back offline', () async {
    adapter.responsePayload = {
      'data': [
        {'id': 10, 'code': 'banjir', 'label': 'Banjir', 'is_active': true},
      ],
    };

    final ds = ComplaintRemoteDatasourceImpl(
      masterCache: masterCache,
      dio: dio,
    );

    final online = await ds.getIncidentCategories();
    expect(online.length, equals(1));
    expect(online.first.label, equals('Banjir'));

    adapter.shouldFail = true;
    final offline = await ds.getIncidentCategories();
    expect(offline.length, equals(1));
    expect(offline.first.label, equals('Banjir'));
  });

  test('BankSampahRemoteDataSourceImpl caches bank map locations and falls back offline', () async {
    adapter.responsePayload = {
      'data': {
        'points': [
          {
            'id': 77,
            'name': 'BS Sejahtera',
            'address': 'Jl. Melati No. 5',
            'latitude': -7.25,
            'longitude': 112.75,
          },
        ],
      },
    };

    final ds = BankSampahRemoteDataSourceImpl(
      masterCache: masterCache,
      dio: dio,
    );

    final online = await ds.getBankSampahMap();
    expect(online.length, equals(1));
    expect(online.first.nama, equals('BS Sejahtera'));

    adapter.shouldFail = true;
    final offline = await ds.getBankSampahMap();
    expect(offline.length, equals(1));
    expect(offline.first.nama, equals('BS Sejahtera'));
  });
}
