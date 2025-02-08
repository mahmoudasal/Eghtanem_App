// Add this widget in your components
import 'package:egtanem_application/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class IconTextButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const IconTextButton({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(iconPath, width: 24.w, height: 24.h),
          SizedBox(height: 4.h),
          Text(label, style: AppTextStyles.headingsH7.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}