import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/prophet_speech_json.dart';

class LikedHadiths extends StatelessWidget {
  final Set<int> likedHadiths;
  final Future<List<Hadith>> allHadiths;

  const LikedHadiths({
    super.key,
    required this.likedHadiths,
    required this.allHadiths,
  });

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
          "الاحاديث المفضلة",
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 25.sp,
            height: 1.2,
            color: const Color(0xFFFAFAFA),
          ),
        ),
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
      ),
      body: FutureBuilder<List<Hadith>>(
        future: allHadiths,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 24.sp),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No hadiths found.',
                style: TextStyle(color: Colors.white, fontSize: 24.sp),
              ),
            );
          } else {
            final hadiths = snapshot.data!
                .where((hadith) => likedHadiths.contains(hadith.number))
                .toList();

            if (hadiths.isEmpty) {
              return Center(
                child: Text(
                  'No liked hadiths.',
                  style: TextStyle(color: Colors.white, fontSize: 24.sp),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                final hadith = hadiths[index];
                return Card(
                  color: const Color(0XFF171715),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          hadith.hadith,
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 18.sp,
                            color: const Color(0xFFFAFAFA),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          hadith.description,
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 16.sp,
                            color: const Color(0xFFFAFAFA),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
