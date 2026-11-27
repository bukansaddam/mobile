import 'dart:async';
import 'dart:io';

import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/core/offline/offline_sync_lifecycle_listener.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthBloc extends Fake implements AuthBloc {
  final StreamController<AuthState> _controller =
      StreamController<AuthState>.broadcast();
  AuthState _state = const AuthUnauthenticated();

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => _controller.stream;

  void emitState(AuthState next) {
    _state = next;
    _controller.add(next);
  }

  @override
  Future<void> close() => _controller.close();
}

class _FakeCoordinator extends Fake implements OfflineSyncCoordinator {
  int syncNowCalls = 0;
  Stream<List<ConnectivityResult>>? startedStream;
  final ValueNotifier<bool> _syncing = ValueNotifier<bool>(false);

  @override
  ValueNotifier<bool> get isSyncingNotifier => _syncing;

  @override
  void startListening(Stream<List<ConnectivityResult>> stream) {
    startedStream = stream;
  }

  @override
  Future<void> syncNow({bool includeCellularLargeVideos = false}) async {
    syncNowCalls++;
  }
}

class _FakeMasterCache extends Fake
    implements OfflineMasterCacheLocalDatasource {
  int warmUpCalls = 0;

  @override
  Future<void> warmUpEssentialMasterData() async {
    warmUpCalls++;
  }
}

class _SlowSyncHandler implements OfflineSyncHandler {
  final Completer<void> completer = Completer<void>();

  @override
  bool canHandle(OfflineFeatureType type) => true;

  @override
  Future<void> sync(OfflineQueueItem item) => completer.future;
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('lifecycle_sync_test_');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Reactive offline notifiers', () {
    test(
      'OfflineQueueLocalDatasource.revision increments on queue mutations',
      () async {
        final queue = OfflineQueueLocalDatasource(
          rootDirectory: () async => tempDir,
        );
        var changes = 0;
        queue.revision.addListener(() => changes++);

        final item = await queue.enqueue(
          userId: 'user-1',
          featureType: OfflineFeatureType.ronda,
          payload: {'keterangan': 'test'},
        );
        expect(queue.revision.value, equals(1));

        await queue.updateItem(item.copyWith(retryCount: 1));
        expect(queue.revision.value, equals(2));

        await queue.remove(item.id);
        expect(queue.revision.value, equals(3));

        await queue.enqueue(
          userId: 'user-1',
          featureType: OfflineFeatureType.ronda,
          payload: {'keterangan': 'test2'},
        );
        await queue.clearForUser('user-1');
        expect(changes, greaterThanOrEqualTo(5));
      },
    );

    test(
      'OfflineSyncCoordinator.isSyncingNotifier tracks active sync state',
      () async {
        final queue = OfflineQueueLocalDatasource(
          rootDirectory: () async => tempDir,
        );
        await queue.enqueue(
          userId: 'user-1',
          featureType: OfflineFeatureType.ronda,
          payload: {'keterangan': 'test'},
        );

        final coordinator = OfflineSyncCoordinator(
          queueDatasource: queue,
          currentUserIdResolver: () => 'user-1',
          connectivityChecker: () async => [ConnectivityResult.wifi],
        );
        final slowHandler = _SlowSyncHandler();
        coordinator.registerHandler(slowHandler);

        final states = <bool>[];
        coordinator.isSyncingNotifier.addListener(() {
          states.add(coordinator.isSyncingNotifier.value);
        });

        final syncFuture = coordinator.syncNow();
        await pumpEventQueue();
        expect(coordinator.isSyncingNotifier.value, isTrue);

        slowHandler.completer.complete();
        await syncFuture;

        expect(coordinator.isSyncingNotifier.value, isFalse);
        expect(states, equals([true, false]));
      },
    );
  });

  group('OfflineSyncLifecycleListener', () {
    testWidgets('starts listening, triggers sync + warmup on auth & resume', (
      tester,
    ) async {
      final mockAuthBloc = _FakeAuthBloc();

      final coordinator = _FakeCoordinator();
      final masterCache = _FakeMasterCache();
      final connectivityController =
          StreamController<List<ConnectivityResult>>.broadcast();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: OfflineSyncLifecycleListener(
              coordinator: coordinator,
              masterCache: masterCache,
              connectivityStream: connectivityController.stream,
              child: const SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(coordinator.startedStream, isNotNull);
      expect(coordinator.syncNowCalls, equals(0));
      expect(masterCache.warmUpCalls, equals(0));

      // Transition to AuthAuthenticated triggers sync + warmup
      const authState = AuthAuthenticated(
        user: UserEntity(id: 99, name: 'Petugas'),
        token: 'token-abc',
      );
      mockAuthBloc.emitState(authState);
      await tester.pump();

      expect(coordinator.syncNowCalls, equals(1));
      expect(masterCache.warmUpCalls, equals(1));

      // App resume when authenticated triggers sync + warmup again
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();

      expect(coordinator.syncNowCalls, equals(2));
      expect(masterCache.warmUpCalls, equals(2));

      await mockAuthBloc.close();
      await connectivityController.close();
    });
  });
}
