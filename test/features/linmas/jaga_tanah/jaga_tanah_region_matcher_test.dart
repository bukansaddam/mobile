import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/data/datasources/jaga_tanah_remote_datasource.dart';
import 'package:akar/features/linmas/jaga_tanah/data/repositories/jaga_tanah_repository_impl.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_region_matcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDioAdapter implements HttpClientAdapter {
  _FakeDioAdapter(this.onFetch);

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => onFetch(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonBody(Object payload, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(payload),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  group('JagaTanahRegionMatcher.filterByQuery', () {
    const items = [
      JagaTanahRegionEntity(id: '1', name: 'KOTA MOJOKERTO'),
      JagaTanahRegionEntity(id: '2', name: 'KABUPATEN MOJOKERTO'),
      JagaTanahRegionEntity(id: '3', name: 'KABUPATEN MALANG'),
      JagaTanahRegionEntity(id: '4', name: 'MOJOKERTO BARAT'),
    ];

    test('returns original list when query is empty or whitespace', () {
      expect(JagaTanahRegionMatcher.filterByQuery(items, ''), same(items));
      expect(JagaTanahRegionMatcher.filterByQuery(items, '   '), same(items));
    });

    test('matches case-insensitively and prioritizes prefix matches', () {
      final result = JagaTanahRegionMatcher.filterByQuery(items, 'mojokerto');
      expect(result.map((e) => e.id).toList(), ['4', '1', '2']);
    });

    test('supports multi-token query such as "kab moj"', () {
      final result = JagaTanahRegionMatcher.filterByQuery(items, 'kab moj');
      expect(result.map((e) => e.id).toList(), ['2']);
    });

    test('returns empty list when no candidate matches', () {
      expect(JagaTanahRegionMatcher.filterByQuery(items, 'bandung'), isEmpty);
    });
  });

  group('JagaTanahRegionMatcher.findBestMatch', () {
    const provinces = [
      JagaTanahRegionEntity(id: '11', name: 'ACEH'),
      JagaTanahRegionEntity(id: '14', name: 'RIAU'),
      JagaTanahRegionEntity(id: '21', name: 'KEPULAUAN RIAU'),
      JagaTanahRegionEntity(id: '31', name: 'DKI JAKARTA'),
      JagaTanahRegionEntity(id: '34', name: 'DI YOGYAKARTA'),
      JagaTanahRegionEntity(id: '35', name: 'JAWA TIMUR'),
      JagaTanahRegionEntity(id: '19', name: 'KEPULAUAN BANGKA BELITUNG'),
    ];

    test('resolves province aliases and prefixes accurately', () {
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          provinces,
          'Daerah Khusus Ibukota Jakarta',
          level: JagaTanahRegionLevel.province,
        )?.id,
        '31',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          provinces,
          'Yogyakarta',
          level: JagaTanahRegionLevel.province,
        )?.id,
        '34',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          provinces,
          'Provinsi Jawa Timur',
          level: JagaTanahRegionLevel.province,
        )?.id,
        '35',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          provinces,
          'Kep. Riau',
          level: JagaTanahRegionLevel.province,
        )?.id,
        '21',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          provinces,
          'Riau',
          level: JagaTanahRegionLevel.province,
        )?.id,
        '14',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          provinces,
          'Nanggroe Aceh Darussalam',
          level: JagaTanahRegionLevel.province,
        )?.id,
        '11',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          provinces,
          'Bangka Belitung',
          level: JagaTanahRegionLevel.province,
        )?.id,
        '19',
      );
    });

    test('enforces strict Kab vs Kota distinction for regency', () {
      const regencies = [
        JagaTanahRegionEntity(id: '3516', name: 'KABUPATEN MOJOKERTO'),
        JagaTanahRegionEntity(id: '3576', name: 'KOTA MOJOKERTO'),
        JagaTanahRegionEntity(id: '3507', name: 'KABUPATEN MALANG'),
        JagaTanahRegionEntity(id: '3573', name: 'KOTA MALANG'),
        JagaTanahRegionEntity(id: '3174', name: 'KOTA ADM. JAKARTA SELATAN'),
      ];

      expect(
        JagaTanahRegionMatcher.findBestMatch(
          regencies,
          'Kab. Mojokerto',
          level: JagaTanahRegionLevel.regency,
        )?.id,
        '3516',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          regencies,
          'Kota Malang',
          level: JagaTanahRegionLevel.regency,
        )?.id,
        '3573',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          regencies,
          'Kota Administrasi Jakarta Selatan',
          level: JagaTanahRegionLevel.regency,
        )?.id,
        '3174',
      );
      // Unqualified base prefers Kabupaten when both exist
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          regencies,
          'Malang',
          level: JagaTanahRegionLevel.regency,
        )?.id,
        '3507',
      );

      // Kota Malang must NEVER match KABUPATEN MALANG when only Kabupaten exists
      const onlyKabMalang = [
        JagaTanahRegionEntity(id: '3507', name: 'KABUPATEN MALANG'),
      ];
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          onlyKabMalang,
          'Kota Malang',
          level: JagaTanahRegionLevel.regency,
        ),
        isNull,
      );
    });

    test('matches district and village names after stripping prefixes', () {
      const districts = [
        JagaTanahRegionEntity(id: '351608', name: 'NGORO'),
        JagaTanahRegionEntity(id: '351609', name: 'PUNGGING'),
      ];
      const villages = [
        JagaTanahRegionEntity(id: '3516082001', name: 'SUKOMULYO'),
        JagaTanahRegionEntity(id: '3516082002', name: 'BANDARASRI'),
      ];

      expect(
        JagaTanahRegionMatcher.findBestMatch(
          districts,
          'Kec. Ngoro',
          level: JagaTanahRegionLevel.district,
        )?.id,
        '351608',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          districts,
          'Kecamatan Ngoro',
          level: JagaTanahRegionLevel.district,
        )?.id,
        '351608',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          villages,
          'Desa Sukomulyo',
          level: JagaTanahRegionLevel.village,
        )?.id,
        '3516082001',
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          villages,
          'Kelurahan Sukomulyo',
          level: JagaTanahRegionLevel.village,
        )?.id,
        '3516082001',
      );
    });

    test('returns null for unmatched, empty, or partial substring inputs', () {
      const regencies = [
        JagaTanahRegionEntity(id: '3507', name: 'KABUPATEN MALANG'),
      ];
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          regencies,
          'Mal',
          level: JagaTanahRegionLevel.regency,
        ),
        isNull,
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          regencies,
          'Tidak Ada',
          level: JagaTanahRegionLevel.regency,
        ),
        isNull,
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          regencies,
          null,
          level: JagaTanahRegionLevel.regency,
        ),
        isNull,
      );
      expect(
        JagaTanahRegionMatcher.findBestMatch(
          const [],
          'Malang',
          level: JagaTanahRegionLevel.regency,
        ),
        isNull,
      );
    });
  });

  group('JagaTanahRemoteDatasourceImpl regions', () {
    test('parseRegionList handles envelope, direct list, nested map, and skips invalid items', () {
      final fromEnvelope = JagaTanahRemoteDatasourceImpl.parseRegionList({
        'success': true,
        'data': [
          {'id': 35, 'name': 'JAWA TIMUR', 'code': '35'},
          {'id': '31', 'name': 'DKI JAKARTA'},
          {'id': '', 'name': 'EMPTY ID'},
          {'id': 99, 'name': ''},
          'invalid',
        ],
      });
      expect(fromEnvelope, const [
        JagaTanahRegionEntity(id: '35', name: 'JAWA TIMUR', code: '35'),
        JagaTanahRegionEntity(id: '31', name: 'DKI JAKARTA'),
      ]);

      final fromDirectList = JagaTanahRemoteDatasourceImpl.parseRegionList([
        {'code': '3516', 'label': 'KABUPATEN MOJOKERTO'},
      ]);
      expect(fromDirectList, const [
        JagaTanahRegionEntity(
          id: '3516',
          name: 'KABUPATEN MOJOKERTO',
          code: '3516',
        ),
      ]);

      final fromNestedVillages = JagaTanahRemoteDatasourceImpl.parseRegionList({
        'success': true,
        'data': {
          'villages': [
            {'id': '3516082001', 'nama': 'SUKOMULYO', 'code': ''},
          ],
        },
      });
      expect(fromNestedVillages, const [
        JagaTanahRegionEntity(id: '3516082001', name: 'SUKOMULYO'),
      ]);

      final multiLevelPayload = {
        'success': true,
        'data': {
          'provinces': [
            {'id': 35, 'name': 'JAWA TIMUR'},
          ],
          'regencies': [
            {'id': 3516, 'name': 'KABUPATEN MOJOKERTO'},
          ],
          'districts': [
            {'id': 351608, 'name': 'NGORO'},
          ],
        },
      };
      expect(
        JagaTanahRemoteDatasourceImpl.parseRegionList(
          multiLevelPayload,
          preferredKeys: const ['regencies'],
        ),
        const [JagaTanahRegionEntity(id: '3516', name: 'KABUPATEN MOJOKERTO')],
      );
      expect(
        JagaTanahRemoteDatasourceImpl.parseRegionList(
          multiLevelPayload,
          preferredKeys: const ['districts'],
        ),
        const [JagaTanahRegionEntity(id: '351608', name: 'NGORO')],
      );

      final rootLevelPayload = {
        'provinces': const [],
        'regencies': [
          {'id': 3576, 'name': 'KOTA MOJOKERTO'},
        ],
      };
      expect(
        JagaTanahRemoteDatasourceImpl.parseRegionList(
          rootLevelPayload,
          preferredKeys: const ['regencies'],
        ),
        const [JagaTanahRegionEntity(id: '3576', name: 'KOTA MOJOKERTO')],
      );
    });

    test('sends exact endpoint paths, query params, and respects in-memory cache + forceRefresh', () async {
      final capturedRequests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((options) async {
          capturedRequests.add(options);
          if (options.path == ApiConstants.baselineRegionVillages) {
            return _jsonBody({
              'success': true,
              'data': [
                {'id': '3516082001', 'name': 'SUKOMULYO'},
              ],
            });
          }
          if (options.queryParameters.containsKey('regency_id')) {
            return _jsonBody({
              'success': true,
              'data': [
                {'id': '351608', 'name': 'NGORO'},
              ],
            });
          }
          if (options.queryParameters.containsKey('province_id')) {
            return _jsonBody({
              'success': true,
              'data': [
                {'id': '3516', 'name': 'KABUPATEN MOJOKERTO'},
              ],
            });
          }
          return _jsonBody({
            'success': true,
            'data': [
              {'id': '35', 'name': 'JAWA TIMUR'},
            ],
          });
        });

      final datasource = JagaTanahRemoteDatasourceImpl(dio: dio);

      // Provinces: first call fetches, second hits cache, forceRefresh re-fetches
      final p1 = await datasource.getProvinces();
      final p2 = await datasource.getProvinces();
      final p3 = await datasource.getProvinces(forceRefresh: true);
      expect(p1, hasLength(1));
      expect(p2, same(p1));
      expect(p3, hasLength(1));

      // Regencies
      final r1 = await datasource.getRegencies(' 35 ');
      final r2 = await datasource.getRegencies('35');
      expect(r1.single.id, '3516');
      expect(r2, same(r1));

      // Districts
      final d1 = await datasource.getDistricts('3516');
      final d2 = await datasource.getDistricts('3516', forceRefresh: true);
      expect(d1.single.id, '351608');
      expect(d2.single.id, '351608');

      // Villages
      final v1 = await datasource.getVillages('351608');
      final v2 = await datasource.getVillages('351608');
      expect(v1.single.id, '3516082001');
      expect(v2, same(v1));

      // Expected total network calls: 2 provinces + 1 regency + 2 districts + 1 village = 6
      expect(capturedRequests, hasLength(6));
      expect(capturedRequests[0].path, ApiConstants.baselineRegions);
      expect(capturedRequests[0].queryParameters, isEmpty);
      expect(capturedRequests[1].path, ApiConstants.baselineRegions);
      expect(capturedRequests[2].path, ApiConstants.baselineRegions);
      expect(capturedRequests[2].queryParameters, {'province_id': '35'});
      expect(capturedRequests[3].path, ApiConstants.baselineRegions);
      expect(capturedRequests[3].queryParameters, {'regency_id': '3516'});
      expect(capturedRequests[4].path, ApiConstants.baselineRegions);
      expect(capturedRequests[4].queryParameters, {'regency_id': '3516'});
      expect(capturedRequests[5].path, ApiConstants.baselineRegionVillages);
      expect(capturedRequests[5].queryParameters, {'district_id': '351608'});
    });

    test('getProvinces saves to SWR disk cache and falls back offline on DioException', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'baseline_provinces_cache_',
      );
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      var isOffline = false;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((options) async {
          if (isOffline) {
            throw DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: const SocketException('No network'),
            );
          }
          return _jsonBody({
            'success': true,
            'data': [
              {'id': '35', 'name': 'JAWA TIMUR'},
              {'id': '31', 'name': 'DKI JAKARTA'},
            ],
          });
        });

      final masterCache = OfflineMasterCacheLocalDatasource(
        rootDirectory: () async => tempDir,
        dio: dio,
      );

      final onlineDs = JagaTanahRemoteDatasourceImpl(
        dio: dio,
        masterCache: masterCache,
      );
      final onlineResult = await onlineDs.getProvinces();
      expect(onlineResult, hasLength(2));

      // Simulate cold start while offline using a fresh datasource instance
      isOffline = true;
      final offlineDs = JagaTanahRemoteDatasourceImpl(
        dio: dio,
        masterCache: masterCache,
      );
      final offlineResult = await offlineDs.getProvinces();
      expect(offlineResult.map((e) => e.id).toList(), ['35', '31']);
    });

    test('whitespace parentId returns empty list with zero network calls', () async {
      var calls = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((_) async {
          calls++;
          return _jsonBody({'success': true, 'data': []});
        });

      final datasource = JagaTanahRemoteDatasourceImpl(dio: dio);
      expect(await datasource.getRegencies('   '), isEmpty);
      expect(calls, 0);
    });

    test('empty 200 province response does not clobber existing disk cache', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'baseline_provinces_no_clobber_',
      );
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      var mode = 'populated';
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((options) async {
          if (mode == 'populated') {
            return _jsonBody({
              'success': true,
              'data': [
                {'id': '35', 'name': 'JAWA TIMUR'},
              ],
            });
          }
          if (mode == 'empty') {
            return _jsonBody({'success': true, 'data': []});
          }
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: const SocketException('Offline'),
          );
        });

      final masterCache = OfflineMasterCacheLocalDatasource(
        rootDirectory: () async => tempDir,
        dio: dio,
      );
      final ds = JagaTanahRemoteDatasourceImpl(
        dio: dio,
        masterCache: masterCache,
      );

      expect(await ds.getProvinces(), hasLength(1));

      // Force refresh returns empty 200 payload, must not overwrite disk cache
      mode = 'empty';
      expect(await ds.getProvinces(forceRefresh: true), isEmpty);

      // Fresh instance offline still recovers previous non-empty disk cache
      mode = 'offline';
      final freshDs = JagaTanahRemoteDatasourceImpl(
        dio: dio,
        masterCache: masterCache,
      );
      final recovered = await freshDs.getProvinces();
      expect(recovered.map((e) => e.id).toList(), ['35']);
    });

    test('JagaTanahRepositoryImpl maps offline DioException to NetworkFailure', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _FakeDioAdapter((options) async {
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: const SocketException('No network'),
          );
        });

      final repo = JagaTanahRepositoryImpl(
        remoteDatasource: JagaTanahRemoteDatasourceImpl(dio: dio),
      );

      final provinceRes = await repo.getProvinces();
      expect(provinceRes.isLeft, isTrue);
      provinceRes.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left(NetworkFailure)'),
      );

      final regencyRes = await repo.getRegencies('35');
      expect(regencyRes.isLeft, isTrue);
      regencyRes.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left(NetworkFailure)'),
      );
    });
  });
}
