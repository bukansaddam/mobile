import 'dart:async';

import 'package:akar/core/di/injection_container.dart' as di;
import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Menyinkronkan badge notifikasi saat sesi autentikasi berubah, pesan push
/// masuk di foreground, atau aplikasi kembali ke latar depan.
class NotificationLifecycleListener extends StatefulWidget {
  final Widget child;
  final Stream<RemoteMessage>? foregroundMessages;

  const NotificationLifecycleListener({
    super.key,
    required this.child,
    this.foregroundMessages,
  });

  @override
  State<NotificationLifecycleListener> createState() =>
      _NotificationLifecycleListenerState();
}

class _NotificationLifecycleListenerState
    extends State<NotificationLifecycleListener>
    with WidgetsBindingObserver {
  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscribeForegroundMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncIfAuthenticated();
    });
  }

  void _subscribeForegroundMessages() {
    Stream<RemoteMessage>? stream = widget.foregroundMessages;
    if (stream == null && di.sl.isRegistered<FirebaseNotificationService>()) {
      stream = di.sl<FirebaseNotificationService>().onForegroundMessage;
    }
    _foregroundSubscription = stream?.listen((_) {
      if (mounted) _syncIfAuthenticated();
    });
  }

  void _syncIfAuthenticated() {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<NotificationBloc>().add(
          const FetchNotificationCountEvent(),
        );
        _syncDeviceId();
      }
    } catch (_) {}
  }

  void _syncDeviceId() {
    if (di.sl.isRegistered<FirebaseNotificationService>()) {
      unawaited(di.sl<FirebaseNotificationService>().ensureTokenCached());
    }
  }

  void _resetDeviceIdSync() {
    if (di.sl.isRegistered<FirebaseNotificationService>()) {
      di.sl<FirebaseNotificationService>().resetSyncedDeviceState();
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
    _foregroundSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          (previous is! AuthAuthenticated && current is AuthAuthenticated) ||
          (previous is! AuthUnauthenticated && current is AuthUnauthenticated),
      listener: (context, state) {
        final bloc = context.read<NotificationBloc>();
        if (state is AuthAuthenticated) {
          bloc.add(const FetchNotificationCountEvent());
          _syncDeviceId();
        } else if (state is AuthUnauthenticated) {
          bloc.add(const ResetNotificationsEvent());
          _resetDeviceIdSync();
        }
      },
      child: widget.child,
    );
  }
}
