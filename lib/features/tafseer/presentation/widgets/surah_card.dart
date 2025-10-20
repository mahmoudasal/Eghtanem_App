// Add this import at the top of tafseer_screen.dart
import 'package:eghtanem_app/core/constants/constant.dart';
import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/core/theme/app_text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurahCard extends StatelessWidget {
  final int suraIndex;
  final VoidCallback onTap;

  const SurahCard({
    super.key,
    required this.suraIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary1,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Text(
          Constants.suraNames[suraIndex],
          textAlign: TextAlign.center,
          style: AppTextStyles.headingsH3,
        ),
      ),
    );
  }
}
