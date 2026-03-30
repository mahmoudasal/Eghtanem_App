import 'dart:async';

import 'package:eghtanem_app/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eghtanem_app/core/config/app_config.dart';
import 'package:eghtanem_app/core/constants/routes.dart';
import 'package:eghtanem_app/core/utilities/logger.dart';
import 'package:eghtanem_app/injection.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Global Flutter-framework error handler — inside the guarded zone.
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);
        AppLogger.e(
            'Flutter framework error', details.exception, details.stack);
      };

      // Resolve environment from compile-time --dart-define=ENV=<value>.
      AppConfig.init();

      await setupDependencies();

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      runApp(const MyApp());
    },
    (error, stackTrace) {
      AppLogger.e('Uncaught error', error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eghtanem',
          initialRoute: Routes.onboardingOne,
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
