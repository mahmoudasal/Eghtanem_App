// Add this import at the top of tafseer_screen.dart
import 'package:eghtanem_app/core/constants/constant.dart';
import 'package:eghtanem_app/core/theme/app_colors.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: AppColors.primary0.withValues(alpha: 0.3),
        highlightColor: AppColors.primary0.withValues(alpha: 0.1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2D2D2B),
                const Color(0xFF252523),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary0.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primary0.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decorative icon
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary0.withValues(alpha: 0.3),
                      AppColors.primary0.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 16.sp,
                  color: AppColors.primary0,
                ),
              ),
              SizedBox(height: 8.h),
              // Surah name
              Text(
                Constants.suraNames[suraIndex],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
