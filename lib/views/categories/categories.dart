import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
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
    return Container(
      decoration: BoxDecoration(color: AppColors.primary1),
      child: GridView(
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
    );
  }
}
