// presentation/widgets/tafseer_bottom_sheet.dart
import 'package:egtanem_application/core/theme/app_colors.dart';
import 'package:egtanem_application/core/theme/app_text_styles.dart';
import 'package:egtanem_application/core/utilities/string_utils.dart';
import 'package:egtanem_application/models/tafseer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class TafseerBottomSheet extends StatelessWidget {
  final String suraName;
  final List<Interpretation> interpretations;

  const TafseerBottomSheet({
    super.key,
    required this.suraName,
    required this.interpretations,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          _buildInterpretationsList(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary0,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Text(
        suraName,
        style: AppTextStyles.headingsH3,
      ),
    );
  }

  Widget _buildInterpretationsList() {
    return Expanded(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 20.h),
          itemCount: interpretations.length,
          separatorBuilder: (_, __) => Divider(
            color: AppColors.primary0,
            height: 24.h,
          ),
          itemBuilder: (context, index) {
            final interpretation = interpretations[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              title: Text(
                'الآية ${convertToArabicNumeral(interpretation.aya)}',
                style: AppTextStyles.headingsH4,
              ),
              subtitle: Text(
                interpretation.text,
                style: AppTextStyles.headingsH3,
              ),
            );
          },
        ),
      ),
    );
  }
}