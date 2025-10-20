import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/core/theme/app_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  const AppTextStyles._(); // private constructor to not be able to get instance of it

  // Base headings with white color
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

  // Error style
  static TextStyle errorStyle = TextStyle(
      fontSize: 18.sp,
      fontFamily: AppFonts.almarai,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.4,
      color: Colors.redAccent);

  // Hafs font styles for Quran text
  static TextStyle quranTextStyle = TextStyle(
    fontSize: 22.sp,
    fontFamily: AppFonts.hafs,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.8,
    color: Colors.white,
  );

  // Common variations with different colors and parameters
  static TextStyle headingsH1White54 = TextStyle(
    fontSize: 24.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white54,
  );

  static TextStyle headingsH2White54 = TextStyle(
    fontSize: 22.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white54,
  );

  static TextStyle headingsH3White54 = TextStyle(
    fontSize: 20.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white54,
  );

  static TextStyle headingsH3Primary = TextStyle(
    fontSize: 20.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.primary0,
  );

  static TextStyle headingsH4HigherHeight = TextStyle(
    fontSize: 18.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.8,
    color: Colors.white,
  );

  static TextStyle headingsH5HigherHeight = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.8,
    color: Colors.white,
  );

  static TextStyle headingsH6White54 = TextStyle(
    fontSize: 14.sp,
    fontFamily: AppFonts.almarai,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white54,
  );

  // Quran-specific styles
  static TextStyle quranH2 = TextStyle(
    fontSize: 22.sp,
    fontFamily: AppFonts.hafs,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: Colors.white,
  );

  static TextStyle quranH4Primary = TextStyle(
    fontSize: 18.sp,
    fontFamily: AppFonts.hafs,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.primary0,
  );
}
