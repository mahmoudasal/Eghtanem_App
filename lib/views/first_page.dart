import 'dart:ui' as ui;

import 'package:egtanem_application/views/profile.dart';
import 'package:egtanem_application/views/sec_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_page_transition.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});
  Future<ui.Image> _loadImage(String path) async {
    try {
      return await imageAssets.load(path);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading image: $e");
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/photo1.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(80, 0, 0, 0),
                    Colors.black.withOpacity(0.999),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '!مرحباً بك في إغتنم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Almarai",
                  fontWeight: FontWeight.w800,
                  fontSize: 24.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              SizedBox(height: 13.h),
              Text(
                'اكتشف فيديوهات دينية مُلهمة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Almarai",
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              SizedBox(height: 0.17.sh),
              SizedBox(
                width: 0.9.sw,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(createRoute(const Onboarding2()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF94795B),
                  ),
                  child: Text(
                    'إستمرار',
                    style: TextStyle(
                      fontFamily: "Almarai",
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }
}
