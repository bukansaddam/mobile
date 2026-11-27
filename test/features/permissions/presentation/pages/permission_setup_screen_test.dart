import 'dart:async';

import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:akar/features/permissions/presentation/bloc/permission_onboarding_bloc/permission_onboarding_bloc.dart';
import 'package:akar/features/permissions/presentation/pages/permission_setup_screen.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_completed_view.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_illustration.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_progress_header.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_seamless_background.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_step_content.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakePermissionGateway implements PermissionGateway {
  final Map<AppPermissionType, PermissionStepStatus> checkStatuses = {};
  final Map<AppPermissionType, PermissionStepStatus> requestResults = {};
  final Map<AppPermissionType, Completer<PermissionStepStatus>>
  pendingRequests = {};
  final List<AppPermissionType> requestedTypes = [];
  int openSettingsCalls = 0;

  @override
  Future<PermissionStepStatus> checkStatus(AppPermissionType type) async {
    return checkStatuses[type] ?? PermissionStepStatus.denied;
  }

  @override
  Future<PermissionStepStatus> request(AppPermissionType type) async {
    requestedTypes.add(type);
    final pending = pendingRequests.remove(type);
    if (pending != null) {
      final result = await pending.future;
      checkStatuses[type] = result;
      return result;
    }
    final result = requestResults[type] ?? PermissionStepStatus.denied;
    checkStatuses[type] = result;
    return result;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCalls += 1;
    return true;
  }
}

class _RecordingAuthBloc extends Fake implements AuthBloc {
  _RecordingAuthBloc(this._state, {this.eventLog});

  final AuthState _state;
  final List<String>? eventLog;
  final _controller = StreamController<AuthState>.broadcast();
  final List<AuthEvent> events = [];

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => _controller.stream;

  @override
  bool get isClosed => _controller.isClosed;

