import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/linmas/activation/presentation/pages/activation_detail_screen.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/pages/login_screen.dart';
import 'package:akar/features/linmas/panic/presentation/pages/panic_screen.dart';
import 'package:akar/features/linmas/presensi/presentation/pages/presensi_screen.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/pages/ronda_screen.dart';
import 'package:akar/features/linmas/demografi/presentation/pages/demografi_list_screen.dart';
import 'package:akar/features/linmas/demografi/presentation/pages/add_tokoh_screen.dart';
import 'package:akar/features/linmas/demografi/presentation/pages/add_institusi_screen.dart';
import 'package:akar/features/linmas/demografi/presentation/pages/add_organisasi_screen.dart';
import 'package:akar/features/linmas/main/presentation/pages/main_screen.dart';
import 'package:akar/features/auth/presentation/pages/register_screen.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/splash/presentation/pages/splash_screen.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/my_complaint_history_page.dart';
import 'package:akar/features/masyarakat/main/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // Common
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';

  // Linmas Routes
  static const String main = 'main';
  static const String profile = 'profile';
  static const String panic = 'panic';
  static const String presensi = 'presensi';
  static const String rondaMalam = 'ronda_malam';
  static const String demografi = 'demografi';
  static const String tambahTokoh = 'tambah_tokoh';
  static const String tambahInstitusi = 'tambah_institusi';
  static const String tambahOrganisasi = 'tambah_organisasi';
  static const String activationDetail = 'activation_detail';

  // Masyarakat Routes
  static const String masyarakatMain = 'masyarakat_main';
  static const String complaintDetail = 'complaint_detail';
  static const String createComplaint = 'create_complaint';
  static const String myComplaints = 'my_complaints';

  // Paths
  static const String splashPath = '/';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String mainPath = '/main';
  static const String profilePath = '/profile';
  static const String panicPath = '/panic';
  static const String presensiPath = '/presensi';
  static const String rondaMalamPath = '/ronda-malam';
  static const String demografiPath = '/demografi';
  static const String tambahTokohPath = '/tambah-tokoh';
  static const String tambahInstitusiPath = '/tambah-institusi';
  static const String tambahOrganisasiPath = '/tambah-organisasi';
  static const String activationDetailPath = '/activation-detail';

  static const String masyarakatMainPath = '/masyarakat/main';
  static const String complaintDetailPath = '/masyarakat/complaint-detail';
  static const String createComplaintPath = '/masyarakat/create-complaint';
  static const String myComplaintsPath = '/masyarakat/my-complaints';

  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    refreshListenable: sl<AuthProvider>(),
    redirect: (context, state) {
      final authProvider = sl<AuthProvider>();

      if (authProvider.isInitialChecking) {
        return null;
      }

      final isLoggedIn = authProvider.isLoggedIn;
      final location = state.matchedLocation;
      final isMember = authProvider.currentUser?.isMember ?? false;

      final isSplash = location == splashPath;
      final isAuthRoute = location == loginPath || location == registerPath;

      if (!isLoggedIn && !isAuthRoute && !isSplash) {
        return loginPath;
      }

      if (isLoggedIn) {
        final defaultHome = isMember ? masyarakatMainPath : mainPath;

        if (isAuthRoute || isSplash) {
          return defaultHome;
        }

        // Guard: Jika Member mencoba mengakses rute khusus Linmas
        final linmasOnlyPrefixes = [
          '/main',
          '/presensi',
          '/ronda-malam',
          '/demografi',
          '/tambah-tokoh',
          '/tambah-institusi',
          '/tambah-organisasi',
          '/activation-detail',
        ];

        if (isMember && linmasOnlyPrefixes.contains(location)) {
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
      // ----------------- Common -----------------
      GoRoute(
        path: splashPath,
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: loginPath,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerPath,
        name: register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ----------------- Linmas (Officer) -----------------
      GoRoute(
        path: mainPath,
        name: main,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: profilePath,
        name: profile,
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
        builder: (context, state) => const AddTokohScreen(),
      ),
      GoRoute(
        path: tambahInstitusiPath,
        name: tambahInstitusi,
        builder: (context, state) => const AddInstitusiScreen(),
      ),
      GoRoute(
        path: tambahOrganisasiPath,
        name: tambahOrganisasi,
        builder: (context, state) => const AddOrganisasiScreen(),
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

      // ----------------- Masyarakat (Member / Dumas) -----------------
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
        builder: (context, state) => const MyComplaintHistoryPage(),
      ),
      GoRoute(
        path: '/my-complaints',
        builder: (context, state) => const MyComplaintHistoryPage(),
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

  // Helper Navigation Methods
  static void toHome(BuildContext context) {
    final authProvider = sl<AuthProvider>();
    if (authProvider.currentUser?.isMember ?? false) {
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
}
