import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:social_share/social_share.dart';
// import 'package:social_share/social_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../cubits/video_player_cubit/video_player_cubit.dart';
import '../cubits/video_player_cubit/video_player_state.dart';
import '../cubits/interaction_button_cubit/interaction_cubit.dart';
import '../widgets/build_icon_text.dart';
import '../widgets/comment_bottom_sheet.dart';

class ShortsList extends StatefulWidget {
  final String name;
  final String profilePic;
  final String vid;
  final String caption;
  final int likes;
  final int comments;
  final Map<String, dynamic>? youtubeData;

  const ShortsList({
    super.key,
    required this.name,
    required this.caption,
    required this.comments,
    required this.likes,
    required this.vid,
    required this.profilePic,
    required this.youtubeData,
  });

  @override
  _ShortsListState createState() => _ShortsListState();
}

class _ShortsListState extends State<ShortsList> {
  late VideoPlayerCubit _videoPlayerCubit;
  late InteractionCubit _interactionCubit;

  @override
  void initState() {
    super.initState();
    _videoPlayerCubit = VideoPlayerCubit()..loadVideo(widget.vid);
    _interactionCubit = InteractionCubit(
      youtubeData: widget.youtubeData!,
      videoId: widget.vid,
    );
  }

  @override
  void dispose() {
    _videoPlayerCubit.close();
    _interactionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoPlayerCubit>.value(value: _videoPlayerCubit),
        BlocProvider<InteractionCubit>.value(value: _interactionCubit),
      ],
      child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
        builder: (context, state) {
          if (state is VideoPlayerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoPlayerLoaded) {
            return GestureDetector(
              onTap: () {
                _videoPlayerCubit.playPauseVideo(!state.isPlaying);
              },
              child: Stack(
                children: [
                  // Video Player
                  SizedBox.expand(
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: state.videoController,
                        showVideoProgressIndicator: false,
                        controlsTimeOut: const Duration(seconds: 1),
                      ),
                      builder: (context, player) {
                        return player;
                      },
                    ),
                  ),
                  // Overlay Content
                  buildOverlayContent(),
                  // Interaction Buttons
                  buildInteractionButtons(),
                  // Profile Section and Text Content
                  Positioned(
                    bottom: 55.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildProfileSection(),
                        SizedBox(height: 23.h),
                        buildTextContent(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is VideoPlayerError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: Text('Unknown error'));
          }
        },
      ),
    );
  }

  Widget buildOverlayContent() {
    return Positioned(
      left: 12.w,
      top: MediaQuery.of(context).size.height * 0.42,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30.w,
                child: CircleAvatar(
                  radius: 23.w,
                  backgroundImage: NetworkImage(widget.profilePic),
                ),
              ),
              Positioned(
                bottom: -2,
                child: SvgPicture.asset(
                  'assets/ui icons/Plus.svg',
                  height: 23.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AutoScrollingText(
            text: widget.name,
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: const Color(0xFFFAFAFA),
            ),
            maxWidth: 175.w,
          ),
        ],
      ),
    );
  }

  void _shareContent() async {
    try {
      String shareText =
          'Check out this video: https://www.youtube.com/watch?v=${widget.vid}';

      // await SocialShare.shareOptions(shareText);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video shared successfully')),
      );
    } catch (e) {
      // Handle sharing errors and notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share the video.')),
      );
    }
  }

  String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }

  Widget buildInteractionButtons() {
    return Positioned(
      bottom: 90.h,
      left: 24.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<InteractionCubit, InteractionState>(
            builder: (context, state) {
              bool isLiked = false;
              if (state is LikeToggledState) {
                isLiked = state.isLiked;
              }
              return buildIconWithText(
                icon: isLiked
                    ? 'assets/ui icons/like on.svg'
                    : 'assets/ui icons/Like off.svg',
                text: formatNumber(widget.likes),
                onTap: () => _interactionCubit.toggleLike(),
              );
            },
          ),
          SizedBox(height: 15.h),
          buildIconWithText(
            icon: 'assets/ui icons/Comment.svg',
            text: formatNumber(widget.comments),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CommentBottomSheet(videoId: widget.vid),
              );
            },
          ),
          SizedBox(height: 15.h),
          buildIconWithText(
            icon: 'assets/ui icons/Share.svg',
            onTap: _shareContent,
            text: 'Share',
          ),
        ],
      ),
    );
  }

  Widget buildTextContent() {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.h,
        left: 12.w,
        right: 12.w,
        bottom: 12.h,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          widget.caption,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            color: const Color(0xFFFAFAFA),
          ),
        ),
      ),
    );
  }
}

class AutoScrollingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double maxWidth;

  const AutoScrollingText({
    super.key,
    required this.text,
    required this.style,
    required this.maxWidth,
  });

  @override
  AutoScrollingTextState createState() => AutoScrollingTextState();
}

class AutoScrollingTextState extends State<AutoScrollingText>
    with SingleTickerProviderStateMixin {
  late double textWidth;
  late ScrollController _scrollController;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureTextWidth();
    });
  }

  void _measureTextWidth() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.rtl,
    )..layout();

    textWidth = textPainter.width;

    if (textWidth > widget.maxWidth) {
      _startScrolling();
    }
  }

  void _startScrolling() {
    if (!mounted) return;

    final double maxScrollExtent = textWidth - widget.maxWidth;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animationController!.addListener(() {
      if (_scrollController.hasClients) {
        final double newScrollPosition =
            _animationController!.value * maxScrollExtent;
        _scrollController.jumpTo(newScrollPosition);
      }
    });

    _animationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(
          widget.text,
          style: widget.style,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
      ),
    );
  }
}
