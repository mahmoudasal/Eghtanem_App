import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_text_styles.dart';
import '../widgets/auto_scrolling_text.dart';
import '../widgets/comment_bottom_sheet.dart';

// shorts_list.dart
class ShortsList extends StatefulWidget {
  final VoidCallback onLike;
  final String name;
  final String profilePic;
  final String vid;
  final String caption;
  final int likes;
  final int comments;

  const ShortsList({
    super.key,
    required this.name,
    required this.caption,
    required this.comments,
    required this.likes,
    required this.vid,
    required this.profilePic,
    required this.onLike,
  });

  @override
  ShortsListState createState() => ShortsListState();
}

class ShortsListState extends State<ShortsList> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          // Video Player would go here
          _buildOverlayContent(),
          _buildInteractionButtons(),
          _buildProfileSection(),
        ],
      ),
    );
  }

  Widget _buildOverlayContent() {
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
                ),
              ),
              Positioned(
                bottom: -2,
                child: SvgPicture.asset(
                  'assets/ui_icons/Plus.svg',
                  height: 23.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Positioned(
      bottom: 55.h,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
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
          ),
          SizedBox(height: 23.h),
          Padding(
            padding: EdgeInsets.only(
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
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
    return number.toString();
  }

  Widget _buildInteractionButtons() {
    return Positioned(
      bottom: 90.h,
      left: 24.w,
      child: Column(
        children: [
          _buildIconWithText(
            icon: isLiked
                ? 'assets/ui_icons/like_on.svg'
                : 'assets/ui_icons/Like_off.svg',
            text: _formatNumber(widget.likes),
            onTap: () {
              setState(() => isLiked = !isLiked);
              widget.onLike();
            },
          ),
          SizedBox(height: 15.h),
          _buildIconWithText(
            icon: 'assets/ui_icons/Comment.svg',
            text: _formatNumber(widget.comments),
            onTap: () => _showComments(),
          ),
          SizedBox(height: 15.h),
          _buildIconWithText(
            icon: 'assets/ui_icons/Share.svg',
            text: 'مشاركة', // Arabic for "Share"
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentBottomSheet(videoId: widget.vid),
    );
  }

  Widget _buildIconWithText({
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(icon, height: 24.h),
          SizedBox(height: 4.h),
          Text(text, style: AppTextSytle.headingsH7),
        ],
      ),
    );
  }
}
