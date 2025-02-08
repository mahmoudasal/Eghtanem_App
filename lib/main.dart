import 'package:egtanem_application/features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'package:egtanem_application/features/video/presentation/cubit/video_cubit.dart';
import 'package:egtanem_application/views/onboarding_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:egtanem_application/injection.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/login_cuibit.dart';
import 'package:egtanem_application/features/auth/presentation/screens/login_page.dart';
import 'package:egtanem_application/views/onboarding_one.dart';
import 'package:egtanem_application/features/home/presentation/screens/navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  void logFlutterError(FlutterErrorDetails details) {
    debugPrint('M.a.H.m.O.u.D Flutter Error: ${details.exception}');
    debugPrint('M.a.H.m.O.u.D Stack trace: ${details.stack}');
  }

  void logDartError(Object error, StackTrace stackTrace) {
    debugPrint('M.a.H.m.O.u.D Dart Error: $error');
    debugPrint('M.a.H.m.O.u.D Stack trace: $stackTrace');
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    logFlutterError(details);
  };

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Design size for responsiveness
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const FirstPage(),
          routes: {
            "/page_one": (context) => const FirstPage(),
            "/page_two": (context) => const SecondPage(),
            "/page_three": (context) => BlocProvider(
                  create: (context) => getIt<LoginCubit>(),
                  child: const LoginPage(),
                ),
            "/page_4": (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => getIt<NavigationCubit>()),
                    BlocProvider(create: (_) => getIt<VideoCubit>()),
                  ],
                  child: const AppNavigationBar(),
                ),
          },
        );
      },
    );
  }
}
