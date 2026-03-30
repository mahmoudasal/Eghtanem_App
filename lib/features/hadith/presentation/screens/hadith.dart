// Hadith.dart
import 'package:eghtanem_app/widgets/back_button.dart';
import 'package:eghtanem_app/injection.dart';
import 'package:eghtanem_app/features/hadith/presentation/cubit/hadith_cubit.dart';
import 'package:eghtanem_app/features/hadith/presentation/cubit/hadith_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/core/theme/app_text_styles.dart';
import 'package:eghtanem_app/features/hadith/presentation/screens/liked_hadith.dart';

class Hadith extends StatelessWidget {
  const Hadith({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HadithCubit>(),
      child: const _HadithView(),
    );
  }
}

class _HadithView extends StatelessWidget {
  const _HadithView();

  void _navigateToLikedHadiths(BuildContext context) {
    final cubit = context.read<HadithCubit>();
    if (cubit.state is HadithLoaded) {
      final state = cubit.state as HadithLoaded;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: LikedHadiths(
              likedHadiths: state.likedHadiths,
              allHadiths: cubit.allHadiths,
            ),
          ),
        ),
      );
    }
  }

//  Navigator.of(context).push(createRoute(pageBuilder()));
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
        title: Text("الاحاديث", style: AppTextStyles.headingsH1),
        leading: const SizedBox(width: 0.0),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => _navigateToLikedHadiths(context),
          ),
          const Row(children: [CustomBackButton()]),
        ],
      ),
      body: BlocBuilder<HadithCubit, HadithState>(
        builder: (context, state) {
          if (state is HadithLoading) {
            return _buildShimmerLoading();
          }
          if (state is HadithError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: AppTextStyles.errorStyle,
              ),
            );
          }
          if (state is HadithLoaded) {
            return _buildHadithList(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
      itemCount: 10,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Card(
          color: const Color(0XFF171715),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          child: Container(
            height: 150.h,
            padding: EdgeInsets.all(16.h),
          ),
        ),
      ),
    );
  }

  Widget _buildHadithList(BuildContext context, HadithLoaded state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 300 &&
            state.hasMore) {
          context.read<HadithCubit>().loadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
        itemCount: state.hadiths.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.hadiths.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final hadith = state.hadiths[index];
          final isLiked = state.likedHadiths.contains(hadith.number);
          return Card(
            color: const Color(0XFF171715),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => context
                            .read<HadithCubit>()
                            .toggleLike(hadith.number),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                      textDirection: TextDirection.rtl,
                      hadith.hadith,
                      style: AppTextStyles.headingsH4HigherHeight),
                  SizedBox(height: 10.h),
                  Text(
                      textDirection: TextDirection.rtl,
                      hadith.description,
                      style: AppTextStyles.headingsH5HigherHeight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
