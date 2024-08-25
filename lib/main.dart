import 'package:egtanem_application/cubits/video_player_cubit/video_player_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'views/login_page.dart';
import 'views/first_page.dart';
import 'views/nav_screen.dart';
import 'views/sec_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Set the design size here
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => VideoPlayerCubit(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FutureBuilder<bool>(
              future: _isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == true) {
                  return const NaviagionScreen(
                      youtubeData: {}); // User is logged in, skip to Shorts page
                } else {
                  return const FirstPage(); // User is not logged in, show onboarding
                }
              },
            ),
            routes: {
              "/page_one": (context) => const FirstPage(),
              "/page_two": (context) => const SecondPage(),
              "/page_three": (context) => LoginPage(),
              "/page_4": (context) => const NaviagionScreen(
                    youtubeData: {},
                  ),
            },
          ),
        );
      },
    );
  }
}
