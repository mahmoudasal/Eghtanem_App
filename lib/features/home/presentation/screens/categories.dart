import 'package:eghtanem_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/features/home/presentation/widgets/categories_card.dart';

import 'package:eghtanem_app/features/dhikr/presentation/screens/duah_zikr_page.dart';
import 'package:eghtanem_app/features/categories/prophets_stories.dart';

import 'package:eghtanem_app/features/tafseer/presentation/screens/tafseer_screen.dart';
import 'package:eghtanem_app/features/hadith/presentation/screens/hadith.dart';
import 'package:eghtanem_app/features/categories/prophetic_biography.dart';
import 'package:eghtanem_app/features/quran/presentation/screens/quran.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary1,
      appBar: AppBar(
        backgroundColor: AppColors.primary1,
        toolbarHeight: 100,
        title: Text(
          'اغتنم وقتك',
          style: AppTextStyles.headingsH2,
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 9.w,
          mainAxisSpacing: 9.h,
          crossAxisCount: 2,
        ),
        children: <Widget>[
          CustomCard(
            imagePath: 'assets/cards_photos/احاديث.webp',
            cardName: 'أحاديث',
            pageBuilder: () => const Hadith(),
          ),
          CustomCard(
            imagePath: 'assets/cards_photos/المصحف.webp',
            cardName: 'قرآن كريم',
            pageBuilder: () => const QuranSubCat(
              title: 'قرآن كريم',
            ),
          ),
          CustomCard(
            imagePath: 'assets/cards_photos/السيره النبويه.webp',
            cardName: 'السيرة النبوية',
            pageBuilder: () => const PropheticBiography(),
          ),
          CustomCard(
            imagePath: 'assets/cards_photos/عقيده.webp',
            cardName: 'التفسير',
            pageBuilder: () => const TafseerScreen(),
          ),
          CustomCard(
            imagePath: 'assets/cards_photos/الأخلاق الإسلامية.webp',
            cardName: 'قصص الانبياء',
            pageBuilder: () => const ProphetsStories(),
          ),
          CustomCard(
            imagePath: 'assets/cards_photos/الأدعية والأذكار.webp',
            cardName: 'الأدعية والأذكار',
            pageBuilder: () => const SupplicationsRemembrances(),
          ),
        ],
      ),
    );
  }
}
