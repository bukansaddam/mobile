import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/core/widgets/app_bar_circle_button.dart';
import 'package:akar/core/widgets/app_logo_badge.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/custom_app_bar.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/pages/activation_detail_screen.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/presentation/bloc/institusi_bloc/institusi_bloc.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/bloc/organisasi_bloc/organisasi_bloc.dart';
import 'package:akar/features/linmas/demografi/presentation/pages/demografi_list_screen.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/tokoh/presentation/bloc/tokoh_bloc/tokoh_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/my_complaint_history_page.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:akar/features/survey/presentation/pages/survey_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeMyComplaintListBloc extends Fake implements MyComplaintListBloc {
  @override
  MyComplaintListState get state => const MyComplaintListState();

  @override
  Stream<MyComplaintListState> get stream => const Stream.empty();

  @override
  void add(MyComplaintListEvent event) {}
}

class _FakeTokohBloc extends Fake implements TokohBloc {
  @override
  TokohState get state => TokohInitial();

  @override
  Stream<TokohState> get stream => const Stream.empty();

  @override
  List<TokohEntity> get listTokoh => const [];

  @override
  List<TokohEntity> get displayList => const [];

  @override
  int get total => 0;

  @override
  int? get page => null;

  @override
  bool get hasActiveFilter => false;

  @override
  String get searchQuery => '';

  @override
  String? get selectedProfesiFilter => null;

  @override
  String? get selectedAfiliasiFilter => null;

  @override
  TokohSortOption get selectedSortOption => TokohSortOption.terbaru;

  @override
  void add(TokohEvent event) {}
}

class _FakeInstitusiBloc extends Fake implements InstitusiBloc {
  @override
  InstitusiState get state => InstitusiInitial();

  @override
  Stream<InstitusiState> get stream => const Stream.empty();

  @override
  List<InstitusiEntity> get listInstitusi => const [];

  @override
  List<InstitusiEntity> get displayList => const [];

  @override
  int get total => 0;

  @override
  int? get page => null;

  @override
  bool get hasActiveFilter => false;

  @override
  String get searchQuery => '';

  @override
  String? get selectedScopeFilter => null;

  @override
  InstitusiSortOption get selectedSortOption => InstitusiSortOption.terbaru;

  @override
  void add(InstitusiEvent event) {}
}

class _FakeOrganisasiBloc extends Fake implements OrganisasiBloc {
  @override
  OrganisasiState get state => OrganisasiInitial();

  @override
  Stream<OrganisasiState> get stream => const Stream.empty();

  @override
  List<OrganisasiEntity> get listOrganisasi => const [];

  @override
  List<OrganisasiEntity> get displayList => const [];

  @override
  int get total => 0;

  @override
  int? get page => null;

  @override
  bool get hasActiveFilter => false;

  @override
  String get searchQuery => '';

  @override
  String? get selectedBidangFilter => null;

  @override
  OrganisasiSortOption get selectedSortOption => OrganisasiSortOption.terbaru;

  @override
  void add(OrganisasiEvent event) {}
}

class _FakeSurveyBloc extends Fake implements SurveyBloc {
  @override
  SurveyState get state => SurveyInitialState();

  @override
  Stream<SurveyState> get stream => const Stream.empty();

  @override
  void add(SurveyEvent event) {}
}

class _FakeActivationBloc extends Fake implements ActivationBloc {
  @override
  ActivationState get state => const ActivationState();

  @override
  Stream<ActivationState> get stream => const Stream.empty();

