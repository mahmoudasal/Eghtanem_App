import 'package:egtanem_application/models/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/azkar_json.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class SupplicationsRemembrances extends StatelessWidget {
  const SupplicationsRemembrances({super.key});

  String getArabicCount(int count) {
    switch (count) {
      case 1:
        return 'مرة واحدة';
      case 2:
        return 'مرتين';
      case 3:
        return 'ثلاث مرات';
      case 4:
        return 'أربع مرات';
      case 7:
        return 'سبع مرات';
      case 10:
        return 'عشرة مرات';
      case 33:
        return 'مره 33';
      case 34:
        return 'مره 34';
      case 100:
        return 'مائة مرة';

      default:
        return '$count مرات';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primary1,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        centerTitle: true,
        backgroundColor: AppColors.primary1,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        title: Text('الادعية و الاذكار', style: AppTextSytle.headingsH1),
        leading: const SizedBox(width: 0.0),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(
                width: 35.w,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: AdhkarService().loadAdhkar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(
                    textDirection: TextDirection.rtl,
                    category.category,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // Navigate to AzkarCounter screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AzkarCounter(
                          category: category,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('جاري العمل علي بعض التحديثات'));
          }
        },
      ),
    );
  }
}
