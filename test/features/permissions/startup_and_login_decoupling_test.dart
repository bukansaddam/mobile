import 'dart:async';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/pages/login_screen.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:akar/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _ConfigurablePermissionGateway implements PermissionGateway {
  final Map<AppPermissionType, PermissionStepStatus> checkStatuses = {};

  @override
  Future<PermissionStepStatus> checkStatus(AppPermissionType type) async {
    return checkStatuses[type] ?? PermissionStepStatus.denied;
  }

  @override
  Future<PermissionStepStatus> request(AppPermissionType type) async {
    return checkStatuses[type] ?? PermissionStepStatus.denied;
  }

  @override
  Future<bool> openSettings() async => true;
}

class _ControllableAuthBloc extends Fake implements AuthBloc {
  _ControllableAuthBloc(this._state);

  AuthState _state;
  final _controller = StreamController<AuthState>.broadcast();
  final List<AuthEvent> events = [];

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => _controller.stream;

  @override
  bool get isClosed => _controller.isClosed;

  void emitState(AuthState nextState) {
    _state = nextState;
    _controller.add(nextState);
  }

  @override
  void add(AuthEvent event) {
    events.add(event);
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class _RecordingTrackingBloc extends Fake implements TrackingBloc {
  final TrackingState _state = const TrackingState();
  final _controller = StreamController<TrackingState>.broadcast();
  final List<TrackingEvent> events = [];

  @override
  TrackingState get state => _state;

  @override
  Stream<TrackingState> get stream => _controller.stream;

  @override
  bool get isClosed => _controller.isClosed;

  @override
  void add(TrackingEvent event) {
    events.add(event);
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

const _linmasUser = UserEntity(
  id: 1,
  name: 'Petugas Linmas',
  username: 'officer',
  role: 'linmas',
  isInitialQuizCompleted: true,
);

const _masyarakatUser = UserEntity(
  id: 2,
  name: 'Warga Masyarakat',
  username: 'member',
  role: 'masyarakat',
);

const _geolocatorChannels = [
  MethodChannel('flutter.baseflow.com/geolocator'),
  MethodChannel('flutter.baseflow.com/geolocator_android'),
  MethodChannel('flutter.baseflow.com/geolocator_apple'),
];

void main() {
  late _ConfigurablePermissionGateway gateway;
  late AppPermissionService permissionService;
  late _ControllableAuthBloc authBloc;
  late _RecordingTrackingBloc trackingBloc;
  late List<String> geolocatorCalls;

  setUp(() async {
    if (sl.isRegistered<AppPermissionService>()) {
      sl.unregister<AppPermissionService>();
    }
    gateway = _ConfigurablePermissionGateway();
    permissionService = AppPermissionService(gateway: gateway);
    sl.registerSingleton<AppPermissionService>(permissionService);

    trackingBloc = _RecordingTrackingBloc();
    geolocatorCalls = [];

    for (final channel in _geolocatorChannels) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            geolocatorCalls.add('${channel.name}:${call.method}');
            switch (call.method) {
              case 'isLocationServiceEnabled':
                return true;
              case 'checkPermission':
              case 'requestPermission':
                return 0; // LocationPermission.denied
              default:
                return null;
            }
          });
    }
  });

  tearDown(() async {
    for (final channel in _geolocatorChannels) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    }
    if (sl.isRegistered<AppPermissionService>()) {
      sl.unregister<AppPermissionService>();
    }
    await authBloc.close();
    await trackingBloc.close();
  });

