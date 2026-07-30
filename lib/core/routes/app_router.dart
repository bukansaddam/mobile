import 'package:akar/features/auth/presentation/pages/login_screen.dart';
import 'package:akar/features/auth/presentation/pages/profile_screen.dart';
import 'package:akar/features/auth/presentation/pages/register_screen.dart';
import 'package:akar/features/home/presentation/pages/home_screen.dart';
import 'package:akar/features/home/presentation/pages/setting_screen.dart';
import 'package:akar/features/splash/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/features/home/presentation/pages/map_tracking_screen.dart';

import 'package:akar/features/activation/presentation/pages/activation_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
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
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'setting',
            name: 'setting',
            builder: (context, state) => const SettingScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/map-tracking',
        name: 'map_tracking',
        builder: (context, state) => const MapTrackingScreen(),
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
