import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_user_usecase.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:akar/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/tracking/domain/repositories/tracking_repository.dart';
import 'package:akar/features/linmas/tracking/domain/usecases/send_location_usecase.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/splash/presentation/pages/splash_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository extends Fake implements AuthRepository {
  @override
  Future<Either<Failure, String?>> getSavedToken() async => const Right(null);

  @override
  Future<Either<Failure, UserEntity?>> getSavedUser() async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> logout() async => const Right(null);
}

class _FakeTrackingRepository extends Fake implements TrackingRepository {}

class _FakeBackgroundService extends Fake implements FlutterBackgroundService {
  @override
  Future<bool> isRunning() async => false;

  @override
  void invoke(String method, [Map<String, dynamic>? arg]) {}

  @override
  Stream<Map<String, dynamic>?> on(String method) => const Stream.empty();
}

void main() {
  testWidgets(
    'SplashScreen renders version label and navigates to welcome when unauthenticated',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final authRepo = _FakeAuthRepository();
      final authBloc = AuthBloc(
        loginUsecase: LoginUsecase(authRepo),
        registerUsecase: RegisterUsecase(authRepo),
        getSavedUserUsecase: GetSavedUserUsecase(authRepo),
        getSavedTokenUsecase: GetSavedTokenUsecase(authRepo),
        logoutUsecase: LogoutUsecase(authRepo),
        refreshTokenUsecase: RefreshTokenUsecase(authRepo),
      );
      final trackingBloc = TrackingBloc(
        sendLocationUsecase: SendLocationUsecase(_FakeTrackingRepository()),
        sharedPreferences: prefs,
        isDebugMode: false,
        backgroundService: _FakeBackgroundService(),
      );
      addTearDown(authBloc.close);
      addTearDown(trackingBloc.close);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
          GoRoute(
            path: '/welcome',
            name: AppRouter.welcome,
            builder: (_, _) => const Scaffold(body: Text('Welcome Screen')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<TrackingBloc>.value(value: trackingBloc),
          ],
          child: MaterialApp.router(
            theme: AppTheme.lightTheme,
            routerConfig: router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
          ),
        ),
      );

      expect(find.text('v${AppConstants.appVersion}'), findsOneWidget);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pump();

      expect(find.text('Welcome Screen'), findsOneWidget);
    },
  );
}
