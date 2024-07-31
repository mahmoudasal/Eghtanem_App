import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildIconWithText({
  required String icon,
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        SvgPicture.asset(
          icon,
          width: 30.w,
          height: 32.h,
        ),
        SizedBox(height: 7.h),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            height: 1.2,
            color: const Color(0xFFFAFAFA),
          ),
        ),
      ],
    ),
  );
}
