import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildShareIcon(String asset, String label) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
    child: Column(
      children: [
        Center(
          child: SvgPicture.asset(
            asset,
            width: 0.1.sw,
            height: 0.12.sw,
          ),
        ),
        SizedBox(height: 0.01.sh),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 0.016.sh,
            color: const Color(0xFFFAFAFA),
          ),
        ),
      ],
    ),
  );
}
