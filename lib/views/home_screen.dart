import 'package:egtanem_application/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../cubits/video_player_cubit/video_player_cubit.dart';
import '../cubits/video_player_cubit/video_player_state.dart';
import '../cubits/interaction_button_cubit/interaction_cubit.dart';
import '../widgets/build_icon_text.dart';

class ShortsList extends StatelessWidget {
  final String name;
  final String profilePic;
  final String vid;
  final String caption;
  final String likes;
  final String comments;
  final Future<void> Function() onLikePressed;
  final Map<String, dynamic> youtubeData; // Add youtubeData as a parameter

  const ShortsList({
    super.key,
    required this.name,
    required this.caption,
    required this.comments,
    required this.likes,
    required this.vid,
    required this.profilePic,
    required this.onLikePressed,
    required this.youtubeData, // Include youtubeData in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => VideoPlayerCubit()..loadVideo(vid),
        ),
        BlocProvider(
          create: (context) =>
              InteractionCubit(youtubeData: youtubeData, videoId: vid),
        ),
      ],
      child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
        builder: (context, state) {
          if (state is VideoPlayerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoPlayerLoaded) {
            return GestureDetector(
              onTap: () {
                context
                    .read<VideoPlayerCubit>()
                    .playPauseVideo(!state.isPlaying);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0.025.sh, 0, 0),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      width: deviceWidth,
                      height: deviceHeight * 0.1,
                    ),
                    YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: state.videoController,
                      ),
                      builder: (context, player) {
                        return SizedBox.expand(child: player);
                      },
                    ),
                    buildOverlayContent(context),
                    buildProfileSection(),
                    buildInteractionButtons(context),
                    buildTextContent(),
                  ],
                ),
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

  Widget buildOverlayContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.450.sh),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30.w,
                child: CircleAvatar(
                  radius: 23.w,
                  backgroundImage: NetworkImage(profilePic),
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
      padding: EdgeInsets.only(
        right: 8.w,
        top: 0.72.sh,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  Widget buildInteractionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        left: 24.w,
        right: 0,
        bottom: 35.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                text: formatNumber(int.parse(likes)),
                onTap: () => context.read<InteractionCubit>().toggleLike(),
              );
            },
          ),
          SizedBox(height: 15.h),
          buildIconWithText(
            icon: 'assets/ui icons/Comment.svg',
            text: formatNumber(int.parse(comments)),
            onTap: () {},
          ),
          SizedBox(height: 15.h),
          buildIconWithText(
            icon: 'assets/ui icons/Share.svg',
            onTap: () {},
            text: 'Share',
          ),
        ],
      ),
    );
  }

  Widget buildTextContent() {
    return Padding(
      padding: EdgeInsets.only(top: 0.78.sh, left: 0.09.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: 0.79.sw,
              child: Text(
                caption,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
