// test/core/offline/offline_queue_local_datasource_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/offline/offline_queue_item.dart';

void main() {
  late Directory tempDir;
  late OfflineQueueLocalDatasource datasource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('offline_queue_test_');
    datasource = OfflineQueueLocalDatasource(rootDirectory: () async => tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('enqueues item atomically and retrieves by userId', () async {
    final sampleFile = File('${tempDir.path}/sample.jpg')..writeAsStringSync('dummy');

    final item = await datasource.enqueue(
      userId: 'user-01',
      featureType: OfflineFeatureType.jagaTanah,
      payload: {'title': 'Test Report'},
      attachments: [sampleFile],
    );

    expect(item.id, isNotEmpty);
    expect(item.userId, equals('user-01'));

    final user1Pending = await datasource.getPending('user-01');
    expect(user1Pending.length, equals(1));

    final user2Pending = await datasource.getPending('user-02');
    expect(user2Pending, isEmpty);
  });

  test('rejects enqueue when item count exceeds quota limit of 50', () async {
    final sample = File('${tempDir.path}/sample.jpg')..writeAsStringSync('dummy');
    for (var i = 0; i < 50; i++) {
      await datasource.enqueue(
        userId: 'user-01',
        featureType: OfflineFeatureType.ronda,
        payload: {'index': i},
        attachments: [],
      );
    }

    expect(
      () => datasource.enqueue(
        userId: 'user-01',
        featureType: OfflineFeatureType.ronda,
        payload: {'index': 51},
        attachments: [],
      ),
      throwsA(isA<OfflineQueueQuotaException>()),
    );
  });

  test('clearForUser only removes reports belonging to specified user', () async {
    await datasource.enqueue(userId: 'user-A', featureType: OfflineFeatureType.ronda, payload: {});
    await datasource.enqueue(userId: 'user-B', featureType: OfflineFeatureType.ronda, payload: {});

    await datasource.clearForUser('user-A');

    expect(await datasource.getPending('user-A'), isEmpty);
    expect((await datasource.getPending('user-B')).length, equals(1));
  });
}
