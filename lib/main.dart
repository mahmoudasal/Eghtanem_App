import 'dart:async';

import 'package:egtanem_application/views/onboarding_one.dart';
import 'package:egtanem_application/views/onboarding_two.dart';
import 'package:egtanem_application/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:egtanem_application/injection.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/login_cuibit.dart';
import 'package:egtanem_application/features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'package:egtanem_application/features/video/presentation/cubit/video_cubit.dart';
import 'package:egtanem_application/features/auth/presentation/screens/login_page.dart';
import 'package:egtanem_application/features/home/presentation/screens/navigation_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

 
  runApp(const MyApp());

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
   
  };

  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stackTrace) {
    },
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
          initialRoute: "/page_one",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "/page_one":
                return createRoute(const FirstPage());
              case "/page_two":
                return createRoute(const SecondPage());
              case "/page_three":
                return createRoute(
                  BlocProvider(
                    create: (context) => getIt<LoginCubit>(),
                    child: const LoginPage(),
                  ),
                );
              case "/page_4":
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
          },
        );
      },
    );
  }
}
