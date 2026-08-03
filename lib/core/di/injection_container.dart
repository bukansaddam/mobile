import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/home/presentation/provider/home_provider.dart';
import 'package:akar/features/panic/data/datasources/panic_remote_datasource.dart';
import 'package:akar/features/panic/data/repositories/panic_repository_impl.dart';
import 'package:akar/features/panic/domain/repositories/panic_repository.dart';
import 'package:akar/features/panic/domain/usecases/get_nearby_members_usecase.dart';
import 'package:akar/features/panic/domain/usecases/send_panic_alert_usecase.dart';
import 'package:akar/features/panic/presentation/provider/panic_provider.dart';
import 'package:akar/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:akar/features/tracking/data/repositories/tracking_repository_impl.dart';
import 'package:akar/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:akar/features/tracking/domain/usecases/send_location_usecase.dart';
import 'package:akar/features/tracking/presentation/provider/tracking_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---------------------- Core & External ----------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  // ---------------------- Data Sources ----------------------
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<TrackingRemoteDatasource>(
    () => TrackingRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<PanicRemoteDatasource>(
    () => PanicRemoteDatasourceImpl(),
  );

  // ---------------------- Repositories ----------------------
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl(), localDatasource: sl()),
  );
  sl.registerLazySingleton<TrackingRepository>(
    () => TrackingRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<PanicRepository>(
    () => PanicRepositoryImpl(remoteDatasource: sl()),
  );

  // ---------------------- Use Cases ----------------------
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(sl()));
  sl.registerLazySingleton<SendLocationUsecase>(
    () => SendLocationUsecase(sl()),
  );
  sl.registerLazySingleton<GetNearbyMembersUsecase>(
    () => GetNearbyMembersUsecase(sl()),
  );
  sl.registerLazySingleton<SendPanicAlertUsecase>(
    () => SendPanicAlertUsecase(sl()),
  );

  // ---------------------- Providers ----------------------
  sl.registerLazySingleton<AuthProvider>(
    () => AuthProvider(
      loginUsecase: sl(),
      registerUsecase: sl(),
      repository: sl(),
    ),
  );
  sl.registerLazySingleton<HomeProvider>(() => HomeProvider());
  sl.registerLazySingleton<TrackingProvider>(
    () => TrackingProvider(sendLocationUsecase: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ActivationProvider>(() => ActivationProvider());
  sl.registerLazySingleton<PanicProvider>(
    () => PanicProvider(
      getNearbyMembersUsecase: sl(),
      sendPanicAlertUsecase: sl(),
    ),
  );
}
