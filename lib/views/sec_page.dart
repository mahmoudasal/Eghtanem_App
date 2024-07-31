import 'dart:ui' as ui;

import 'package:egtanem_application/views/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_page_transition.dart';
import 'login_page.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});
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
                image: AssetImage('assets/photo2.jpeg'),
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
                    const Color.fromARGB(120, 0, 0, 0),
                    Colors.black.withOpacity(0.9999),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 0.53.sh,
                width: 1.sw,
              ),
              Text(
                'تابع القنوات الدينية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 25.sp,
                  color: const Color(0xFFF2EEEB),
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              Text(
                'استمتع بمشاهدة فيديوهات قصيرة ومفيدة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 25.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              SizedBox(
                height: 0.22.sh,
              ),
              SizedBox(
                width: 0.9.sw,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(createRoute(const LoginPage()));
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
            ],
          ),
        ],
      ),
    );
  }
}
