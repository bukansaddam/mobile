import 'dart:async';

import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/widgets/app_brand_logo.dart';
import 'package:akar/core/widgets/app_logo_badge.dart';
import 'package:akar/core/widgets/custom_app_bar.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/pages/login_screen.dart';
import 'package:akar/features/linmas/main/presentation/pages/main_screen.dart';
import 'package:akar/features/linmas/panic/presentation/bloc/panic_bloc/panic_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/complaint_banner_card.dart';
import 'package:akar/features/splash/presentation/pages/splash_screen.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeAuthBloc extends Fake implements AuthBloc {
  @override
  AuthState get state => const AuthUnauthenticated();

  @override
  Stream<AuthState> get stream => const Stream.empty();

  @override
  void add(AuthEvent event) {}
}

class _FakeTrackingBloc extends Fake implements TrackingBloc {
  @override
  TrackingState get state => const TrackingState();

  @override
  Stream<TrackingState> get stream => const Stream.empty();

  @override
  void add(TrackingEvent event) {}
}

class _FakePanicBloc extends Fake implements PanicBloc {
  @override
  PanicState get state => const PanicInitial();

  @override
  Stream<PanicState> get stream => const Stream.empty();

  @override
  void add(PanicEvent event) {}
}

class _FakeSurveyBloc extends Fake implements SurveyBloc {
  @override
  SurveyState get state => SurveyInitialState();

  @override
  Stream<SurveyState> get stream => const Stream.empty();

  @override
  void add(SurveyEvent event) {}
}

String? _assetNameOf(WidgetTester tester, Finder finder) {
  final image = tester.widget<Image>(finder);
  var provider = image.image;
  if (provider is ResizeImage) {
    provider = provider.imageProvider;
  }
  if (provider is AssetImage) {
    return provider.assetName;
  }
  return null;
}

