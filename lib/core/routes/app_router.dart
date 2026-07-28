import 'package:akar/features/home/presentation/pages/home_screen.dart';
import 'package:akar/features/home/presentation/pages/setting_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'initial',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'setting',
            name: 'setting',
            builder: (context, state) => const SettingScreen(),
          ),
        ],
      ),
    ],
  );
}
