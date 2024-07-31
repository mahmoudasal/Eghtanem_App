import 'package:egtanem_application/views/categories/quran/quran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TelawhCard extends StatelessWidget {
  final String title;
  final String surahId; // Add a surahId parameter

  const TelawhCard({
    super.key,
    required this.title,
    required this.surahId,
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
          trailing: SvgPicture.asset("assets/ui icons/Main Controller.svg"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuranSubCat(title: "heh"),
              ),
            );
          },
        ),
      ),
    );
  }
}
