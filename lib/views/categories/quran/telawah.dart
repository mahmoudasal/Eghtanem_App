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
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
            SizedBox(width: 35.w),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 0.08.sw, vertical: 20.h),
      children: [
        _buildHeader(),
        // Add your TelawhCard widgets here when needed
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 25.r,
        ),
        SizedBox(width: 0.04.sw),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 24.sp,
            color: const Color(0xFFFAFAFA),
          ),
        ),
      ],
    );
  }
}
