import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


import '../theme/app_text_styles.dart';
import '../widgets/auto_scrolling_text.dart';
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
  ShortsListState createState() => ShortsListState();
}

class ShortsListState extends State<ShortsList> {
 
  bool isPlaying = true;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
   
    
  }

  @override
  void dispose() {
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPlaying = !isPlaying;
          if (isPlaying) {
           
          } else {
         
          }
        });
      },
      child: Stack(
        children: [
          // Video Player
         
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
            style: AppTextSytle.headingsH5,
            maxWidth: 175.w,
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

  Widget buildInteractionButtons() {
    return Positioned(
      bottom: 90.h,
      left: 24.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildIconWithText(
            icon: isLiked
                ? 'assets/ui icons/like on.svg'
                : 'assets/ui icons/Like off.svg',
            text: formatNumber(widget.likes),
            onTap: () {
              setState(() {
                isLiked = !isLiked;
              });
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
            onTap: () {},
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
          style: AppTextSytle.headingsH7,
        ),
      ),
    );
  }
}