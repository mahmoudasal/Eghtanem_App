import 'package:egtanem_application/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/hadith_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/hadith_cubit.dart';

class LikedHadiths extends StatefulWidget {
  final Set<int> likedHadiths;
  final Future<List<Hadith>> allHadiths;

  const LikedHadiths({
    super.key,
    required this.likedHadiths,
    required this.allHadiths, // ✅ Fix: Ensure this parameter exists
  });

  @override
  LikedHadithsState createState() => LikedHadithsState();
}

class LikedHadithsState extends State<LikedHadiths> {
  late Set<int> likedHadiths;
  late Future<List<Hadith>> allHadiths;

  @override
  void initState() {
    super.initState();
    allHadiths = context.read<HadithCubit>().loadAllHadiths();
    _loadLikedHadiths();
  }

  Future<void> _loadLikedHadiths() async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList('likedHadiths');
    setState(() {
      likedHadiths = liked?.map(int.parse).toSet() ?? {};
    });
  }

  void _toggleLike(int hadithNumber) async {
    setState(() {
      if (likedHadiths.contains(hadithNumber)) {
        likedHadiths.remove(hadithNumber);
      } else {
        likedHadiths.add(hadithNumber);
      }
    });

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
        title: Text("الأحاديث المفضلة", style: AppTextStyles.headingsH1),
        leading: const SizedBox(width: 0.0),
        actions: [
         Constants.backButton(context)
        ],
      ),
      body: FutureBuilder<List<Hadith>>(
        future: allHadiths,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: AppTextStyles.headingsH3),
            );
          }

          final hadiths = snapshot.data
                  ?.where((h) => likedHadiths.contains(h.number))
                  .toList() ??
              [];

          if (hadiths.isEmpty) {
            return Center(
              child:
                  Text('لا يوجد أحاديث مفضلة', style: AppTextStyles.headingsH2),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              likedHadiths.contains(hadith.number)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: likedHadiths.contains(hadith.number)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => _toggleLike(hadith.number),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        hadith.hadith,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.headingsH4.copyWith(height: 1.8),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        hadith.description,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.headingsH5.copyWith(height: 1.8),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