  GoRouter buildTestRouter({required String initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRouter.splashPath,
          name: AppRouter.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRouter.loginPath,
          name: AppRouter.login,
          builder: (context, state) =>
              LoginScreen(role: state.uri.queryParameters['role']),
        ),
        GoRoute(
          path: AppRouter.permissionSetupPath,
          name: AppRouter.permissionSetup,
          builder: (context, state) =>
              const Scaffold(body: Text('Permission Setup Destination')),
        ),
        GoRoute(
          path: AppRouter.mainPath,
          name: AppRouter.main,
          builder: (context, state) =>
              const Scaffold(body: Text('Main Destination')),
        ),
        GoRoute(
          path: AppRouter.initialSurveyPath,
          name: AppRouter.initialSurvey,
          builder: (context, state) =>
              const Scaffold(body: Text('Initial Survey Destination')),
        ),
        GoRoute(
          path: AppRouter.masyarakatMainPath,
          name: AppRouter.masyarakatMain,
          builder: (context, state) =>
              const Scaffold(body: Text('Masyarakat Main Destination')),
        ),
        GoRoute(
          path: AppRouter.welcomePath,
          name: AppRouter.welcome,
          builder: (context, state) =>
              const Scaffold(body: Text('Welcome Destination')),
        ),
      ],
    );
  }

  Widget wrapRouter(GoRouter router) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<TrackingBloc>.value(value: trackingBloc),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }

  group('SplashScreen permission gating', () {
    testWidgets(
      'Linmas missing permissions navigates to permissionSetup without StartTrackingEvent',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 780));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await permissionService.refreshStatuses(isOfficer: true);
        expect(
          permissionService.hasAllRequiredPermissionsSync(isOfficer: true),
          isFalse,
        );

        authBloc = _ControllableAuthBloc(
          const AuthAuthenticated(user: _linmasUser, token: 'token-linmas'),
        );
        final router = buildTestRouter(initialLocation: AppRouter.splashPath);

        await tester.pumpWidget(wrapRouter(router));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(find.text('Permission Setup Destination'), findsOneWidget);
        expect(trackingBloc.events.whereType<StartTrackingEvent>(), isEmpty);
        expect(
          trackingBloc.events.whereType<StopTrackingEvent>(),
          hasLength(1),
        );
      },
    );

    testWidgets(
      'Linmas with all permissions granted dispatches StartTrackingEvent and navigates to main',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 780));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        for (final step in permissionService.stepsForRole(isOfficer: true)) {
          gateway.checkStatuses[step.type] = PermissionStepStatus.granted;
        }
        await permissionService.refreshStatuses(isOfficer: true);
        expect(
          permissionService.hasAllRequiredPermissionsSync(isOfficer: true),
          isTrue,
        );

        authBloc = _ControllableAuthBloc(
          const AuthAuthenticated(user: _linmasUser, token: 'token-linmas'),
        );
        final router = buildTestRouter(initialLocation: AppRouter.splashPath);

        await tester.pumpWidget(wrapRouter(router));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(find.text('Main Destination'), findsOneWidget);
        expect(
          trackingBloc.events.whereType<StartTrackingEvent>(),
          hasLength(1),
        );
      },
    );

    testWidgets(
      'Masyarakat missing permissions navigates to permissionSetup without StartTrackingEvent',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 780));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await permissionService.refreshStatuses(isOfficer: false);
        authBloc = _ControllableAuthBloc(
          const AuthAuthenticated(
            user: _masyarakatUser,
            token: 'token-masyarakat',
          ),
        );
        final router = buildTestRouter(initialLocation: AppRouter.splashPath);

        await tester.pumpWidget(wrapRouter(router));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(find.text('Permission Setup Destination'), findsOneWidget);
        expect(trackingBloc.events.whereType<StartTrackingEvent>(), isEmpty);
        expect(
          trackingBloc.events.whereType<StopTrackingEvent>(),
          hasLength(1),
        );
      },
    );
  });

  group('LoginScreen permission gating and location decoupling', () {
    testWidgets(
      'does not request location on open and navigates Linmas with missing permissions to permissionSetup without StartTrackingEvent',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(600, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await permissionService.refreshStatuses(isOfficer: true);
        authBloc = _ControllableAuthBloc(const AuthUnauthenticated());
        final router = buildTestRouter(
          initialLocation: '${AppRouter.loginPath}?role=linmas',
        );

        await tester.pumpWidget(wrapRouter(router));
        await tester.pumpAndSettle();

        // Must NOT request OS location permission on LoginScreen mount.
        expect(geolocatorCalls, isEmpty);

        authBloc.emitState(
          const AuthAuthenticated(user: _linmasUser, token: 'token-linmas'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Permission Setup Destination'), findsOneWidget);
        expect(trackingBloc.events.whereType<StartTrackingEvent>(), isEmpty);
        expect(geolocatorCalls, isEmpty);
      },
    );

    testWidgets(
      'navigates Linmas with all permissions granted to main and dispatches StartTrackingEvent',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(600, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        for (final step in permissionService.stepsForRole(isOfficer: true)) {
          gateway.checkStatuses[step.type] = PermissionStepStatus.granted;
        }
        await permissionService.refreshStatuses(isOfficer: true);

        authBloc = _ControllableAuthBloc(const AuthUnauthenticated());
        final router = buildTestRouter(
          initialLocation: '${AppRouter.loginPath}?role=linmas',
        );

        await tester.pumpWidget(wrapRouter(router));
        await tester.pumpAndSettle();

        authBloc.emitState(
          const AuthAuthenticated(user: _linmasUser, token: 'token-linmas'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Main Destination'), findsOneWidget);
        expect(
          trackingBloc.events.whereType<StartTrackingEvent>(),
          hasLength(1),
        );
        expect(geolocatorCalls, isEmpty);
      },
    );
  });
}
