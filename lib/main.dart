// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'views/first_page.dart';
import 'views/login_page.dart';
import 'views/nav_screen.dart';
import 'views/sec_page.dart';

void main() async {
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize secure storage
    const storage = FlutterSecureStorage();
    await storage.deleteAll(); // Optional: Clear storage for testing

    // Configure system UI
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    runApp(const MyApp());
  } catch (e) {
    print("Application initialization failed: $e");
    runApp(const MyApp());
  }
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const FirstPage(),
          routes: {
            "/page_one": (context) => const FirstPage(),
            "/page_two": (context) => const SecondPage(),
            "/page_three": (context) => const LoginPage(),
            "/page_4": (context) => const NavigationScreen(
                  youtubeData: {},
                ), // Removed Map
          },
        );
      },
    );
  }
}
