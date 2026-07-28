import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---------------------- Core & External ----------------------
  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  // ---------------------- Features ----------------------
  // Feature dependencies (Data Sources, Repositories, Use Cases, Providers)
  // will be registered here as new features are implemented.
}
