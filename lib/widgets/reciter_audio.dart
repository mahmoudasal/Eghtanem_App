import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../views/categories/quran/listen_page.dart';
import '../views/categories/quran/quran.dart';
import 'custom_page_transition.dart';

class ReciterSurahs extends StatelessWidget {
  final String title;
  final String serverUrl;
  final int reciterId;

  const ReciterSurahs({
    super.key,
    required this.title,
    required this.reciterId,
    required this.serverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.055.sw),
          tileColor: const Color(0XFF171715),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 0.017.sh,
              color: const Color(0xFFFAFAFA),
            ),
          ),
          trailing: SvgPicture.asset(
              "assets/ui icons/quran_custom_card_backbutton.svg"),
          onTap: () async {
            try {
              List<String> surahs = await fetchReciterSurahs(reciterId);

              Navigator.push(
                context,
                createRoute(
                  Telawah(
                    title: title,
                    surahs: surahs,
                    serverUrl: serverUrl,
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load surahs: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}
