import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/categories_card.dart';

import 'supplications_&_remembrances.dart';
import 'islamic _ethics.dart';

import 'interpretation/interpretation.dart';
import 'prophet_speech.dart';
import 'prophetic_biography.dart';
import 'quran/quran.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            pageBuilder: () => const Faith(),
          ),
          CustomCard(
            imagePath: 'assets/الأخلاق الإسلامية.webp',
            cardName: 'الأخلاق الإسلامية',
            pageBuilder: () => const IslamicEthics(),
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
