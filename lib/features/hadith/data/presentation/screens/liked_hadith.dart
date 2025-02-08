import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/hadith_model.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class LikedHadiths extends StatefulWidget {
  final Set<int> likedHadiths;
  final Future<List<Hadith>> allHadiths;

  const LikedHadiths({
    super.key,
    required this.likedHadiths,
    required this.allHadiths,
  });

  @override
  LikedHadithsState createState() => LikedHadithsState();
}

class LikedHadithsState extends State<LikedHadiths> {
  late Set<int> likedHadiths;

  @override
  void initState() {
    super.initState();
    likedHadiths = widget.likedHadiths;
  }

  // Toggle the liked state of a hadith
  void _toggleLike(int hadithNumber) async {
    setState(() {
      if (likedHadiths.contains(hadithNumber)) {
        likedHadiths.remove(hadithNumber);
      } else {
        likedHadiths.add(hadithNumber);
      }
    });

    // Save the updated likedHadiths to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'likedHadiths', likedHadiths.map((e) => e.toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primary1,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        centerTitle: true,
        backgroundColor: AppColors.primary1,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        title: Text(
          "الاحاديث المفضلة",
          style: AppTextStyles.headingsH1,
        ),
        leading: const SizedBox(width: 0.0),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/icons/BackButton.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 35.w),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Hadith>>(
        future: widget.allHadiths,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style:AppTextStyles.headingsH3,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'هناك مشكله الرجاء التواصل مع المطور',
                style: AppTextStyles.headingsH3,
              ),
            );
          } else {
            final hadiths = snapshot.data!
                .where((hadith) => likedHadiths.contains(hadith.number))
                .toList();

            if (hadiths.isEmpty) {
              return Center(
                child: Text(
                  'لا يوجد احاديث مفضلة',
                  style: AppTextStyles.headingsH2,
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                final hadith = hadiths[index];
                final isLiked = likedHadiths.contains(hadith.number);
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
                        // Like button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleLike(hadith.number),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          textDirection: TextDirection.rtl,
                          hadith.hadith,
                          style: AppTextStyles.headingsH4
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          textDirection: TextDirection.rtl,
                          hadith.description,
                          style: AppTextStyles.headingsH5
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
