import 'package:akar/features/home/presentation/provider/home_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---------------------- Core & External ----------------------
  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  // ---------------------- Providers ----------------------
  sl.registerLazySingleton<HomeProvider>(() => HomeProvider());
}
