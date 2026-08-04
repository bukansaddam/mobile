import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/activation/presentation/pages/activation_detail_screen.dart';
import 'package:akar/features/auth/presentation/pages/login_screen.dart';
import 'package:akar/features/panic/presentation/pages/panic_screen.dart';
import 'package:akar/features/presensi/presentation/pages/presensi_screen.dart';
import 'package:akar/features/ronda_malam/presentation/pages/ronda_screen.dart';
import 'package:akar/features/main/presentation/pages/main_screen.dart';
import 'package:akar/features/auth/presentation/pages/register_screen.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/splash/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: sl<AuthProvider>(),
    redirect: (context, state) {
      final authProvider = sl<AuthProvider>();

      if (authProvider.isInitialChecking) {
        return null;
      }

      final isLoggedIn = authProvider.isLoggedIn;
      final location = state.matchedLocation;

      final isSplash = location == '/';
      final isAuthRoute = location == '/login' || location == '/register';

      if (!isLoggedIn && !isAuthRoute && !isSplash) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/main';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/panic',
        name: 'panic',
        builder: (context, state) => const PanicScreen(),
      ),
      GoRoute(
        path: '/presensi',
        name: 'presensi',
        builder: (context, state) => const PresensiScreen(),
      ),
      GoRoute(
        path: '/ronda-malam',
        name: 'ronda_malam',
        builder: (context, state) => const RondaScreen(),
      ),
      GoRoute(
        path: '/activation-detail',
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
    ],
  );
}
