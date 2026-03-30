import 'dart:async';
import 'dart:ui';

import 'package:eghtanem_app/features/home/data/models/comment_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart'
    hide Video, Comment;
import 'package:eghtanem_app/features/video/data/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/core/theme/app_text_styles.dart';
import 'package:eghtanem_app/features/home/presentation/widgets/comment_bottom_sheet.dart';

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
  bool _hasError = false;
  bool _isLiked = false;
  bool _cancelled = false;

  // Matches youtube.com/watch, youtu.be, youtube.com/shorts
  static final _ytRegex = RegExp(
    r'(?:youtube\.com/(?:watch\?v=|shorts/)|youtu\.be/)([\w-]{11})',
  );

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final rawUrl = widget.video.videoUrl ?? '';
      String streamUrl = rawUrl;

      // Resolve YouTube links to a direct stream URL
      final ytMatch = _ytRegex.firstMatch(rawUrl);
      if (ytMatch != null) {
        final videoId = ytMatch.group(1)!;
        final yt = YoutubeExplode();
        try {
          final manifest = await yt.videos.streamsClient.getManifest(videoId);
          if (_cancelled) return;
          // Prefer muxed (video+audio), fall back to highest-quality video-only
          final muxed = manifest.muxed;
          if (muxed.isNotEmpty) {
            streamUrl = muxed.withHighestBitrate().url.toString();
          } else {
            streamUrl = manifest.videoOnly.withHighestBitrate().url.toString();
          }
        } finally {
          yt.close();
        }
      }

      if (_cancelled) return;

      if (streamUrl.startsWith('assets/')) {
        _videoController = VideoPlayerController.asset(streamUrl);
      } else {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(streamUrl),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }

      await _videoController?.initialize().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception('Video initialization timed out');
        },
      );

      if (_cancelled || !mounted) {
        unawaited(_videoController?.dispose());
        _videoController = null;
        return;
      }

      setState(() => _isInitialized = true);
      unawaited(_videoController?.play());
      unawaited(_videoController?.setLooping(true));
    } catch (_) {
      if (mounted && !_cancelled) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _cancelled = true;
    _videoController?.pause();
    _videoController?.dispose();
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
              const _BottomGradient(),
              if (_isSpeedUp) const _SpeedIndicator(),
              if (!_isPlaying) const _PlayButton(),
              _InteractionPanel(
                video: widget.video,
                isLiked: _isLiked,
                onLike: () => setState(() {
                  _isLiked = !_isLiked;
                  widget.video.likesCount += _isLiked ? 1 : -1;
                }),
              ),
              _VideoCaption(video: widget.video),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _hasError
          ? ColoredBox(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      color: Colors.white54, size: 40.sp),
                  SizedBox(height: 12.h),
                  Text('تعذّر تحميل الفيديو',
                      style: AppTextStyles.headingsH6
                          .copyWith(color: Colors.white54)),
                ],
              ),
            )
          : _isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                )
              : ColoredBox(
                  color: Colors.black,
                  child: Center(
                    child: SizedBox(
                      width: 44.w,
                      height: 44.w,
                      child: const CircularProgressIndicator(
                        color: AppColors.primary0,
                        strokeWidth: 2.5,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ),
                ),
    );
  }
}

// ─── Bottom gradient ──────────────────────────────────────────────────────────
class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.45, 1.0],
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.80),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Speed indicator ──────────────────────────────────────────────────────────
class _SpeedIndicator extends StatelessWidget {
  const _SpeedIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 52.h,
      left: 0,
      right: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 6.w),
                  Text('2× السرعة', style: AppTextStyles.headingsH6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Play button ──────────────────────────────────────────────────────────────
class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.2,
              ),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              size: 42.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _InteractionPanel extends StatelessWidget {
  final Video video;
  final VoidCallback onLike;
  final bool isLiked;

  const _InteractionPanel({
    required this.video,
    required this.onLike,
    required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12.w,
      bottom: 100.h,
      child: Column(
        children: [
          _AnimatedInteractionButton(
            icon: isLiked
                ? 'assets/icons/like_on.svg'
                : 'assets/icons/Like_off.svg',
            label: _formatCount(video.likesCount),
            isActive: isLiked,
            onPressed: onLike,
          ),
          SizedBox(height: 20.h),
          _AnimatedInteractionButton(
            icon: 'assets/icons/Comment.svg',
            label: _formatCount(video.comments.length),
            onPressed: () => _showComments(context),
          ),
          SizedBox(height: 20.h),
          const _AnimatedInteractionButton(
            icon: 'assets/icons/Share.svg',
            label: 'مشاركة',
          ),
        ],
      ),
    );
  }

  String _formatCount(int number) {
    if (number >= 1e6) return '${(number / 1e6).toStringAsFixed(1)}M';
    if (number >= 1e3) return '${(number / 1e3).toStringAsFixed(1)}k';
    return number.toString();
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentBottomSheet(
        videoId: video.id?.toString() ?? '0',
        comments: List<Comment>.from(video.comments),
      ),
    );
  }
}

// ─── Animated interaction button ─────────────────────────────────────────────
class _AnimatedInteractionButton extends StatefulWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback? onPressed;

  const _AnimatedInteractionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onPressed,
  });

  @override
  State<_AnimatedInteractionButton> createState() =>
      _AnimatedInteractionButtonState();
}

class _AnimatedInteractionButtonState extends State<_AnimatedInteractionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.80).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isActive
                    ? Colors.red.withValues(alpha: 0.30)
                    : Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                  color: widget.isActive
                      ? Colors.red.withValues(alpha: 0.70)
                      : Colors.white.withValues(alpha: 0.25),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isActive
                        ? Colors.red.withValues(alpha: 0.40)
                        : Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  widget.icon,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: AppTextStyles.headingsH7.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.isActive ? Colors.redAccent : Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Video caption ────────────────────────────────────────────────────────────
class _VideoCaption extends StatelessWidget {
  final Video video;

  const _VideoCaption({required this.video});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      right: 76.w,
      bottom: 100.h,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Channel / title row
            if ((video.title ?? '').isNotEmpty)
              Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary0,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 17.sp),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      video.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headingsH5.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.65),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if ((video.title ?? '').isNotEmpty) SizedBox(height: 8.h),
            // Description
            if ((video.description ?? '').isNotEmpty)
              Text(
                video.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headingsH6.copyWith(
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.65),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
