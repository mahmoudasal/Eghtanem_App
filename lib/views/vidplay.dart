import 'package:egtanem_application/views/longvids.dart';
import 'package:egtanem_application/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoDetailScreen extends StatefulWidget {
  final String thumbnail;
  final String title;
  final String viewCount;
  final String dayAgo;
  final String username;
  final String profile;
  final String subscribeCount;
  final String likeCount;
  final String unlikeCount;
  final String videoUrl;

  const VideoDetailScreen({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.viewCount,
    required this.dayAgo,
    required this.username,
    required this.profile,
    required this.subscribeCount,
    required this.likeCount,
    required this.unlikeCount,
    required this.videoUrl,
  });

  @override
  VideoDetailPageState createState() => VideoDetailPageState();
}

class VideoDetailPageState extends State<VideoDetailScreen> {
  late VideoPlayerController _controller;
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   scrolledUnderElevation: 0.0,
      //   toolbarHeight: 35.h,
      //   backgroundColor: const Color(0xff1D1D1B),
      //   leading: const SizedBox(width: 0.0),
      //   actions: [
      //     Row(
      //       children: [
      //         IconButton(
      //           icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
      //           onPressed: () => Navigator.pop(context),
      //         ),
      //         SizedBox(
      //           width: 35.w,
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      backgroundColor: const Color(0xFF1D1D1B),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildVideoPlayer(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    children: <Widget>[
                      buildVideoInfo(),
                      SizedBox(height: 20.h),
                      buildActionRow(),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      buildProfileSection(),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      buildUpNextSection(),
                      SizedBox(height: 10.h),
                      buildVideoList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoPlayer(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 0.25.sh,
                  color: Colors.black,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                if (!_controller.value.isPlaying)
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 60.sp,
                  ),
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 0.25.sh,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage(widget.thumbnail),
                fit: BoxFit.contain,
              ),
            ),
          );
  }

  Widget buildVideoInfo() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.white.withOpacity(0.7),
                size: 18.sp,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 70.w,
              child: Text(
                widget.title,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Text(
              'مشاهدة ${widget.viewCount}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildActionRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildActionColumn(
              icon: Icons.thumb_up_alt_outlined, label: widget.likeCount),
          buildActionColumn(
              icon: Icons.thumb_down_outlined, label: widget.unlikeCount),
          buildActionColumn(icon: Icons.download_outlined, label: 'تحميل'),
          buildActionColumn(icon: Icons.share, label: 'مشاركة'),
          buildActionColumn(icon: Icons.add_outlined, label: 'حفظ'),
        ],
      ),
    );
  }

  Column buildActionColumn({required IconData icon, required String label}) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white.withOpacity(0.5),
          size: 26.sp,
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Widget buildProfileSection() {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            CircleAvatar(
              radius: 23.r,
              backgroundImage: AssetImage(widget.profile),
            ),
            SizedBox(width: 15.w),
            Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.username,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '${widget.subscribeCount} متابع',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            shadowColor: const Color.fromARGB(0, 255, 255, 255),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {},
          child: SvgPicture.asset("assets/ui icons/Frame متابعه.svg"),
        ),
      ],
    );
  }

  Widget buildUpNextSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "الفيديوهات القادمة",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildVideoList() {
    return Column(
      children: List.generate(ytData.vidList.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              createRoute(VideoDetailScreen(
                thumbnail: ytData.vidList.values.elementAt(index).elementAt(1),
                title: ytData.vidList.values.elementAt(index).elementAt(0),
                viewCount: ytData.vidList.values.elementAt(index).elementAt(3),
                dayAgo: ytData.vidList.values.elementAt(index).elementAt(4),
                username: ytData.vidList.values.elementAt(index).elementAt(2),
                profile: ytData.vidList.values.elementAt(index).elementAt(5),
                subscribeCount: "1M", // Placeholder, replace with actual data
                likeCount: "1K", // Placeholder, replace with actual data
                unlikeCount: "100", // Placeholder, replace with actual data
                videoUrl: ytData.vidList.values.elementAt(index).elementAt(6),
              )),
            );
          },
          child: Column(
            children: [
              index == 0 ? SizedBox(height: 30.h) : SizedBox(height: 0.h),
              buildVideoListItem(index),
              index == ytData.vidList.length - 1
                  ? SizedBox(height: 60.h)
                  : SizedBox(height: 0.h),
            ],
          ),
        );
      }),
    );
  }

  Widget buildVideoListItem(int index) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: 0.98.sw,
              height: 0.29.sh,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.asset(
                  ytData.vidList.values.elementAt(index).elementAt(1),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              left: 0.82.sw,
              top: 0.24.sh,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                  width: 0.115.sw,
                  height: 0.023.sh,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(103, 0, 0, 0),
                  ),
                  child: Text(
                    ytData.vidList.values.elementAt(index).elementAt(6),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10.h),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      ytData.vidList.values.elementAt(index).elementAt(5),
                    ),
                    radius: 23.r,
                  ),
                  SizedBox(width: 0.03.sw, height: 0.13.sh),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 0.78.sw,
                            child: Text(
                              ytData.vidList.values
                                  .elementAt(index)
                                  .elementAt(0),
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: const Color(0xFFFAFAFA),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.01.sh),
                      Row(
                        children: [
                          SizedBox(width: 0.01.sw),
                          Text(
                            '${ytData.vidList.values.elementAt(index).elementAt(3)} مشاهدة',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '\t∙\t',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            ytData.vidList.values.elementAt(index).elementAt(4),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
