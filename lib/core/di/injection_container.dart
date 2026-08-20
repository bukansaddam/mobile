import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/services/audio_recorder_service.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/services/google_speech_service.dart';

// Auth
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';

// Linmas
import 'package:akar/features/linmas/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:akar/features/linmas/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:akar/features/linmas/tracking/data/repositories/tracking_repository_impl.dart';
import 'package:akar/features/linmas/tracking/domain/repositories/tracking_repository.dart';
import 'package:akar/features/linmas/tracking/domain/usecases/send_location_usecase.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/analisis/presentation/bloc/analisis_bloc/analisis_bloc.dart';
import 'package:akar/features/linmas/panic/data/datasources/panic_remote_datasource.dart';
import 'package:akar/features/linmas/panic/data/repositories/panic_repository_impl.dart';
import 'package:akar/features/linmas/panic/domain/repositories/panic_repository.dart';
import 'package:akar/features/linmas/panic/domain/usecases/get_nearby_members_usecase.dart';
import 'package:akar/features/linmas/panic/domain/usecases/send_panic_alert_usecase.dart';
import 'package:akar/features/linmas/panic/presentation/bloc/panic_bloc/panic_bloc.dart';
import 'package:akar/features/linmas/presensi/data/datasources/presensi_remote_datasource.dart';
import 'package:akar/features/linmas/presensi/data/repositories/presensi_repository_impl.dart';
import 'package:akar/features/linmas/presensi/domain/repositories/presensi_repository.dart';
import 'package:akar/features/linmas/presensi/domain/usecases/submit_presensi_usecase.dart';
import 'package:akar/features/linmas/presensi/presentation/bloc/presensi_bloc/presensi_bloc.dart';
import 'package:akar/features/linmas/ronda_malam/data/datasources/ronda_remote_datasource.dart';
import 'package:akar/features/linmas/ronda_malam/data/repositories/ronda_repository_impl.dart';
import 'package:akar/features/linmas/ronda_malam/domain/repositories/ronda_repository.dart';
import 'package:akar/features/linmas/ronda_malam/domain/usecases/submit_ronda_laporan_usecase.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/bloc/ronda_bloc/ronda_bloc.dart';
import 'package:akar/features/linmas/demografi/data/datasources/demografi_remote_datasource.dart';
import 'package:akar/features/linmas/demografi/data/repositories/demografi_repository_impl.dart';
import 'package:akar/features/linmas/demografi/domain/repositories/demografi_repository.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_institusi_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_organisasi_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/add_tokoh_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_institusi_list_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_organisasi_list_usecase.dart';
import 'package:akar/features/linmas/demografi/domain/usecases/get_tokoh_list_usecase.dart';
import 'package:akar/features/linmas/demografi/presentation/bloc/demografi_bloc/demografi_bloc.dart';
import 'package:akar/features/linmas/bank_sampah/data/datasources/bank_sampah_local_datasource.dart';
import 'package:akar/features/linmas/bank_sampah/data/repositories/bank_sampah_repository_impl.dart';
import 'package:akar/features/linmas/bank_sampah/domain/repositories/bank_sampah_repository.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_location_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/delete_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_locations_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_reports_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';

// Masyarakat
import 'package:akar/features/masyarakat/complaint/data/datasources/location_native_datasource.dart';
import 'package:akar/features/masyarakat/complaint/data/datasources/location_remote_datasource.dart';
import 'package:akar/features/masyarakat/complaint/data/repositories/location_repository_impl.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/location_repository.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_address_from_latlng_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_current_location_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_location_suggestions_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/search_coordinates_usecase.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/location_picker_cubit.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';