  @override
  void add(ActivationEvent event) {}
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
  group('AppBarCircleButton Widget Tests', () {
    testWidgets(
      'renders default back button with chevron_left, no border, and 48x48 tap area',
      (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppBarCircleButton.back(onPressed: () => tapped = true),
            ),
          ),
        );

        final iconFinder = find.byIcon(Icons.chevron_left_rounded);
        expect(iconFinder, findsOneWidget);

        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(button.style?.side?.resolve({}), BorderSide.none);

        final sizeBoxFinder = find.byType(SizedBox).first;
        final renderBox = tester.renderObject<RenderBox>(sizeBoxFinder);
        expect(renderBox.size.width, 48.0);
        expect(renderBox.size.height, 48.0);

        await tester.tap(iconFinder);
        expect(tapped, isTrue);
      },
    );

    testWidgets(
      'handles active state with primaryDark background, no border, and white icon',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppBarCircleButton(
                icon: Icons.tune_rounded,
                isActive: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.tune_rounded));
        expect(icon.color, AppColors.white);

        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(
          button.style?.backgroundColor?.resolve({}),
          AppColors.primaryDark,
        );
        expect(button.style?.side?.resolve({}), BorderSide.none);
      },
    );

    testWidgets(
      'handles disabled state when onPressed is null with disabled colors and no border',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppBarCircleButton(
                icon: Icons.chevron_left_rounded,
                onPressed: null,
              ),
            ),
          ),
        );

        final icon = tester.widget<Icon>(
          find.byIcon(Icons.chevron_left_rounded),
        );
        expect(icon.color, AppColors.textDisabled);

        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(button.style?.side?.resolve({}), BorderSide.none);
      },
    );
  });

  group('AppPageBar Widget Tests', () {
    testWidgets(
      'renders centered 18px bold title, gradient over baseColor, symmetric 14dp edges, and invokes callbacks',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        bool backTapped = false;
        bool actionTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppPageBar(
                title: 'Detail Pengaduan',
                onBackPressed: () => backTapped = true,
                actions: [
                  AppBarCircleButton(
                    icon: Icons.info_outline_rounded,
                    tooltip: 'Info',
                    onPressed: () => actionTapped = true,
                  ),
                ],
              ),
              body: const SizedBox.shrink(),
            ),
          ),
        );

        final titleWidget = tester.widget<Text>(find.text('Detail Pengaduan'));
        expect(titleWidget.style?.fontSize, 18);
        expect(titleWidget.style?.fontWeight, FontWeight.bold);
        expect(titleWidget.style?.color, AppColorScheme.light.textPrimary);

        final baseColoredBox = tester.widget<ColoredBox>(
          find
              .descendant(
                of: find.byType(AppPageBar),
                matching: find.byType(ColoredBox),
              )
              .first,
        );
        expect(baseColoredBox.color, AppColors.background);

        final gradientBox = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byType(AppPageBar),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        final decoration = gradientBox.decoration as BoxDecoration;
        expect(decoration.gradient, AppColors.topHeaderGradient);

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.centerTitle, isTrue);
        expect(appBar.scrolledUnderElevation, 0);
        expect(appBar.surfaceTintColor, Colors.transparent);
        expect(appBar.actionsPadding, const EdgeInsets.only(right: 8));

        final iconButtons = find.byType(IconButton);
        expect(iconButtons, findsNWidgets(2));
        final leftButtonRect = tester.getRect(iconButtons.at(0));
        final rightButtonRect = tester.getRect(iconButtons.at(1));
        expect(leftButtonRect.width, 48.0);
        expect(rightButtonRect.width, 48.0);
        expect(leftButtonRect.left, 8.0);
        expect(360.0 - rightButtonRect.right, 8.0);

        final leftCircleRect = tester.getRect(
          find
              .descendant(
                of: iconButtons.at(0),
                matching: find.byType(Material),
              )
              .first,
        );
        final rightCircleRect = tester.getRect(
          find
              .descendant(
                of: iconButtons.at(1),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(leftCircleRect.width, 36.0);
        expect(rightCircleRect.width, 36.0);
        expect(leftCircleRect.left, 14.0);
        expect(360.0 - rightCircleRect.right, 14.0);

        await tester.tap(find.byIcon(Icons.chevron_left_rounded));
        await tester.tap(find.byIcon(Icons.info_outline_rounded));
        expect(backTapped, isTrue);
        expect(actionTapped, isTrue);
      },
    );

    testWidgets('renders no back button when showBackButton is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppPageBar(
              title: 'Survey Profil Baseline Linmas',
              showBackButton: false,
            ),
            body: SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('Survey Profil Baseline Linmas'), findsOneWidget);
      expect(find.byType(AppBarCircleButton), findsNothing);
    });

    testWidgets('does not call onBackPressed when isBackEnabled is false', (
      tester,
    ) async {
      bool backTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppPageBar(
              title: 'Buat Laporan Jaga Tanah',
              isBackEnabled: false,
              onBackPressed: () => backTapped = true,
            ),
            body: const SizedBox.shrink(),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.chevron_left_rounded));
      expect(icon.color, AppColors.textDisabled);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      expect(backTapped, isFalse);
    });

    testWidgets(
      'omits ColoredBox and gradient DecoratedBox when transparentBackground is true',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              appBar: AppPageBar(
                title: 'Masuk Akun',
                transparentBackground: true,
              ),
              body: SizedBox.shrink(),
            ),
          ),
        );

        expect(find.text('Masuk Akun'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppPageBar),
            matching: find.byWidgetPredicate(
              (w) => w is ColoredBox && w.color == AppColors.background,
            ),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byType(AppPageBar),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is DecoratedBox &&
                  w.decoration is BoxDecoration &&
                  (w.decoration as BoxDecoration).gradient ==
                      AppColors.topHeaderGradient,
            ),
          ),
          findsNothing,
        );
      },
    );

    testWidgets('calculates preferredSize correctly with bottom widget', (
      tester,
    ) async {
      const pageBar = AppPageBar(
        title: 'Demografi',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: SizedBox(height: 48),
        ),
      );

      expect(pageBar.preferredSize.height, kToolbarHeight + 48);
    });

    testWidgets('renders without overflow at 320x640 with 200% text scale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Scaffold(
              appBar: AppPageBar(title: 'Detail Laporan Jaga Tanah'),
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Detail Laporan Jaga Tanah'), findsOneWidget);
    });
  });

  group('CustomAppBar.linmas Widget Tests', () {
    testWidgets(
      'renders 60dp toolbar height, linmas logo asset, topHeaderGradient, AA primaryDark subtitle, and forwards callbacks',
      (tester) async {
        bool logoTapped = false;
        bool notificationTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: CustomAppBar.linmas(
                onLogoTap: () => logoTapped = true,
                onNotificationPressed: () => notificationTapped = true,
              ),
              body: const SizedBox.shrink(),
            ),
          ),
        );

        final customAppBar = tester.widget<CustomAppBar>(
          find.byType(CustomAppBar),
        );
        expect(customAppBar.preferredSize.height, 60.0);

        final innerAppBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(innerAppBar.toolbarHeight, 60.0);
        expect(innerAppBar.actionsPadding, EdgeInsets.zero);
        expect(tester.getSize(find.byType(CustomAppBar)).height, 60.0);

        final notifButtonRect = tester.getRect(find.byType(IconButton));
        expect(notifButtonRect.center.dy, 30.0);

        expect(
          _assetNameOf(tester, find.byType(Image)),
          AppConstants.logoLinmasAsset,
        );
        expect(find.text(AppConstants.appBarTitle), findsOneWidget);

        final subtitle = tester.widget<Text>(find.text('Laporan Aslinmas'));
        expect(subtitle.style?.color, AppColors.primaryDark);

        final gradientBox = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byType(CustomAppBar),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        expect(
          (gradientBox.decoration as BoxDecoration).gradient,
          AppColors.topHeaderGradient,
        );

        await tester.tap(find.byType(AppLogoBadge));
        await tester.tap(find.byIcon(Icons.notifications_none_rounded));
        expect(logoTapped, isTrue);
        expect(notificationTapped, isTrue);
      },
    );
  });

  group('AppTheme & Migrated Route Integration Tests', () {
    test('AppTheme.lightTheme uses white AppBar background and headlineSmall bold title', () {
      final appBarTheme = AppTheme.lightTheme.appBarTheme;
      expect(appBarTheme.backgroundColor, AppColors.white);
      expect(appBarTheme.scrolledUnderElevation, 0);
      expect(appBarTheme.surfaceTintColor, Colors.transparent);
      expect(appBarTheme.centerTitle, isTrue);
      expect(
        appBarTheme.titleTextStyle,
        AppTextStyles.headlineSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColorScheme.light.textPrimary,
        ),
      );
    });

    testWidgets(
      'MyComplaintHistoryPage renders AppPageBar only when showAppBar is true',
      (tester) async {
        final fakeBloc = _FakeMyComplaintListBloc();

        await tester.pumpWidget(
          BlocProvider<MyComplaintListBloc>.value(
            value: fakeBloc,
            child: const MaterialApp(
              home: MyComplaintHistoryPage(showAppBar: false),
            ),
          ),
        );
        expect(find.byType(AppPageBar), findsNothing);
        expect(find.text('Riwayat Pengaduan'), findsNothing);

        await tester.pumpWidget(
          BlocProvider<MyComplaintListBloc>.value(
            value: fakeBloc,
            child: const MaterialApp(
              home: MyComplaintHistoryPage(showAppBar: true),
            ),
          ),
        );
        expect(find.byType(AppPageBar), findsOneWidget);
        expect(find.text('Riwayat Pengaduan'), findsOneWidget);
        expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'DemografiListScreen TabBar uses AA primaryDark active color on AppPageBar',
      (tester) async {
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<TokohBloc>.value(value: _FakeTokohBloc()),
              BlocProvider<InstitusiBloc>.value(value: _FakeInstitusiBloc()),
              BlocProvider<OrganisasiBloc>.value(value: _FakeOrganisasiBloc()),
            ],
            child: const MaterialApp(home: DemografiListScreen()),
          ),
        );

        expect(find.byType(AppPageBar), findsOneWidget);
        final tabBar = tester.widget<TabBar>(find.byType(TabBar));
        expect(tabBar.labelColor, AppColors.primaryDark);
        expect(tabBar.indicatorColor, AppColors.primaryDark);
      },
    );

    testWidgets(
      'CustomAppBar debug simulation snackbar omits decorative emoji',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              appBar: CustomAppBar(unreadCount: 0),
              body: SizedBox.shrink(),
            ),
          ),
        );

        final logoFinder = find.byType(AppLogoBadge);
        for (int i = 0; i < 5; i++) {
          await tester.tap(logoFinder);
          await tester.pump();
        }

        expect(find.textContaining('Simulasi'), findsOneWidget);
        expect(find.textContaining('🎯'), findsNothing);
      },
    );

    testWidgets(
      'SurveyScreen back button guards empty GoRouter stack and navigates to /main',
      (tester) async {
        final router = GoRouter(
          initialLocation: '/survey',
          routes: [
            GoRoute(
              path: '/survey',
              builder: (context, state) => BlocProvider<SurveyBloc>.value(
                value: _FakeSurveyBloc(),
                child: const SurveyScreen(),
              ),
            ),
            GoRoute(
              path: '/main',
              builder: (context, state) =>
                  const Scaffold(body: Text('Main Destination')),
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        expect(find.byType(AppPageBar), findsOneWidget);
        await tester.tap(find.byIcon(Icons.chevron_left_rounded));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Main Destination'), findsOneWidget);
      },
    );

    testWidgets(
      'ActivationDetailScreen fallback Scaffold sets explicit AppColors.background',
      (tester) async {
        await tester.pumpWidget(
          BlocProvider<ActivationBloc>.value(
            value: _FakeActivationBloc(),
            child: const MaterialApp(
              home: ActivationDetailScreen(activityId: 'missing'),
            ),
          ),
        );
        await tester.pump();

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, AppColors.background);
        expect(find.byType(AppPageBar), findsOneWidget);
      },
    );

    testWidgets(
      'AppPageBar and AppBarCircleButton adapt colors cleanly in Dark Mode',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              appBar: AppPageBar(
                title: 'Mode Gelap',
                actions: [
                  AppBarCircleButton(
                    icon: Icons.tune_rounded,
                    isActive: true,
                    onPressed: () {},
                  ),
                ],
              ),
              body: const SizedBox.shrink(),
            ),
          ),
        );

        final titleWidget = tester.widget<Text>(find.text('Mode Gelap'));
        expect(titleWidget.style?.color, AppColorScheme.dark.textPrimary);

        final baseColoredBox = tester.widget<ColoredBox>(
          find
              .descendant(
                of: find.byType(AppPageBar),
                matching: find.byType(ColoredBox),
              )
              .first,
        );
        expect(baseColoredBox.color, AppColorScheme.dark.background);

        final activeButton = tester.widget<IconButton>(
          find.byType(IconButton).last,
        );
        expect(
          activeButton.style?.backgroundColor?.resolve({}),
          AppColorScheme.dark.primary,
        );
      },
    );
  });
}
