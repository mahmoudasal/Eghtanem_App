import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:egtanem_application/views/categories/quran/sura_page.dart';
import 'package:flutter_svg/svg.dart';

import 'custom_page_transition.dart';

class SurahCard extends StatelessWidget {
  final String title;
  final String surahId;
  final String page;

  const SurahCard({
    super.key,
    required this.title,
    required this.surahId,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.055.sw),
          tileColor: const Color(0XFF171715),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 0.02.sh,
              color: const Color(0xFFFAFAFA),
            ),
          ),
          trailing: SvgPicture.asset(
            "assets/ui icons/open-book.svg",
            height: 30,
            width: 10,
          ),
          onTap: () {
            Navigator.push(
              context,
              createRoute(
                SurahPage(initialPage: page), // Pass the initial page
              ),
            );
          },
        ),
      ),
    );
  }
}
