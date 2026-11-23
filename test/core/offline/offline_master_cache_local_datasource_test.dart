// test/core/offline/offline_master_cache_local_datasource_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';

void main() {
  late Directory tempDir;
  late OfflineMasterCacheLocalDatasource cacheDatasource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('master_cache_test_');
    cacheDatasource = OfflineMasterCacheLocalDatasource(rootDirectory: () async => tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saves and retrieves cached master data payload', () async {
    const key = 'categories_jaga_tanah';
    final sampleData = [
      {'id': 1, 'name': 'Tanah Kas Desa'},
      {'id': 2, 'name': 'Sengketa Batas'},
    ];

    await cacheDatasource.saveCache(key, sampleData);
    final cached = await cacheDatasource.getCache(key);

    expect(cached, isA<List>());
    expect((cached as List).length, equals(2));
    expect(cached.first['name'], equals('Tanah Kas Desa'));
  });

  test('clearAll removes all cached master files', () async {
    await cacheDatasource.saveCache('cache_1', {'data': 123});
    await cacheDatasource.clearAll();

    expect(await cacheDatasource.getCache('cache_1'), isNull);
  });
}
