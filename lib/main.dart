import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/routes.dart';
import 'core/utilities/logger.dart';
import 'features/auth/presentation/cubit/login_cuibit.dart';
import 'features/auth/presentation/screens/login_page.dart';
import 'features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'features/home/presentation/screens/navigation_page.dart';
import 'features/video/presentation/cubit/video_cubit.dart';
import 'injection.dart';
import 'views/onboarding_one.dart';
import 'views/onboarding_two.dart';
import 'widgets/custom_page_transition.dart';

/// Main entry point of the application.
/// Initializes dependencies, sets up system UI, and runs the app.
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
      // Handle any uncaught errors here
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
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.pageOne:
        return createRoute(const FirstPage());
      case Routes.pageTwo:
        return createRoute(const SecondPage());
      case Routes.pageThree:
        return createRoute(
          BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginPage(),
          ),
        );
      case Routes.pageFour:
        return createRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<NavigationCubit>()),
              BlocProvider(create: (_) => getIt<VideoCubit>()),
            ],
            child: const AppNavigationBar(),
          ),
        );
      default:
        return createRoute(const FirstPage());
    }
  }
}
