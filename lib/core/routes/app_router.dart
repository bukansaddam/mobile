import 'dart:async';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/linmas/activation/presentation/pages/activation_detail_screen.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/pages/login_screen.dart';
import 'package:akar/features/auth/presentation/pages/welcome_screen.dart';
import 'package:akar/features/linmas/panic/presentation/pages/panic_screen.dart';
import 'package:akar/features/linmas/presensi/presentation/pages/presensi_screen.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/pages/ronda_screen.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/presentation/pages/demografi_list_screen.dart';
import 'package:akar/features/linmas/demografi/tokoh/presentation/pages/add_tokoh_screen.dart';
import 'package:akar/features/linmas/demografi/institusi/presentation/pages/add_institusi_screen.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/pages/add_organisasi_screen.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/pages/bank_sampah_list_screen.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/pages/add_bank_sampah_report_screen.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_detail_bloc/jaga_tanah_detail_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_list_bloc/jaga_tanah_list_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/create_jaga_tanah_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_detail_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_list_screen.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/pages/laporan_insidentil_list_screen.dart';
import 'package:akar/features/linmas/main/presentation/pages/main_screen.dart';
import 'package:akar/features/auth/presentation/pages/register_screen.dart';
import 'package:akar/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/splash/presentation/pages/splash_screen.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/my_complaint_history_page.dart';
import 'package:akar/features/masyarakat/main/presentation/pages/main_screen.dart';
import 'package:akar/features/survey/presentation/pages/survey_screen.dart';
import 'package:akar/features/survey/presentation/pages/initial_survey_screen.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/features/masyarakat/notification/presentation/pages/disaster_emergency_call_page.dart';
import 'package:akar/features/notifications/presentation/pages/notification_page.dart';
import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  // Common
  static const String splash = 'splash';
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String register = 'register';
  static const String editProfile = 'editProfile';
  static const String main = 'main';
  static const String survey = 'survey';
  static const String initialSurvey = 'initialSurvey';
  static const String emergencyCall = 'emergencyCall';
  static const String emergencyCallPath = '/emergency-call';
  static const String notifications = 'notifications';

  // Linmas Routes
  static const String activationDetail = 'activationDetail';
  static const String panic = 'panic';
  static const String presensi = 'presensi';
  static const String rondaMalam = 'rondaMalam';
  static const String demografi = 'demografi';
  static const String tambahTokoh = 'tambahTokoh';
  static const String tambahInstitusi = 'tambahInstitusi';
  static const String tambahOrganisasi = 'tambahOrganisasi';
  static const String bankSampah = 'bankSampah';
  static const String tambahBankSampah = 'tambahBankSampah';
  static const String laporanInsidentil = 'laporanInsidentil';
  static const String tambahLaporanInsidentil = 'tambahLaporanInsidentil';
  static const String jagaTanah = 'jagaTanah';
  static const String tambahJagaTanah = 'tambahJagaTanah';
  static const String jagaTanahDetail = 'jagaTanahDetail';

  // Masyarakat Routes
  static const String masyarakatMain = 'masyarakatMain';
  static const String complaintDetail = 'complaintDetail';
  static const String createComplaint = 'createComplaint';
  static const String myComplaints = 'myComplaints';

  // Paths
  static const String splashPath = '/';
  static const String welcomePath = '/welcome';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String editProfilePath = '/edit-profile';
  static const String mainPath = '/main';
  static const String panicPath = '/panic';
  static const String presensiPath = '/presensi';
  static const String rondaMalamPath = '/ronda-malam';
  static const String demografiPath = '/demografi';
  static const String tambahTokohPath = '/tambah-tokoh';
  static const String tambahInstitusiPath = '/tambah-institusi';
  static const String tambahOrganisasiPath = '/tambah-organisasi';
  static const String bankSampahPath = '/bank-sampah';
  static const String tambahBankSampahPath = '/tambah-bank-sampah';
  static const String activationDetailPath = '/activation-detail';
  static const String laporanInsidentilPath = '/laporan-insidentil';
  static const String tambahLaporanInsidentilPath =
      '/tambah-laporan-insidentil';
  static const String jagaTanahPath = '/jaga-tanah';
  static const String tambahJagaTanahPath = '/tambah-jaga-tanah';
  static const String jagaTanahDetailPath = '/jaga-tanah/detail';

  static const String masyarakatMainPath = '/masyarakat/main';
  static const String complaintDetailPath = '/masyarakat/complaint-detail';
  static const String createComplaintPath = '/masyarakat/create-complaint';
  static const String myComplaintsPath = '/masyarakat/my-complaints';
  static const String surveyPath = '/survey';
  static const String initialSurveyPath = '/initial-survey';
  static const String notificationsPath = '/notifications';

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: splashPath,
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;

      if (authState is AuthInitial || authState is AuthChecking) {
        return null;
      }

      final isLoggedIn = authState is AuthAuthenticated;
      final UserEntity? currentUser = authState is AuthAuthenticated
          ? authState.user
          : null;
      final location = state.matchedLocation;
      final isMember = currentUser?.isMember ?? false;

      final isSplash = location == splashPath;
      final isEmergencyCall = location == emergencyCallPath;
      final isAuthRoute =
          location == welcomePath ||
          location == loginPath ||
          location == registerPath;

      if (isSplash || isEmergencyCall) {
        return null;
      }

      if (!isLoggedIn && !isAuthRoute) {
        return welcomePath;
      }

      if (isLoggedIn) {
        final hasCompletedSurvey =
            currentUser != null &&
            (currentUser.hasCompletedInitialQuiz ||
                sl<SurveyLocalDatasource>().isInitialSurveyCompletedSync(
                  currentUser.id,
                ));

        // Pengecekan survey hanya saat login. Jika sudah selesai dan membuka rute survey awal, redirect ke main.
        if (location == initialSurveyPath && hasCompletedSurvey) {
          return mainPath;
        }

        final defaultHome = isMember
            ? masyarakatMainPath
            : hasCompletedSurvey
            ? mainPath
            : initialSurveyPath;

        if (isAuthRoute) {
          return defaultHome;
        }

        // Guard: Jika Member mencoba mengakses rute khusus Linmas
        final linmasOnlyPrefixes = [
          '/main',
          '/panic',
          '/presensi',
          '/ronda-malam',
          '/demografi',
          '/tambah-tokoh',
          '/tambah-institusi',
          '/tambah-organisasi',
          '/bank-sampah',
          '/tambah-bank-sampah',
          '/laporan-insidentil',
          '/tambah-laporan-insidentil',
          '/jaga-tanah',
          '/tambah-jaga-tanah',
          '/activation-detail',
          '/activation_detail',
          '/survey',
          '/initial-survey',
        ];

        final isAttemptingLinmasRoute = linmasOnlyPrefixes.any(
          (prefix) =>
              location == prefix ||
              location.startsWith('$prefix/') ||
              location.startsWith('$prefix?'),
        );

        if (isMember && isAttemptingLinmasRoute) {
          return masyarakatMainPath;
        }

        // Guard: Jika Linmas mencoba mengakses rute utama Masyarakat
        if (!isMember && location == masyarakatMainPath) {
          return mainPath;
        }
      }

      return null;
    },
    routes: [
      // Common
      GoRoute(
        path: splashPath,
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: welcomePath,
        name: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: loginPath,
        name: login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginScreen(role: state.uri.queryParameters['role']),
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(opacity: curved, child: child);
          },
        ),
      ),
      GoRoute(
        path: registerPath,
        name: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: editProfilePath,
        name: editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: notificationsPath,
        name: notifications,
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: surveyPath,
        name: survey,
        builder: (context, state) => const SurveyScreen(),
      ),
      GoRoute(
        path: initialSurveyPath,
        name: initialSurvey,
        builder: (context, state) => const InitialSurveyScreen(),
      ),
      GoRoute(
        path: emergencyCallPath,
        name: emergencyCall,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final event =
              state.extra as DisasterAlertEvent? ??
              DisasterAlertEvent(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: 'PANGGILAN DARURAT: SOS',
                type: 'Darurat SOS',
                description: 'Panggilan darurat masuk.',
                location: 'Lokasi Terdeteksi',
                severity: DisasterSeverity.critical,
                timestamp: DateTime.now(),
              );
          return DisasterEmergencyWarningPage(event: event);
        },
      ),

      // Linmas (Officer)
      GoRoute(
        path: mainPath,
        name: main,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: panicPath,
        name: panic,
        builder: (context, state) => const PanicScreen(),
      ),
      GoRoute(
        path: presensiPath,
        name: presensi,
        builder: (context, state) => const PresensiScreen(),
      ),
      GoRoute(
        path: rondaMalamPath,
        name: rondaMalam,
        builder: (context, state) => const RondaScreen(),
      ),
      GoRoute(
        path: demografiPath,
        name: demografi,
        builder: (context, state) => const DemografiListScreen(),
      ),
      GoRoute(
        path: tambahTokohPath,
        name: tambahTokoh,
        builder: (context, state) {
          final extra = state.extra;
          return AddTokohScreen(
            initialTokoh: extra is TokohEntity ? extra : null,
          );
        },
      ),
      GoRoute(
        path: tambahInstitusiPath,
        name: tambahInstitusi,
        builder: (context, state) {
          final extra = state.extra;
          return AddInstitusiScreen(
            initialInstitusi: extra is InstitusiEntity ? extra : null,
          );
        },
      ),
      GoRoute(
        path: tambahOrganisasiPath,
        name: tambahOrganisasi,
        builder: (context, state) {
          final extra = state.extra;
          return AddOrganisasiScreen(
            initialOrganisasi: extra is OrganisasiEntity ? extra : null,
          );
        },
      ),
      GoRoute(
        path: bankSampahPath,
        name: bankSampah,
        builder: (context, state) => const BankSampahListScreen(),
      ),
      GoRoute(
        path: tambahBankSampahPath,
        name: tambahBankSampah,
        builder: (context, state) => const AddBankSampahReportScreen(),
      ),
      GoRoute(
        path: laporanInsidentilPath,
        name: laporanInsidentil,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              sl<MyComplaintListBloc>()
                ..add(const FetchMyComplaintsEvent(isInsidentil: true)),
          child: const LaporanInsidentilListScreen(),
        ),
      ),
      GoRoute(
        path: tambahLaporanInsidentilPath,
        name: tambahLaporanInsidentil,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CreateComplaintPage(isInsidentil: true),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: jagaTanahPath,
        name: jagaTanah,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              sl<JagaTanahListBloc>()..add(const FetchJagaTanahReportsEvent()),
          child: const JagaTanahListScreen(),
        ),
      ),
      GoRoute(
        path: tambahJagaTanahPath,
        name: tambahJagaTanah,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) =>
                  sl<CreateJagaTanahBloc>()
                    ..add(const LoadJagaTanahCategoriesEvent()),
              child: const CreateJagaTanahPage(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: jagaTanahDetailPath,
        name: jagaTanahDetail,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final ComplaintItem? item = extra is ComplaintItem ? extra : null;
          final String reportId = item != null
              ? (item.reportId ?? '')
              : (extra?.toString() ?? '');
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) {
                final bloc = sl<JagaTanahDetailBloc>();
                if (reportId.isNotEmpty) {
                  bloc.add(FetchJagaTanahDetailEvent(reportId));
                }
                return bloc;
              },
              child: JagaTanahDetailPage(reportId: reportId, initialItem: item),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: activationDetailPath,
        name: activationDetail,
        builder: (context, state) {
          String activityId = '';
          bool autoShowInfo = false;
          if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            activityId = map['activityId'] as String? ?? '';
            autoShowInfo = map['autoShowInfo'] as bool? ?? false;
          } else if (state.extra is String) {
            activityId = state.extra as String;
          }
          return ActivationDetailScreen(
            activityId: activityId,
            autoShowInfo: autoShowInfo,
          );
        },
      ),
      GoRoute(
        path: '/activation_detail',
        name: 'activation_detail',
        builder: (context, state) {
          String activityId = '';
          bool autoShowInfo = false;
          if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            activityId = map['activityId'] as String? ?? '';
            autoShowInfo = map['autoShowInfo'] as bool? ?? false;
          } else if (state.extra is String) {
            activityId = state.extra as String;
          }
          return ActivationDetailScreen(
            activityId: activityId,
            autoShowInfo: autoShowInfo,
          );
        },
      ),

      // Masyarakat (Member / Dumas)
      GoRoute(
        path: masyarakatMainPath,
        name: masyarakatMain,
        builder: (context, state) => const MasyarakatMainScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MasyarakatMainScreen(),
      ),
      GoRoute(
        path: myComplaintsPath,
        name: myComplaints,
        builder: (context, state) =>
            const MyComplaintHistoryPage(showAppBar: true),
      ),
      GoRoute(
        path: '/my-complaints',
        builder: (context, state) =>
            const MyComplaintHistoryPage(showAppBar: true),
      ),
      GoRoute(
        path: complaintDetailPath,
        name: complaintDetail,
        pageBuilder: (context, state) {
          final item = state.extra as ComplaintItem;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ComplaintDetailPage(item: item),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/complaint-detail',
        pageBuilder: (context, state) {
          final item = state.extra as ComplaintItem;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ComplaintDetailPage(item: item),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: createComplaintPath,
        name: createComplaint,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CreateComplaintPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/create-complaint',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CreateComplaintPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  );
                },
          );
        },
      ),
    ],
  );

  // Navigation shortcuts
  static void toHome(BuildContext context) {
    final authState = sl<AuthBloc>().state;
    final isMember = authState is AuthAuthenticated
        ? authState.user.isMember
        : false;
    if (isMember) {
      context.goNamed(masyarakatMain);
    } else {
      context.goNamed(main);
    }
  }

  static void toMyComplaints(BuildContext context) {
    context.pushNamed(myComplaints);
  }

  static Future<void> toComplaintDetail(
    BuildContext context,
    ComplaintItem item,
  ) {
    return context.pushNamed(complaintDetail, extra: item);
  }

  static Future<bool?> toCreateComplaint(BuildContext context) {
    return context.pushNamed<bool>(createComplaint);
  }

  static Future<bool?> toTambahLaporanInsidentil(BuildContext context) {
    return context.pushNamed<bool>(tambahLaporanInsidentil);
  }

  static Future<bool?> toTambahJagaTanah(BuildContext context) {
    return context.pushNamed<bool>(tambahJagaTanah);
  }

  static Future<void> toJagaTanahDetail(
    BuildContext context,
    ComplaintItem item,
  ) {
    return context.pushNamed(jagaTanahDetail, extra: item);
  }

  static bool _isNavigatingToEditProfile = false;

  static Future<void> toEditProfile(BuildContext context) async {
    if (_isNavigatingToEditProfile) return;
    _isNavigatingToEditProfile = true;
    try {
      await context.pushNamed(editProfile);
    } finally {
      await Future.delayed(const Duration(milliseconds: 600));
      _isNavigatingToEditProfile = false;
    }
  }
}
