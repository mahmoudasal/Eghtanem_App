// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'views/first_page.dart';
import 'views/login_page.dart';
import 'views/nav_screen.dart';
import 'views/sec_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "assets/.env");

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize the Cubits

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Design size for responsiveness
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: const [],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const FirstPage(),
            routes: {
              "/page_one": (context) => const FirstPage(),
              "/page_two": (context) => const SecondPage(),
              "/page_three": (context) => const LoginPage(),
              "/page_4": (context) => const NavigationScreen(youtubeData: {}),
            },
          ),
        );
      },
    );
  }
}
