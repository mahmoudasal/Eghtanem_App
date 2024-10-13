import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_page_transition.dart';
import 'login_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive sizing
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/photo2.webp"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(120, 0, 0, 0),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // First Text
                  Text(
                    'زكاة الوقت تأديته في مرضاة الله',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      fontSize: 23.sp,
                      color: const Color(0xFFF2EEEB),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Second Text
                  Text(
                    'استمتع بمشاهدة و سماع ما ينفعك في دنياك و اخرتك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                  SizedBox(height: 120.h),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(createRoute(const LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF94795B),
                      ),
                      child: Text(
                        'ابدأ المشاهدة',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
