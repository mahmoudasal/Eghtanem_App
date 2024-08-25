import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropheticBiography extends StatelessWidget {
  const PropheticBiography({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff1D1D1B),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        centerTitle: true,
        backgroundColor: const Color(0xff1D1D1B),
        shadowColor: const Color(0xff1D1D1B),
        foregroundColor: const Color(0xff1D1D1B),
        title: Text(
          "السيرة النبوية",
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 25.sp,
            height: 1.2,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        // No leading widget (empty space)
        leading: const SizedBox(width: 0.0),
        // Custom back button on the right using actions
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(
                width: 35.w,
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(
          ' ... سيتم الاضافه قريبا',
          style: TextStyle(color: Colors.white, fontSize: 24.sp),
        ),
      ),
    );
  }
}
