import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHandler implements OfflineSyncHandler {
  final List<String> syncedIds = [];
  Completer<void>? syncCompleter;
  Failure? failureToThrow;

  @override
  bool canHandle(OfflineFeatureType type) => true;

  @override
  Future<void> sync(OfflineQueueItem item) async {
    if (syncCompleter != null) await syncCompleter!.future;
    if (failureToThrow != null) throw failureToThrow!;
    syncedIds.add(item.id);
  }
}

void main() {
  late Directory tempDir;
  late OfflineQueueLocalDatasource queueDatasource;
  late OfflineSyncCoordinator coordinator;
  late _FakeHandler fakeHandler;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sync_coord_test_');
    queueDatasource =
        OfflineQueueLocalDatasource(rootDirectory: () async => tempDir);
    fakeHandler = _FakeHandler();
    coordinator = OfflineSyncCoordinator(
      queueDatasource: queueDatasource,
      currentUserIdResolver: () => 'user-1',
      connectivityChecker: () async => [ConnectivityResult.wifi],
    );
    coordinator.registerHandler(fakeHandler);
  });

  tearDown(() async {
    coordinator.dispose();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('single-flight lock prevents parallel overlapping syncNow executions',
      () async {
    fakeHandler.syncCompleter = Completer<void>();

    await queueDatasource.enqueue(
      userId: 'user-1',
      featureType: OfflineFeatureType.jagaTanah,
      payload: {'title': 'Report 1'},
    );

    // Trigger syncNow twice in parallel
    final sync1 = coordinator.syncNow();
    final sync2 = coordinator.syncNow();

    expect(coordinator.isSyncing, isTrue);

    fakeHandler.syncCompleter!.complete();
    await Future.wait([sync1, sync2]);

    expect(fakeHandler.syncedIds.length, equals(1));
    expect(coordinator.isSyncing, isFalse);
  });

  test('prioritizes lightweight items before large videos', () async {
    // Enqueue 1 item with video
    final dummyVideo = File('${tempDir.path}/large_video.mp4')..writeAsStringSync('video data');
    final videoItem = await queueDatasource.enqueue(
      userId: 'user-1',
      featureType: OfflineFeatureType.jagaTanah,
      payload: {'title': 'Video Report'},
      attachments: [dummyVideo],
    );
    await queueDatasource.updateItem(
      videoItem.copyWith(
        requiresCellularConsent: true,
      ),
    );

    // Enqueue 1 lightweight item
    final lightItem = await queueDatasource.enqueue(
      userId: 'user-1',
      featureType: OfflineFeatureType.complaint,
      payload: {'title': 'Lightweight Report'},
    );

    await coordinator.syncNow();

    expect(fakeHandler.syncedIds.length, equals(2));
    expect(fakeHandler.syncedIds.first, equals(lightItem.id));
    expect(fakeHandler.syncedIds.last, equals(videoItem.id));
  });

  test('marks item failedPermanent on 400/422 validation failure', () async {
    fakeHandler.failureToThrow =
        const ValidationFailure('Validation error', statusCode: 422);

    final item = await queueDatasource.enqueue(
      userId: 'user-1',
      featureType: OfflineFeatureType.jagaTanah,
      payload: {'title': 'Invalid Report'},
    );

    await coordinator.syncNow();

    final pending = await queueDatasource.getPending('user-1');
    expect(pending.first.status, equals(OfflineItemStatus.failedPermanent));
  });

  test('schedules retry with backoff on 409 conflict', () async {
    fakeHandler.failureToThrow =
        const ServerFailure('Conflict / in-flight', statusCode: 409);

    final item = await queueDatasource.enqueue(
      userId: 'user-1',
      featureType: OfflineFeatureType.jagaTanah,
      payload: {'title': 'Conflict Report'},
    );

    await coordinator.syncNow();

    final pending = await queueDatasource.getPending('user-1');
    expect(pending.first.status, equals(OfflineItemStatus.failedRetryable));
    expect(pending.first.retryCount, equals(1));
    expect(pending.first.nextRetryAt, isNotNull);
  });
}
