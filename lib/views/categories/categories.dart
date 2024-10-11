import 'package:egtanem_application/cubits/prophet_stories/prophet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/categories_card.dart';

import 'duah_zikr/duah_zikr.dart';
import 'prophets_stories.dart';

import 'tafseer/tafseer.dart';
import 'hadith/hadith.dart';
import 'prophetic_biography.dart';
import 'quran/quran.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoPlayerCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff1D1D1B),
        appBar: AppBar(
          toolbarHeight: 100.h,
          centerTitle: true,
          backgroundColor: const Color(0xff1D1D1B),
          title: Text(
            "التصنيفات",
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 25.sp,
              height: 1.2,
              color: const Color(0xFFFAFAFA),
            ),
          ),
        ),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.h,
            crossAxisCount: 2,
          ),
          children: <Widget>[
            CustomCard(
              imagePath: 'assets/احاديث.webp',
              cardName: 'أحاديث',
              pageBuilder: () => const Prophetspeech(),
            ),
            CustomCard(
              imagePath: 'assets/المصحف.webp',
              cardName: 'قرآن كريم',
              pageBuilder: () => const QuranSubCat(
                title: 'قرآن كريم',
              ),
            ),
            CustomCard(
              imagePath: 'assets/السيره النبويه.webp',
              cardName: 'السيرة النبوية',
              pageBuilder: () => const PropheticBiography(),
            ),
            CustomCard(
              imagePath: 'assets/عقيده.webp',
              cardName: 'التفسير',
              pageBuilder: () => const Tafseer(),
            ),
            CustomCard(
              imagePath: 'assets/الأخلاق الإسلامية.webp',
              cardName: 'قصص الانبياء',
              pageBuilder: () => const ProphetsStories(),
            ),
            CustomCard(
              imagePath: 'assets/الأدعية والأذكار.webp',
              cardName: 'الأدعية والأذكار',
              pageBuilder: () => const SupplicationsRemembrances(),
            ),
          ],
        ),
      ),
    );
  }
}