  @override
  void add(AuthEvent event) {
    events.add(event);
    eventLog?.add(event.runtimeType.toString());
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class _RecordingTrackingBloc extends Fake implements TrackingBloc {
  _RecordingTrackingBloc({this.eventLog});

  final TrackingState _state = const TrackingState();
  final List<String>? eventLog;
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
    eventLog?.add(event.runtimeType.toString());
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class _TestHarness {
  final _FakePermissionGateway gateway;
  final AppPermissionService service;
  final PermissionOnboardingBloc permissionBloc;
  final _RecordingAuthBloc authBloc;
  final _RecordingTrackingBloc trackingBloc;
  final List<String> eventLog;

  _TestHarness._({
    required this.gateway,
    required this.service,
    required this.permissionBloc,
    required this.authBloc,
    required this.trackingBloc,
    required this.eventLog,
  });

  factory _TestHarness.create({
    required bool isOfficer,
    bool hasCompletedInitialQuiz = false,
    Map<AppPermissionType, PermissionStepStatus>? checkStatuses,
    Map<AppPermissionType, PermissionStepStatus>? requestResults,
  }) {
    final gateway = _FakePermissionGateway();
    if (checkStatuses != null) {
      gateway.checkStatuses.addAll(checkStatuses);
    }
    if (requestResults != null) {
      gateway.requestResults.addAll(requestResults);
    }
    final service = AppPermissionService(gateway: gateway);
    final permissionBloc = PermissionOnboardingBloc(permissionService: service);
    final eventLog = <String>[];
    final authBloc = _RecordingAuthBloc(
      AuthAuthenticated(
        user: UserEntity(
          id: isOfficer ? 10 : 20,
          name: isOfficer ? 'Petugas Budi' : 'Warga Siti',
          username: isOfficer ? 'officer' : 'member',
          role: isOfficer ? 'linmas' : 'masyarakat',
          isInitialQuizCompleted: hasCompletedInitialQuiz,
        ),
        token: isOfficer ? 'token-officer' : 'token-member',
      ),
      eventLog: eventLog,
    );
    final trackingBloc = _RecordingTrackingBloc(eventLog: eventLog);
    return _TestHarness._(
      gateway: gateway,
      service: service,
      permissionBloc: permissionBloc,
      authBloc: authBloc,
      trackingBloc: trackingBloc,
      eventLog: eventLog,
    );
  }

  Widget buildApp({ThemeData? theme, Key? key}) {
    return MultiBlocProvider(
      key: key,
      providers: [
        BlocProvider<PermissionOnboardingBloc>.value(value: permissionBloc),
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<TrackingBloc>.value(value: trackingBloc),
      ],
      child: MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
        home: const PermissionSetupScreen(),
      ),
    );
  }

  Future<void> dispose() async {
    await permissionBloc.close();
    await authBloc.close();
    await trackingBloc.close();
    service.dispose();
  }
}

void main() {
  group('PermissionSetupScreen Widget Tests', () {
    testWidgets(
      'renders Masyarakat flow in both Light and Dark themes on small phone without overflow',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          final harness = _TestHarness.create(isOfficer: false);
          addTearDown(harness.dispose);

          await tester.pumpWidget(
            harness.buildApp(theme: theme, key: ValueKey(theme.brightness)),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expect(find.byType(PermissionSeamlessBackground), findsOneWidget);
          expect(find.byType(PermissionProgressHeader), findsOneWidget);
          expect(find.byType(PermissionStepContent), findsOneWidget);
          expect(find.byType(PermissionIllustration), findsOneWidget);
          expect(find.text('Masyarakat'), findsNothing);
          expect(find.text('Petugas Aslinmas'), findsNothing);
          expect(find.text('Langkah 1 dari 3'), findsOneWidget);
          expect(find.text('Akses Lokasi'), findsOneWidget);
          expect(find.text('Izinkan'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'renders Linmas locationAlways step with prominent disclosure note about Izinkan sepanjang waktu',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: true,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          },
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Petugas Aslinmas'), findsNothing);
        expect(find.text('Masyarakat'), findsNothing);
        expect(find.text('Langkah 2 dari 5'), findsOneWidget);
        expect(find.text('Lokasi Latar Belakang'), findsOneWidget);
        expect(find.textContaining('Izinkan sepanjang waktu'), findsOneWidget);
        expect(find.text('Izinkan'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping primary CTA requests current permission and advances to Akses Kamera once granted',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: false,
          requestResults: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          },
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Izinkan'));
        await tester.pumpAndSettle();

        expect(
          harness.gateway.requestedTypes,
          equals([AppPermissionType.locationWhenInUse]),
        );
        expect(find.text('Langkah 2 dari 3'), findsOneWidget);
        expect(find.text('Akses Kamera'), findsOneWidget);
        expect(find.text('Izinkan'), findsOneWidget);
      },
    );

    testWidgets(
      'when denied, shows warning feedback banner and CTA label Coba Izinkan Lagi',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: false,
          requestResults: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.denied,
          },
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Izinkan'));
        await tester.pumpAndSettle();

        expect(find.text('Langkah 1 dari 3'), findsOneWidget);
        expect(find.text('Coba Izinkan Lagi'), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'when permanentlyDenied or needsSettings, shows settings guidance banner, Buka Pengaturan, and Periksa Ulang Status',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: false,
          checkStatuses: {
            AppPermissionType.locationWhenInUse:
                PermissionStepStatus.permanentlyDenied,
          },
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Buka Pengaturan'), findsOneWidget);
        expect(find.text('Periksa Ulang Status'), findsOneWidget);
        expect(
          find.textContaining('Buka Pengaturan, pilih Izin'),
          findsOneWidget,
        );

        await tester.tap(find.text('Buka Pengaturan'));
        await tester.pumpAndSettle();
        expect(harness.gateway.openSettingsCalls, equals(1));

        harness.gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.granted;
        final refreshButton = find.text('Periksa Ulang Status');
        await tester.ensureVisible(refreshButton);
        await tester.pumpAndSettle();
        await tester.tap(refreshButton);
        await tester.pumpAndSettle();

        expect(find.text('Langkah 2 dari 3'), findsOneWidget);
        expect(find.text('Akses Kamera'), findsOneWidget);
      },
    );

    testWidgets(
      'AppLifecycleState.resumed triggers RefreshPermissionsEvent and advances when granted',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: true,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
            AppPermissionType.locationAlways:
                PermissionStepStatus.needsSettings,
          },
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Langkah 2 dari 5'), findsOneWidget);
        expect(find.text('Buka Pengaturan'), findsOneWidget);
        expect(find.text('Periksa Ulang Status'), findsOneWidget);

        harness.gateway.checkStatuses[AppPermissionType.locationAlways] =
            PermissionStepStatus.granted;
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pumpAndSettle();

        expect(find.text('Langkah 3 dari 5'), findsOneWidget);
        expect(find.text('Akses Kamera'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping bottom Keluar opens AppDialogs.showConfirmation and dispatches StopTrackingEvent before LogoutEvent only when confirmed',
      (tester) async {
        final harness = _TestHarness.create(isOfficer: false);
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        final logoutFinder = find.text('Keluar');
        expect(logoutFinder, findsOneWidget);
        expect(
          tester.getTopLeft(logoutFinder).dy,
          greaterThan(tester.getBottomLeft(find.byType(ElevatedButton)).dy),
        );
        final logoutSize = tester.getSize(
          find.ancestor(
            of: logoutFinder,
            matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
          ),
        );
        expect(logoutSize.height, greaterThanOrEqualTo(48));

        await tester.ensureVisible(logoutFinder);
        await tester.pumpAndSettle();
        await tester.tap(logoutFinder);
        await tester.pumpAndSettle();

        expect(find.text('Keluar dari Akun?'), findsOneWidget);
        expect(find.text('Batal'), findsOneWidget);

        await tester.tap(find.text('Batal'));
        await tester.pumpAndSettle();
        expect(
          harness.trackingBloc.events.whereType<StopTrackingEvent>(),
          isEmpty,
        );
        expect(harness.authBloc.events.whereType<LogoutEvent>(), isEmpty);
        expect(harness.eventLog, isEmpty);

        await tester.ensureVisible(logoutFinder);
        await tester.pumpAndSettle();
        await tester.tap(logoutFinder);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Keluar').last);
        await tester.pumpAndSettle();

        expect(
          harness.trackingBloc.events.whereType<StopTrackingEvent>(),
          hasLength(1),
        );
        expect(harness.authBloc.events.whereType<LogoutEvent>(), hasLength(1));
        expect(harness.eventLog, equals(['StopTrackingEvent', 'LogoutEvent']));
      },
    );

    testWidgets(
      'when all permissions are granted, renders cardless PermissionCompletedView and hides Keluar',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: false,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
            AppPermissionType.camera: PermissionStepStatus.granted,
            AppPermissionType.notification: PermissionStepStatus.granted,
          },
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        expect(find.byType(PermissionCompletedView), findsOneWidget);
        expect(find.text('Semua Izin Lengkap'), findsOneWidget);
        expect(find.text('Keluar'), findsNothing);

        final decoratedBoxes = tester.widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(PermissionCompletedView),
            matching: find.byType(DecoratedBox),
          ),
        );
        for (final box in decoratedBoxes) {
          final decoration = box.decoration;
          if (decoration is BoxDecoration) {
            expect(decoration.border, isNull);
            expect(decoration.boxShadow, isNull);
          }
        }
      },
    );

    testWidgets(
      'Linmas completion dispatches StartTrackingEvent once, while Masyarakat completion does not',
      (tester) async {
        // Case 1: Linmas completes final step.
        final officerHarness = _TestHarness.create(
          isOfficer: true,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
            AppPermissionType.locationAlways: PermissionStepStatus.granted,
            AppPermissionType.camera: PermissionStepStatus.granted,
            AppPermissionType.microphone: PermissionStepStatus.granted,
            AppPermissionType.notification: PermissionStepStatus.denied,
          },
          requestResults: {
            AppPermissionType.notification: PermissionStepStatus.granted,
          },
        );
        addTearDown(officerHarness.dispose);

        await tester.pumpWidget(officerHarness.buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Langkah 5 dari 5'), findsOneWidget);
        await tester.tap(find.text('Izinkan'));
        await tester.pumpAndSettle();

        expect(
          officerHarness.trackingBloc.events.whereType<StartTrackingEvent>(),
          hasLength(1),
        );

        // Case 2: Masyarakat completes final step without StartTrackingEvent.
        final memberHarness = _TestHarness.create(
          isOfficer: false,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
            AppPermissionType.camera: PermissionStepStatus.granted,
            AppPermissionType.notification: PermissionStepStatus.denied,
          },
          requestResults: {
            AppPermissionType.notification: PermissionStepStatus.granted,
          },
        );
        addTearDown(memberHarness.dispose);

        await tester.pumpWidget(
          memberHarness.buildApp(key: const ValueKey('member_completion')),
        );
        await tester.pumpAndSettle();

        expect(find.text('Langkah 3 dari 3'), findsOneWidget);
        await tester.tap(find.text('Izinkan'));
        await tester.pumpAndSettle();

        expect(
          memberHarness.trackingBloc.events.whereType<StartTrackingEvent>(),
          isEmpty,
        );
      },
    );

    testWidgets(
      'PopScope prevents back navigation out of PermissionSetupScreen',
      (tester) async {
        final harness = _TestHarness.create(isOfficer: false);
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        final popScope = tester.widget<PopScope>(find.byType(PopScope));
        expect(popScope.canPop, isFalse);
      },
    );

    testWidgets(
      'shows loading spinner and disables CTA while permission request is in flight',
      (tester) async {
        final harness = _TestHarness.create(isOfficer: false);
        final completer = Completer<PermissionStepStatus>();
        harness.gateway.pendingRequests[AppPermissionType.locationWhenInUse] =
            completer;
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Izinkan'));
        await tester.pump();
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNull);

        completer.complete(PermissionStepStatus.granted);
        await tester.pumpAndSettle();

        expect(find.text('Langkah 2 dari 3'), findsOneWidget);
        expect(find.text('Akses Kamera'), findsOneWidget);
      },
    );

