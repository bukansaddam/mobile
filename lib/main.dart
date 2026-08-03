import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:akar/features/panic/presentation/provider/panic_provider.dart';
import 'package:akar/features/presensi/presentation/provider/presensi_provider.dart';
import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/services/background_service_helper.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/home/presentation/provider/home_provider.dart';
import 'package:akar/features/tracking/presentation/provider/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<TrackingProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ActivationProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<PanicProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<PresensiProvider>()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
