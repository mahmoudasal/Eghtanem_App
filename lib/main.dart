import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'views/login_page.dart';
import 'views/first_page.dart';
import 'views/main_screen.dart';
import 'views/sec_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      designSize: const Size(360, 690), // Set the design size here
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) {
              precacheImage(const AssetImage('assets/profileBG.png'), context);
              precacheImage(
                  const AssetImage('assets/bilal profile photo.png'), context);

              return const Onboarding();
            },
          ),
          getPages: [
            GetPage(name: "/page_one", page: (() => const Onboarding())),
            GetPage(name: "/page_two", page: (() => const Onboarding2())),
            GetPage(name: "/page_three", page: (() => const LoginPage())),
            GetPage(name: "/page_4", page: (() => const ShortsScreen())),
          ],
        );
      },
    );
  }
}
