import 'dart:convert';



import 'package:egtanem_application/features/quran/data/models/surah_model.dart'as surah_data;
import 'package:egtanem_application/features/quran/presentation/screens/sura_page.dart';
import 'package:egtanem_application/features/quran/data/models/qra2at_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/repositories/quran_repo.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/reciter_audio.dart';

class QuranSubCat extends StatelessWidget {
  final String title;

  const QuranSubCat({super.key, required this.title});

 

Future<List<surah_data.Surah>> fetchSurahs() async {
  try {
    final String response = await rootBundle.loadString('assets/quran_metadata/quran.json');
    final data = json.decode(response) as List;
    return data.map((json) => surah_data.Surah.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Failed to load surahs: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.primary1,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          toolbarHeight: 55.h,
          centerTitle: true,
          backgroundColor: AppColors.primary1,
          shadowColor: AppColors.primary1,
          foregroundColor: AppColors.primary1,
          title: Text(title, style: AppTextStyles.headingsH1),
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
          bottom:  TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: AppColors.primary0,
            labelColor: Color(0xFFFAFAFA),
            unselectedLabelColor: Color(0xFF888888),
            splashFactory: NoSplash.splashFactory,
            labelStyle: AppTextStyles.headingsH4,
            tabs: [
              Tab(text: 'القراءة'),
              Tab(text: 'الاستماع'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildReadingTab(context),
            buildListeningTab(),
          ],
        ),
      ),
    );
  }

 Widget buildReadingTab(BuildContext context) {
  return FutureBuilder<List<surah_data.Surah>>(
    future: fetchSurahs(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildShimmerLoading();
      } else if (snapshot.hasError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 40.sp),
              SizedBox(height: 16.h),
              Text(
                'Failed to load Quran content',
                style: AppTextStyles.headingsH3,
              ),
            ],
          ),
        );
      } else {
        return _buildSurahList(snapshot.data!);
      }
    },
  );
}

Widget _buildSurahList(List<surah_data.Surah> surahs) {
  return Padding(
    padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
    child: Directionality(textDirection: TextDirection.rtl,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: surahs.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withValues(alpha:0.1),
          height: 1.h,
        ),
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            leading: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primary0.withValues(alpha:0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                surah.number.toString(),
                style: AppTextStyles.headingsH4.copyWith(
                  color: AppColors.primary0,
                  fontFamily: 'hafs',
                ),
              ),
            ),
            title: Text(
              surah.name.ar,
              style: AppTextStyles.headingsH2.copyWith(
                color: Colors.white,
                fontFamily: 'hafs',
                
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha:0.5),
              size: 16.w,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahPage(surah: surah),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

Widget _buildShimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[800]!,
    highlightColor: Colors.grey[700]!,
    child: Padding(
      padding: EdgeInsets.only(top: 100.h, bottom: 30.h),
      child: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withValues(alpha:0.1),
          height: 1.h,
        ),
        itemBuilder: (context, index) => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          leading: CircleAvatar(radius: 20.w),
          title: Container(
            width: 100.w,
            height: 24.h,
            color: Colors.white,
          ),
          trailing: Container(
            width: 16.w,
            height: 16.w,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
  Widget buildListeningTab() {
    return FutureBuilder<List<Reciter>>(
      future: fetchReciters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Reciter> reciters = snapshot.data ?? [];
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
            children: [
              SizedBox(height: 0.02.sh),
              buildQuranCardList(reciters),
            ],
          );
        }
      },
    );
  }

  Widget buildQuranCardList(List<Reciter> reciters) {
    return Column(
      children: List.generate(
        reciters.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 0.01.sh),
          child: ReciterSurahs(
            title: reciters[index].name,
            reciterId: reciters[index].id,
            serverUrl: reciters[index]
                .moshaf[0]
                .server, // Use the server from the desired moshaf
          ),
        ),
      ),
    );
  }
}
