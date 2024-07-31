import 'package:egtanem_application/widgets/build_share_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showShareBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 46, 46, 46),
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: 0.22.sh,
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            Text(
              "مشاركة عبر",
              style: TextStyle(
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: const Color(0xFFFAFAFA),
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: 1.sw,
              height: 0.09.sh,
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  // Example assets and labels
                  final List<String> assets = [
                    'assets/ui icons/facebook.svg',
                    'assets/ui icons/twitter.svg',
                    'assets/ui icons/instagram.svg',
                    'assets/ui icons/WhatsApp Logo.svg',
                    'assets/ui icons/tiktok.svg',
                    'assets/ui icons/facebook.svg',
                    'assets/ui icons/linkedin.svg',
                  ];
                  final List<String> labels = [
                    'فيسبوك',
                    'تويتر',
                    'إنستجرام',
                    'واتساب',
                    'تيك توك', 'فيسبوك', 'لينكد ان',

                    // Add more labels here
                  ];

                  return buildShareIcon(
                    assets[index % assets.length],
                    labels[index % labels.length],
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