void main() {
  testWidgets('Brand asset constants resolve to valid bundled image assets', (
    tester,
  ) async {
    for (final asset in [
      AppConstants.logoHorizontalAsset,
      AppConstants.logoIconAsset,
      AppConstants.logoGeneralAsset,
      AppConstants.logoLinmasAsset,
      AppConstants.logoDumasAsset,
    ]) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0));
    }
    expect(AppConstants.appName, 'SISKAMLING');
    expect(AppConstants.logoGeneralAsset, 'assets/logo_general.webp');
    expect(AppConstants.logoLinmasAsset, 'assets/logo_linmas.png');
    expect(AppConstants.logoDumasAsset, 'assets/logo_dumas.webp');
  });

  testWidgets(
    'AppBrandLogo and AppLogoBadge render new assets cleanly across breakpoints',
    (tester) async {
      for (final size in [const Size(320, 640), const Size(800, 1024)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: AppBrandLogo(maxWidth: 340),
                    ),
                    SizedBox(height: 16),
                    AppBrandLogo.general(maxWidth: 180),
                    SizedBox(height: 16),
                    AppBrandLogo.linmas(maxWidth: 180),
                    SizedBox(height: 16),
                    AppBrandLogo.dumas(maxWidth: 180),
                    SizedBox(height: 16),
                    AppLogoBadge(size: 38, borderRadius: 10),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        final images = find.byType(Image);
        expect(images, findsNWidgets(5));
        expect(
          _assetNameOf(tester, images.at(0)),
          AppConstants.logoHorizontalAsset,
        );
        expect(
          _assetNameOf(tester, images.at(1)),
          AppConstants.logoGeneralAsset,
        );
        expect(
          _assetNameOf(tester, images.at(2)),
          AppConstants.logoLinmasAsset,
        );
        expect(_assetNameOf(tester, images.at(3)), AppConstants.logoDumasAsset);
        expect(_assetNameOf(tester, images.at(4)), AppConstants.logoIconAsset);
      }
      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'CustomAppBar uses shield icon badge, prevents overflow at 200% text scale, and preserves logo tap shortcut',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Scaffold(
              appBar: CustomAppBar(unreadCount: 3),
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        _assetNameOf(tester, find.byType(Image)),
        AppConstants.logoIconAsset,
      );
      expect(find.text(AppConstants.appBarTitle), findsOneWidget);
      expect(find.text('Dumas'), findsOneWidget);

      final logoFinder = find.byType(AppLogoBadge);
      for (int i = 0; i < 5; i++) {
        await tester.tap(logoFinder);
        await tester.pump();
      }
      expect(find.textContaining('Simulasi'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'MainScreen Linmas AppBar uses shield icon badge without overflow and preserves logo tap shortcut',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(480, 900));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _FakeAuthBloc()),
            BlocProvider<PanicBloc>.value(value: _FakePanicBloc()),
            BlocProvider<SurveyBloc>.value(value: _FakeSurveyBloc()),
          ],
          child: const MaterialApp(home: MainScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        _assetNameOf(tester, find.byType(Image)),
        AppConstants.logoIconAsset,
      );
      expect(find.text(AppConstants.appBarTitle), findsOneWidget);
      expect(find.text('Laporan Linmas'), findsOneWidget);

      final logoFinder = find.byType(AppLogoBadge);
      for (int i = 0; i < 3; i++) {
        await tester.tap(logoFinder);
        await tester.pump();
      }
      expect(
        find.textContaining('Tekan logo ASLINMAS 3/10 kali'),
        findsOneWidget,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'MainScreen menonaktifkan Mode Eksklusif saat tidak dalam mode debug',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(480, 900));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _FakeAuthBloc()),
            BlocProvider<PanicBloc>.value(value: _FakePanicBloc()),
            BlocProvider<SurveyBloc>.value(value: _FakeSurveyBloc()),
          ],
          child: const MaterialApp(
            home: MainScreen(isExclusiveModeEnabled: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byType(AppLogoBadge));
        await tester.pump();
      }
      expect(find.textContaining('Mode Eksklusif'), findsNothing);
      expect(find.textContaining('Reset Status Survey'), findsNothing);

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'LoginScreen displays role-specific brand logos (Dumas for masyarakat, Linmas for linmas) without overflow',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 900));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _FakeAuthBloc()),
            BlocProvider<TrackingBloc>.value(value: _FakeTrackingBloc()),
          ],
          child: const MaterialApp(home: LoginScreen(role: 'masyarakat')),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        _assetNameOf(tester, find.byType(Image)),
        AppConstants.logoDumasAsset,
      );
      expect(find.text('Selamat Datang'), findsOneWidget);

      await tester.tap(find.text('NIK'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _FakeAuthBloc()),
            BlocProvider<TrackingBloc>.value(value: _FakeTrackingBloc()),
          ],
          child: const MaterialApp(home: LoginScreen(role: 'linmas')),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        _assetNameOf(tester, find.byType(Image)),
        AppConstants.logoLinmasAsset,
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _FakeAuthBloc()),
            BlocProvider<TrackingBloc>.value(value: _FakeTrackingBloc()),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        _assetNameOf(tester, find.byType(Image)),
        AppConstants.logoGeneralAsset,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'SplashScreen displays general brand logo without duplicate SISKAMLING text and navigates cleanly',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 780));
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            name: 'splash',
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: '/welcome',
            name: 'welcome',
            builder: (context, state) =>
                const Scaffold(body: Text('Welcome Destination')),
          ),
        ],
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _FakeAuthBloc()),
            BlocProvider<TrackingBloc>.value(value: _FakeTrackingBloc()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.takeException(), isNull);
      expect(
        _assetNameOf(tester, find.byType(Image)),
        AppConstants.logoGeneralAsset,
      );
      expect(find.text(AppConstants.appName), findsNothing);
      expect(find.text('v${AppConstants.appVersion}'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Welcome Destination'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'ComplaintBannerCard displays DUMAS title without overflow and triggers callback on button tap',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 640));
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: ComplaintBannerCard(
                onCreateComplaint: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('DUMAS'), findsOneWidget);
      expect(
        find.text('Dukungan masyarakat untuk\nlingkungan yang lebih baik'),
        findsOneWidget,
      );
      expect(find.text('PENGADUAN\nMASYARAKAT'), findsNothing);

      await tester.tap(find.text('BUAT PENGADUAN'));
      await tester.pump();
      expect(tapped, isTrue);

      await tester.binding.setSurfaceSize(null);
    },
  );
}
