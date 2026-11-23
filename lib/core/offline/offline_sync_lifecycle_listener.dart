import 'dart:async';

import 'package:akar/core/di/injection_container.dart' as di;
import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineSyncLifecycleListener extends StatefulWidget {
  final Widget child;
  final OfflineSyncCoordinator? coordinator;
  final OfflineMasterCacheLocalDatasource? masterCache;
  final Stream<List<ConnectivityResult>>? connectivityStream;

  const OfflineSyncLifecycleListener({
    super.key,
    required this.child,
    this.coordinator,
    this.masterCache,
    this.connectivityStream,
  });

  @override
  State<OfflineSyncLifecycleListener> createState() =>
      _OfflineSyncLifecycleListenerState();
}

class _OfflineSyncLifecycleListenerState
    extends State<OfflineSyncLifecycleListener>
    with WidgetsBindingObserver {
  OfflineSyncCoordinator? get _coordinator {
    if (widget.coordinator != null) return widget.coordinator;
    if (di.sl.isRegistered<OfflineSyncCoordinator>()) {
      return di.sl<OfflineSyncCoordinator>();
    }
    return null;
  }

  OfflineMasterCacheLocalDatasource? get _masterCache {
    if (widget.masterCache != null) return widget.masterCache;
    if (di.sl.isRegistered<OfflineMasterCacheLocalDatasource>()) {
      return di.sl<OfflineMasterCacheLocalDatasource>();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _coordinator?.startListening(
      widget.connectivityStream ?? Connectivity().onConnectivityChanged,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncIfAuthenticated();
    });
  }

  void _syncIfAuthenticated() {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        _triggerSyncAndWarmup();
      }
    } catch (_) {}
  }

  void _triggerSyncAndWarmup() {
    final coord = _coordinator;
    if (coord != null) {
      unawaited(coord.syncNow());
    }
    final cache = _masterCache;
    if (cache != null) {
      unawaited(cache.warmUpEssentialMasterData());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncIfAuthenticated();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous is! AuthAuthenticated && current is AuthAuthenticated,
      listener: (context, state) {
        _triggerSyncAndWarmup();
      },
      child: widget.child,
    );
  }
}
