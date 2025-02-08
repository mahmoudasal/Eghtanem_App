import 'package:egtanem_application/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  const AppTextStyles._(); // private constructor to not be able to get instance of it
  static TextStyle headingsH1 = TextStyle(
    fontSize: 24.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );
  static TextStyle headingsH2 = TextStyle(
    fontSize: 22.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );
  static TextStyle headingsH3 = TextStyle(
    fontSize: 20.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );
  static TextStyle headingsH4 = TextStyle(
    fontSize: 18.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );
  static TextStyle headingsH5 = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );
  static TextStyle headingsH6 = TextStyle(
    fontSize: 14.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );
  static TextStyle headingsH7 = TextStyle(
    fontSize: 12.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );
  static TextStyle errorStyle = TextStyle(
    fontSize: 18.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.redAccent
  );
}
