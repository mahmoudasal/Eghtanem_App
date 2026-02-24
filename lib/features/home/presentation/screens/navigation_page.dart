import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../video/data/models/video_model.dart';
import '../../../video/presentation/cubit/video_cubit.dart';
import '../../../video/presentation/widgets/video_card.dart';
import '../navigation_cubit/navigation_cubit.dart';
import 'categories.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, AppTab>(
      builder: (context, activeTab) {
        final isShorts = activeTab == AppTab.shorts;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            extendBody: true,
            backgroundColor: AppColors.primary1,
            body: _getActiveScreen(activeTab),
            bottomNavigationBar:
                _buildBottomNavBar(context, activeTab, isShorts),
          ),
        );
      },
    );
  }

  Widget _getActiveScreen(AppTab tab) {
    return switch (tab) {
      AppTab.categories => const CategoriesPage(),
      AppTab.shorts => const ShortsScreen(),
    };
  }

  Widget _buildBottomNavBar(
      BuildContext context, AppTab activeTab, bool isShorts) {
    return Container(
      decoration: BoxDecoration(
        gradient: isShorts
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.72),
                ],
              )
            : null,
        color: isShorts ? null : AppColors.primary1,
      ),
      child: BottomNavigationBar(
        currentIndex: activeTab.index,
        onTap: (index) => context.read<NavigationCubit>().navigateTo(
              AppTab.values[index],
            ),
        selectedItemColor: AppColors.primary0,
        unselectedItemColor: isShorts ? Colors.white70 : Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedFontSize: 11.sp,
        unselectedFontSize: 11.sp,
        items: [
          _buildCategoryItem(activeTab),
          _buildHomeItem(activeTab),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildCategoryItem(AppTab activeTab) {
    final isSelected = activeTab == AppTab.categories;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        isSelected
            ? 'assets/icons/category_selected.svg'
            : 'assets/icons/category.svg',
        width: 24,
        height: 24,
      ),
      label: 'اغتنم وقتك',
    );
  }

  BottomNavigationBarItem _buildHomeItem(AppTab activeTab) {
    final isSelected = activeTab == AppTab.shorts;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        isSelected
            ? 'assets/icons/home.svg'
            : 'assets/icons/home_unselected.svg',
        width: 24,
        height: 24,
      ),
      label: 'الرئيسية',
    );
  }
}

class ShortsScreen extends StatelessWidget {
  const ShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        // Trigger initial load
        if (state is VideoInitial) {
          context.read<VideoCubit>().loadVideos();
          return const _LoadingIndicator();
        }

        return switch (state) {
          VideoLoading() => const _LoadingIndicator(),
          VideoError(message: final message) => _ErrorDisplay(message: message),
          VideoLoaded(videos: final videos) => _VideoContent(videos: videos),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorDisplay extends StatelessWidget {
  final String message;
  const _ErrorDisplay({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('خطأ في تحميل الفيديوهات: $message'));
  }
}

class _VideoContent extends StatelessWidget {
  final List<Video> videos;
  const _VideoContent({required this.videos});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const _EmptyContent();

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      itemBuilder: (context, index) => VideoPlayerCard(video: videos[index]),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('لا توجد فيديوهات متاحة.'));
  }
}
