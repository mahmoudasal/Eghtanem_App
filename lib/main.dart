import 'dart:async';

import 'package:eghtanem_app/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/routes.dart';
import 'core/utilities/logger.dart';
import 'injection.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await setupDependencies();

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      runApp(const MyApp());
    },
    (error, stackTrace) {
      AppLogger.e('Uncaught error', error, stackTrace);
    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eghtanem',
          initialRoute: Routes.pageOne,
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
