// supplications_remembrances.dart
import 'package:eghtanem_app/features/dhikr/data/models/azkar_json.dart';
import 'package:flutter/material.dart';
import 'azkar_counter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/back_button.dart';

import '../cubit/dhikr_cubit.dart';

class SupplicationsRemembrances extends StatelessWidget {
  const SupplicationsRemembrances({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DhikrCubit(AdhkarService())..loadAdhkar(),
      child: const _SupplicationsView(),
    );
  }
}

class _SupplicationsView extends StatelessWidget {
  const _SupplicationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primary1,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 70.h,
        centerTitle: true,
        backgroundColor: AppColors.primary1,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        title: Text('الادعية و الاذكار', style: AppTextStyles.headingsH1),
        leading: const SizedBox(width: 0.0),
        actions: [
          const CustomBackButton(),
        ],
      ),
      body: BlocBuilder<DhikrCubit, DhikrState>(
        builder: (context, state) {
          if (state is DhikrLoading) {
            return _buildShimmerLoading();
          }
          if (state is DhikrError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is DhikrLoaded) {
            return _buildCategoryList(state.categories);
          }
          return const Center(child: Text('جاري العمل علي بعض التحديثات'));
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 47.h),
      itemCount: 15,
      itemBuilder: (_, index) => Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Card(
            color: AppColors.primary2,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
          )),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 47.h),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          color: AppColors.primary2,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            title: Text(
              textDirection: TextDirection.rtl,
              category.category,
              style: AppTextStyles.headingsH3,
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () => _navigateToAzkarCounter(context, category),
          ),
        );
      },
    );
  }

  void _navigateToAzkarCounter(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AzkarCounter(category: category),
      ),
    );
  }
}
