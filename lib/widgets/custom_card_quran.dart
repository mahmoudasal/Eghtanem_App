import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../views/categories/quran/telawah.dart';

class QuranCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const QuranCard({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 0.1.sh,
          width: 0.9.sw,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Get.to(() => Telawah(
                    title: title,
                    imagePath: imagePath,
                  ));
            },
            child: Card(
              color: const Color(0XFF171715),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(
                    width: 0.08.sw,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(imagePath),
                    radius: 25.r,
                  ),
                  SizedBox(
                    width: 0.05.sw,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      fontSize: 0.017.sh,
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                  SizedBox(
                    width: 0.14.sw,
                  ),
                  SvgPicture.asset(
                      "assets/ui icons/quran_custom_card_backbutton.svg")
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