    testWidgets(
      'survives 320x568 viewport at 2.0x text scale on Linmas locationAlways needsSettings state without overflow',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final harness = _TestHarness.create(
          isOfficer: true,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
            AppPermissionType.locationAlways:
                PermissionStepStatus.needsSettings,
          },
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.buildApp(theme: AppTheme.darkTheme));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Buka Pengaturan'), findsOneWidget);
        expect(find.text('Periksa Ulang Status'), findsOneWidget);

        // Verify sticky top header and sticky bottom footer stay pinned while scrolling content.
        final headerTopBefore = tester
            .getTopLeft(find.byType(PermissionProgressHeader))
            .dy;
        final ctaTopBefore = tester.getTopLeft(find.byType(ElevatedButton)).dy;
        final logoutTopBefore = tester.getTopLeft(find.text('Keluar')).dy;

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -180),
        );
        await tester.pumpAndSettle();

        expect(
          tester.getTopLeft(find.byType(PermissionProgressHeader)).dy,
          equals(headerTopBefore),
        );
        expect(
          tester.getTopLeft(find.byType(ElevatedButton)).dy,
          equals(ctaTopBefore),
        );
        expect(
          tester.getTopLeft(find.text('Keluar')).dy,
          equals(logoutTopBefore),
        );
      },
    );

    testWidgets(
      'GoRouter-integrated Linmas completion dispatches StartTrackingEvent and exits /permission-setup to /initial-survey',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: true,
          hasCompletedInitialQuiz: false,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
            AppPermissionType.locationAlways: PermissionStepStatus.granted,
            AppPermissionType.camera: PermissionStepStatus.granted,
            AppPermissionType.microphone: PermissionStepStatus.granted,
            AppPermissionType.notification: PermissionStepStatus.denied,
          },
          requestResults: {
            AppPermissionType.notification: PermissionStepStatus.granted,
          },
        );
        addTearDown(harness.dispose);

        final router = GoRouter(
          initialLocation: AppRouter.permissionSetupPath,
          refreshListenable: harness.service,
          redirect: (context, state) => AppRouter.resolveRedirect(
            authState: harness.authBloc.state,
            location: state.matchedLocation,
            hasAllPermissions: harness.service.hasAllRequiredPermissionsSync(
              isOfficer: true,
            ),
            hasCompletedSurvey: false,
          ),
          routes: [
            GoRoute(
              path: AppRouter.permissionSetupPath,
              builder: (context, state) => const PermissionSetupScreen(),
            ),
            GoRoute(
              path: AppRouter.initialSurveyPath,
              builder: (context, state) =>
                  const Scaffold(body: Text('Initial Survey Destination')),
            ),
            GoRoute(
              path: AppRouter.mainPath,
              builder: (context, state) =>
                  const Scaffold(body: Text('Main Destination')),
            ),
            GoRoute(
              path: AppRouter.masyarakatMainPath,
              builder: (context, state) =>
                  const Scaffold(body: Text('Masyarakat Main Destination')),
            ),
            GoRoute(
              path: AppRouter.welcomePath,
              builder: (context, state) =>
                  const Scaffold(body: Text('Welcome Destination')),
            ),
          ],
        );
        addTearDown(router.dispose);

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<PermissionOnboardingBloc>.value(
                value: harness.permissionBloc,
              ),
              BlocProvider<AuthBloc>.value(value: harness.authBloc),
              BlocProvider<TrackingBloc>.value(value: harness.trackingBloc),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Langkah 5 dari 5'), findsOneWidget);
        await tester.tap(find.text('Izinkan'));
        await tester.pumpAndSettle();

        expect(
          harness.trackingBloc.events.whereType<StartTrackingEvent>(),
          hasLength(1),
        );
        expect(find.text('Initial Survey Destination'), findsOneWidget);
        expect(find.byType(PermissionSetupScreen), findsNothing);
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          equals(AppRouter.initialSurveyPath),
        );
      },
    );

    testWidgets(
      'post-frame fallback navigates Linmas out of /permission-setup to /main when GoRouter has no refreshListenable',
      (tester) async {
        final harness = _TestHarness.create(
          isOfficer: true,
          hasCompletedInitialQuiz: true,
          checkStatuses: {
            AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
            AppPermissionType.locationAlways: PermissionStepStatus.granted,
            AppPermissionType.camera: PermissionStepStatus.granted,
            AppPermissionType.microphone: PermissionStepStatus.granted,
            AppPermissionType.notification: PermissionStepStatus.denied,
          },
          requestResults: {
            AppPermissionType.notification: PermissionStepStatus.granted,
          },
        );
        addTearDown(harness.dispose);

        final router = GoRouter(
          initialLocation: AppRouter.permissionSetupPath,
          routes: [
            GoRoute(
              path: AppRouter.permissionSetupPath,
              builder: (context, state) => const PermissionSetupScreen(),
            ),
            GoRoute(
              path: AppRouter.initialSurveyPath,
              builder: (context, state) =>
                  const Scaffold(body: Text('Initial Survey Destination')),
            ),
            GoRoute(
              path: AppRouter.mainPath,
              builder: (context, state) =>
                  const Scaffold(body: Text('Main Destination')),
            ),
            GoRoute(
              path: AppRouter.welcomePath,
              builder: (context, state) =>
                  const Scaffold(body: Text('Welcome Destination')),
            ),
          ],
        );
        addTearDown(router.dispose);

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<PermissionOnboardingBloc>.value(
                value: harness.permissionBloc,
              ),
              BlocProvider<AuthBloc>.value(value: harness.authBloc),
              BlocProvider<TrackingBloc>.value(value: harness.trackingBloc),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Langkah 5 dari 5'), findsOneWidget);
        await tester.tap(find.text('Izinkan'));
        await tester.pumpAndSettle();

        expect(
          harness.trackingBloc.events.whereType<StartTrackingEvent>(),
          hasLength(1),
        );
        expect(find.text('Main Destination'), findsOneWidget);
        expect(find.byType(PermissionSetupScreen), findsNothing);
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          equals(AppRouter.mainPath),
        );
      },
    );
  });
}
