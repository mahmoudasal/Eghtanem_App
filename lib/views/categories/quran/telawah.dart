import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Telawah extends StatelessWidget {
  final String title;
  final String imagePath;

  const Telawah({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1D1D1B),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        backgroundColor: const Color(0xff1D1D1B),
        leading: const SizedBox(width: 0.0),
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
      body: ListView(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              SizedBox(
                width: 0.08.sw,
              ),
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                radius: 25.r,
              ),
              SizedBox(
                width: 0.04.sw,
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              )
            ],
          ),
          // SizedBox(
          //   height: 0.05.sh,
          // ),
          // const TelawhCard(
          //   title: 'البقرة',
          //   surahData: {},
          // ),
          // SizedBox(
          //   height: 0.01.sh,
          // ),
          // const TelawhCard(
          //   title: 'البقرة',
          //   surahData: {},
          // ),
        ],
      ),
    );
  }
}
