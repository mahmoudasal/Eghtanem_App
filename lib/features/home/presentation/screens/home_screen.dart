import 'package:egtanem_application/features/video/data/models/video_model.dart';
import 'package:egtanem_application/core/utilities/cache_manger.dart';
import 'package:egtanem_application/features/video/presentation/cubit/video_cubit.dart';
import 'package:egtanem_application/features/video/presentation/widgets/video_card.dart';
import 'package:flutter/material.dart';


// shorts_list.dart
// shorts_screen.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ShortsScreen extends StatelessWidget {
  const ShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
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
      onPageChanged: (index) => _preloadNextVideos(videos, index),
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