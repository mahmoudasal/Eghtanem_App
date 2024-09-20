import 'package:egtanem_application/cubits/prophet_stories/prophet_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'views/login_page.dart';
import 'views/first_page.dart';
import 'views/nav_screen.dart';
import 'views/sec_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
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
        return MultiBlocProvider(
          providers: [
            BlocProvider<VideoPlayerCubit>(
              create: (BuildContext context) => VideoPlayerCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const FirstPage(),
            routes: {
              "/page_one": (context) => const FirstPage(),
              "/page_two": (context) => const SecondPage(),
              "/page_three": (context) => LoginPage(),
              "/page_4": (context) => const NaviagionScreen(youtubeData: {}),
            },
          ),
        );
      },
    );
  }
}
