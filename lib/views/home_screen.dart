import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/build_icon_text.dart';
import '../widgets/comment_bottom_sheet.dart';
import '../widgets/share_bottom_sheet.dart';

class ShortsList extends StatefulWidget {
  final String name;
  final String profilePic;
  final String vid;
  final String caption;
  final String likes;
  final String comments;
  final String hashtags;

  const ShortsList({
    super.key,
    required this.name,
    required this.caption,
    required this.comments,
    required this.likes,
    required this.vid,
    required this.profilePic,
    required this.hashtags,
  });

  @override
  ShortsListState createState() => ShortsListState();
}

class ShortsListState extends State<ShortsList> {
  late VideoPlayerController _controller;
  bool isLike = false;
  bool isCommentLike = false;
  bool isBookmarked = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.vid)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
                _isPlaying = !_isPlaying;
              });
            },
            child: Stack(
              children: [
                _controller.value.isInitialized
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio * 0.5,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                if (!_controller.value.isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 100,
                      color: Colors.white54,
                    ),
                  )
                else
                  const Center(
                    child: Icon(
                      Icons.pause,
                      size: 100,
                      color: Colors.transparent,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_controller.value.isInitialized)
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Color.fromARGB(255, 163, 140, 113),
                backgroundColor: Colors.grey,
                bufferedColor: Color.fromARGB(255, 246, 234, 225),
              ),
            ),
          ),
        buildOverlayContent(context),
        buildProfileSection(),
        buildInteractionButtons(),
        buildTextContent(),
      ],
    );
  }

  Widget buildOverlayContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.385.sh),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30.w,
                child: CircleAvatar(
                  radius: 23.w,
                  backgroundImage: AssetImage(widget.profilePic),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {},
                child: SvgPicture.asset("assets/ui icons/Frame متابعه.svg"),
              ),
              Text(
                widget.name,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInteractionButtons() {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        left: 24.w,
        right: 0,
        bottom: 30.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildIconWithText(
            icon: isLike
                ? 'assets/ui icons/like on.svg'
                : 'assets/ui icons/Like off.svg',
            text: widget.likes,
            onTap: () {
              setState(() {
                isLike = !isLike;
              });
            },
          ),
          SizedBox(height: 15.h),
          buildIconWithText(
            icon: 'assets/ui icons/Comment.svg',
            text: widget.comments,
            onTap: () {
              showCommentBottomSheet(context, widget.profilePic);
            },
          ),
          SizedBox(height: 15.h),
          buildIconWithText(
            icon: isBookmarked
                ? 'assets/ui icons/bookmark on.svg'
                : 'assets/ui icons/bookmark off.svg',
            text: widget.comments,
            onTap: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
          ),
          SizedBox(height: 15.h),
          buildIconWithText(
            icon: 'assets/ui icons/Share.svg',
            text: widget.comments,
            onTap: () {
              showShareBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextContent() {
    return Padding(
      padding: EdgeInsets.only(top: 0.8.sh, left: 0.04.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: 0.9.sw,
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
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: 0.8.sw,
              child: Text(
                widget.hashtags,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
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
