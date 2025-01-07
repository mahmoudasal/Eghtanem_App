import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildIconWithText({
  required String icon,
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    child: Column(
      children: [
        SvgPicture.asset(
          icon,
          width: 30.w,
          height: 32.h,
        ),
        SizedBox(height: 7.h),
      ],
    ),
  );
}
