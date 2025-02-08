import 'package:egtanem_application/core/theme/app_colors.dart';
import 'package:egtanem_application/features/video/data/models/video_model.dart';
import 'package:egtanem_application/core/utilities/cache_manger.dart';
import 'package:egtanem_application/features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'package:egtanem_application/features/video/presentation/cubit/video_cubit.dart';
import 'package:egtanem_application/features/home/presentation/screens/categories.dart';
import 'package:egtanem_application/features/video/presentation/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary1,
      body: BlocBuilder<NavigationCubit, AppTab>(
        builder: (context, activeTab) {
          return _getActiveScreen(activeTab);
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _getActiveScreen(AppTab tab) {
    return switch (tab) {
      AppTab.categories => const CategoriesPage(),
      AppTab.shorts => const ShortsScreen(),
    };
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BlocBuilder<NavigationCubit, AppTab>(
      builder: (context, activeTab) {
        return BottomNavigationBar(
          currentIndex: activeTab.index,
          onTap: (index) => context.read<NavigationCubit>().navigateTo(
                AppTab.values[index],
              ),
          selectedItemColor: AppColors.primary0,
          unselectedItemColor: Colors.grey,
          backgroundColor: AppColors.primary1,
          items: [
            _buildCategoryItem(activeTab),
            _buildHomeItem(activeTab),
          ],
        );
      },
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

    return 
        PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      onPageChanged: (index) {
        if (index < videos.length - 2) {
          _preloadNextVideos(videos, index);
        }
      },
      itemBuilder: (context, index) => VideoPlayerCard(video: videos[index]),
    );
  }

  void _preloadNextVideos(List<Video> videos, int currentIndex) {
    for (var i = 1; i <= 2; i++) {
      final nextIndex = currentIndex + i;
      if (nextIndex < videos.length) {
        final videoUrl = videos[nextIndex].videoUrl;
        if (videoUrl?.isNotEmpty ?? false) {
          customVideoCacheManager.downloadFile(videoUrl!);
        }
      }
    }
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('لا توجد فيديوهات متاحة.'));
  }
}
