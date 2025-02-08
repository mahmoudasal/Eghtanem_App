// prophetspeech.dart
import 'package:egtanem_application/features/hadith/data/presentation/cubit/hadith_cubit.dart';
import 'package:egtanem_application/features/hadith/data/presentation/cubit/hadith_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';


import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'liked_hadith.dart';

class Prophetspeech extends StatelessWidget {
  const Prophetspeech({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HadithCubit()..loadHadiths(),
      child: const _ProphetspeechView(),
    );
  }
}

class _ProphetspeechView extends StatelessWidget {
  const _ProphetspeechView();

  void _navigateToLikedHadiths(BuildContext context) {
    final cubit = context.read<HadithCubit>();
    if (cubit.state is HadithLoaded) {
      final state = cubit.state as HadithLoaded;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LikedHadiths(
            likedHadiths: state.likedHadiths,
            allHadiths: Future.value(state.hadiths),
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
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/icons/BackButton.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 35.w),
            ],
          ),
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
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
      itemCount: state.hadiths.length,
      itemBuilder: (context, index) {
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
                      onPressed: () => context.read<HadithCubit>().toggleLike(hadith.number),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  textDirection: TextDirection.rtl,
                  hadith.hadith,
                  style: AppTextStyles.headingsH4
                ),
                SizedBox(height: 10.h),
                Text(
                  textDirection: TextDirection.rtl,
                  hadith.description,
                  style: AppTextStyles.headingsH5
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}