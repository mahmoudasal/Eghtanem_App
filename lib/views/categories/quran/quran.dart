import 'package:egtanem_application/models/qra2at_json_parse.dart';
import 'package:egtanem_application/models/surah_json_parse.dart' as surah_data;
import 'package:egtanem_application/widgets/surah_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/quran_logic.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/reciter_audio.dart';

class QuranSubCat extends StatelessWidget {
  final String title;

  const QuranSubCat({super.key, required this.title});

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
          title: Text(title, style: AppTextSytle.headingsH1),
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
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: AppColors.primary0,
            labelColor: Color(0xFFFAFAFA),
            unselectedLabelColor: Color(0xFF888888),
            splashFactory: NoSplash.splashFactory,
            labelStyle: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFFFAFAFA),
            ),
            tabs: [
              Tab(text: 'القراءه'),
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
      future: surah_data.loadSurahInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<surah_data.Surah> surahDetails = snapshot.data ?? [];
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
            itemCount: surahDetails.length,
            itemBuilder: (context, index) {
              final surah = surahDetails[index];
              return Column(
                children: [
                  SizedBox(height: 0.02.sh),
                  SurahCard(
                    title: surah.titleAr,
                    surahId: surah.index,
                    page: surah.page, // Pass the page number
                  ),
                ],
              );
            },
          );
        }
      },
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
