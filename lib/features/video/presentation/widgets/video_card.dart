import 'package:eghtanem_app/features/home/data/models/comment_model.dart';
import 'package:eghtanem_app/features/video/data/models/video_model.dart';
import 'package:eghtanem_app/features/home/presentation/widgets/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../home/presentation/widgets/comment_bottom_sheet.dart';

class VideoPlayerCard extends StatefulWidget {
  final Video video;

  const VideoPlayerCard({super.key, required this.video});

  @override
  State<VideoPlayerCard> createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _isPlaying = true;
  bool _isSpeedUp = false;
  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Use asset-based or direct file path instead of cache manager
      final videoUrl = widget.video.videoUrl ?? '';

      // For asset files (local videos)
      if (videoUrl.startsWith('assets/')) {
        _videoController = VideoPlayerController.asset(videoUrl);
      } else {
        // For network URLs, use network controller directly
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }

      await _videoController?.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Video initialization timed out');
        },
      );

      if (mounted) {
        setState(() => _isInitialized = true);
        _videoController
          ?..play()
          ..setLooping(true);
      }
    } catch (e) {
      if (mounted) setState(() => _isInitialized = false);
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _videoController?.pause();
      _videoController?.dispose();
    }
    super.dispose();
  }

  // In _VideoPlayerCardState
  void _togglePlayback() {
    if (!mounted) return;
    setState(() => _isPlaying = !_isPlaying);
    _isPlaying ? _videoController?.play() : _videoController?.pause();
  }

  void _handleSpeedChange(bool speedUp) {
    _videoController?.setPlaybackSpeed(speedUp ? 2.0 : 1.0);
    if (mounted) {
      setState(() => _isSpeedUp = speedUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_${widget.video.id}'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction == 0 && _isPlaying) {
          _togglePlayback();
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: _togglePlayback,
          onLongPressStart: (_) => _handleSpeedChange(true),
          onLongPressEnd: (_) => _handleSpeedChange(false),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildVideoContent(),
              if (_isSpeedUp) const _SpeedIndicator(),
              if (!_isPlaying) const _PlayButton(),
              _InteractionPanel(
                video: widget.video,
                onLike: () => widget.video.likesCount++,
              ),
              _VideoCaption(caption: widget.video.description ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  // In VideoPlayerCard build method
  Widget _buildVideoContent() {
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: _isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
      ),
    );
  }
}

class _SpeedIndicator extends StatelessWidget {
  const _SpeedIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40.h,
      left: 16.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text('2x speed', style: AppTextStyles.headingsH6),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.play_arrow,
        size: 80.sp,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}

class _InteractionPanel extends StatelessWidget {
  final Video video;
  final VoidCallback onLike;

  const _InteractionPanel({
    required this.video,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      bottom: 80.h,
      child: Column(
        children: [
          _InteractionButton(
            icon: 'assets/icons/Like_off.svg',
            count: video.likesCount,
            onPressed: onLike,
          ),
          SizedBox(height: 16.h),
          _InteractionButton(
            icon: 'assets/icons/Comment.svg',
            count: video.comments.length,
            onPressed: () => _showComments(context),
          ),
          SizedBox(height: 16.h),
          const _InteractionButton(
            icon: 'assets/icons/Share.svg',
            label: 'مشاركة',
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentBottomSheet(
        videoId: video.id?.toString() ?? '0', // Convert to String
        comments: List<Comment>.from(video.comments),
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final String icon;
  final String? label;
  final int? count;
  final VoidCallback? onPressed;

  const _InteractionButton({
    required this.icon,
    this.label,
    this.count,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      iconPath: icon,
      label: label ?? _formatCount(count ?? 0),
      onTap: onPressed,
    );
  }

  String _formatCount(int number) {
    if (number >= 1e6) return '${(number / 1e6).toStringAsFixed(1)}M';
    if (number >= 1e3) return '${(number / 1e3).toStringAsFixed(1)}k';
    return number.toString();
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 30.h,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          caption,
          style: AppTextStyles.headingsH7,
        ),
      ),
    );
  }
}