// Survey
import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:akar/features/survey/data/repositories/survey_repository_impl.dart';
import 'package:akar/features/survey/domain/repositories/survey_repository.dart';
import 'package:akar/features/survey/domain/usecases/get_monthly_survey_status_usecase.dart';
import 'package:akar/features/survey/domain/usecases/get_survey_history_usecase.dart';
import 'package:akar/features/survey/domain/usecases/submit_monthly_survey_usecase.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---------------------- Core & External ----------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => DioClient.instance);
  sl.registerLazySingleton<GoogleSpeechService>(
    () => GoogleSpeechService(dio: sl()),
  );
  sl.registerLazySingleton<AudioRecorderService>(() => AudioRecorderService());
  final audioAlarmService = AudioAlarmService();
  sl.registerLazySingleton<AudioAlarmService>(() => audioAlarmService);
  sl.registerLazySingleton<DisasterAlertService>(
    () => DisasterAlertService(sl<AudioAlarmService>()),
  );

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
  sl.registerLazySingleton<PresensiRemoteDatasource>(
    () => PresensiRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<RondaRemoteDatasource>(
    () => RondaRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<DemografiRemoteDatasource>(
    () => DemografiRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<BankSampahLocalDatasource>(
    () => BankSampahLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<LocationNativeDataSource>(
    () => LocationNativeDataSourceImpl(),
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
  sl.registerLazySingleton<PresensiRepository>(
    () => PresensiRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<RondaRepository>(
    () => RondaRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<DemografiRepository>(
    () => DemografiRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<BankSampahRepository>(
    () => BankSampahRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      remoteDataSource: sl<LocationRemoteDataSource>(),
      nativeDataSource: sl<LocationNativeDataSource>(),
    ),
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
  sl.registerLazySingleton<SubmitPresensiUsecase>(
    () => SubmitPresensiUsecase(sl()),
  );
  sl.registerLazySingleton<SubmitRondaLaporanUsecase>(
    () => SubmitRondaLaporanUsecase(sl()),
  );
  sl.registerLazySingleton<GetTokohListUsecase>(
    () => GetTokohListUsecase(sl()),
  );
  sl.registerLazySingleton<AddTokohUsecase>(() => AddTokohUsecase(sl()));
  sl.registerLazySingleton<GetInstitusiListUsecase>(
    () => GetInstitusiListUsecase(sl()),
  );
  sl.registerLazySingleton<AddInstitusiUsecase>(
    () => AddInstitusiUsecase(sl()),
  );
  sl.registerLazySingleton<GetOrganisasiListUsecase>(
    () => GetOrganisasiListUsecase(sl()),
  );
  sl.registerLazySingleton<AddOrganisasiUsecase>(
    () => AddOrganisasiUsecase(sl()),
  );
  sl.registerLazySingleton<GetBankSampahReportsUsecase>(
    () => GetBankSampahReportsUsecase(sl()),
  );
  sl.registerLazySingleton<AddBankSampahReportUsecase>(
    () => AddBankSampahReportUsecase(sl()),
  );
  sl.registerLazySingleton<DeleteBankSampahReportUsecase>(
    () => DeleteBankSampahReportUsecase(sl()),
  );
  sl.registerLazySingleton<GetBankSampahLocationsUsecase>(
    () => GetBankSampahLocationsUsecase(sl()),
  );
  sl.registerLazySingleton<AddBankSampahLocationUsecase>(
    () => AddBankSampahLocationUsecase(sl()),
  );
  sl.registerLazySingleton(
    () => GetLocationSuggestionsUseCase(sl<LocationRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAddressFromLatLngUseCase(sl<LocationRepository>()),
  );
  sl.registerLazySingleton(
    () => SearchCoordinatesUseCase(sl<LocationRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCurrentLocationUseCase(sl<LocationRepository>()),
  );

  // ---------------------- BLoCs & Cubits ----------------------
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(loginUsecase: sl(), registerUsecase: sl(), repository: sl()),
  );
  sl.registerLazySingleton<TrackingBloc>(
    () => TrackingBloc(sendLocationUsecase: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<HomeBloc>(() => HomeBloc());
  sl.registerLazySingleton<ActivationBloc>(() => ActivationBloc());
  sl.registerFactory<AnalisisBloc>(() => AnalisisBloc());
  sl.registerFactory<PanicBloc>(
    () => PanicBloc(getNearbyMembersUsecase: sl(), sendPanicAlertUsecase: sl()),
  );
  sl.registerFactory<PresensiBloc>(
    () => PresensiBloc(submitPresensiUsecase: sl()),
  );
  sl.registerFactory<RondaBloc>(
    () => RondaBloc(submitRondaLaporanUsecase: sl()),
  );
  sl.registerFactory<DemografiBloc>(
    () => DemografiBloc(
      getTokohListUsecase: sl(),
      addTokohUsecase: sl(),
      getInstitusiListUsecase: sl(),
      addInstitusiUsecase: sl(),
      getOrganisasiListUsecase: sl(),
      addOrganisasiListUsecase: sl(),
    ),
  );
  sl.registerFactory<BankSampahBloc>(
    () => BankSampahBloc(
      getReportsUsecase: sl(),
      addReportUsecase: sl(),
      deleteReportUsecase: sl(),
      getLocationsUsecase: sl(),
      addLocationUsecase: sl(),
    ),
  );

  // Dumas Cubits (Factory)
  sl.registerFactory<MainCubit>(() => MainCubit());
  sl.registerFactory<LocationPickerCubit>(
    () => LocationPickerCubit(
      getLocationSuggestionsUseCase: sl<GetLocationSuggestionsUseCase>(),
      getAddressFromLatLngUseCase: sl<GetAddressFromLatLngUseCase>(),
      searchCoordinatesUseCase: sl<SearchCoordinatesUseCase>(),
      getCurrentLocationUseCase: sl<GetCurrentLocationUseCase>(),
    ),
  );

  // ---------------------- Survey ----------------------
  sl.registerLazySingleton<SurveyLocalDatasource>(
    () => SurveyLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SurveyRepository>(
    () => SurveyRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton<GetMonthlySurveyStatusUsecase>(
    () => GetMonthlySurveyStatusUsecase(sl()),
  );
  sl.registerLazySingleton<SubmitMonthlySurveyUsecase>(
    () => SubmitMonthlySurveyUsecase(sl()),
  );
  sl.registerLazySingleton<GetSurveyHistoryUsecase>(
    () => GetSurveyHistoryUsecase(sl()),
  );
  sl.registerLazySingleton<SurveyBloc>(
    () => SurveyBloc(
      getMonthlySurveyStatusUsecase: sl(),
      submitMonthlySurveyUsecase: sl(),
      getSurveyHistoryUsecase: sl(),
    ),
  );
}
