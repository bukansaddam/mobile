import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/services/background_service_helper.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/core/di/injection_container.dart' as di;
import 'package:akar/core/routes/app_router.dart';

import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/analisis/presentation/bloc/analisis_bloc/analisis_bloc.dart';
import 'package:akar/features/linmas/panic/presentation/bloc/panic_bloc/panic_bloc.dart';
import 'package:akar/features/linmas/presensi/presentation/bloc/presensi_bloc/presensi_bloc.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/bloc/ronda_bloc/ronda_bloc.dart';
import 'package:akar/features/linmas/demografi/presentation/bloc/demografi_bloc/demografi_bloc.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await di.init();
  await BackgroundServiceHelper.initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<HomeBloc>(create: (_) => di.sl<HomeBloc>()),
        BlocProvider<TrackingBloc>(create: (_) => di.sl<TrackingBloc>()),
        BlocProvider<ActivationBloc>(create: (_) => di.sl<ActivationBloc>()),
        BlocProvider<AnalisisBloc>(create: (_) => di.sl<AnalisisBloc>()),
        BlocProvider<PanicBloc>(create: (_) => di.sl<PanicBloc>()),
        BlocProvider<PresensiBloc>(create: (_) => di.sl<PresensiBloc>()),
        BlocProvider<RondaBloc>(create: (_) => di.sl<RondaBloc>()),
        BlocProvider<DemografiBloc>(create: (_) => di.sl<DemografiBloc>()),
        BlocProvider<BankSampahBloc>(create: (_) => di.sl<BankSampahBloc>()),
        BlocProvider<MainCubit>(create: (_) => di.sl<MainCubit>()),
        BlocProvider<SurveyBloc>(create: (_) => di.sl<SurveyBloc>()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child,
          );
        },
      ),
    );
  }
}
