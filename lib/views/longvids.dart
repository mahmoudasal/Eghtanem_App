import 'package:egtanem_application/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'vidplay.dart';
import 'yt_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

YTData ytData = YTData();

class HomeScreen extends StatelessWidget {
  static const String id = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1D1D1B),
      body: ListView.builder(
        itemCount: ytData.vidList.length,
        itemBuilder: (context, index) {
          final videoData = ytData.vidList.values.elementAt(index);
          return VideoTile(
            index: index,
            title: videoData.elementAt(0),
            imgUrl: videoData.elementAt(1),
            name: videoData.elementAt(2),
            views: videoData.elementAt(3),
            uploadDate: videoData.elementAt(4),
            profilePic: videoData.elementAt(5),
            duration: videoData.elementAt(6),
            videoUrl: videoData.elementAt(7),
          );
        },
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  final int index;
  final String title;
  final String imgUrl;
  final String name;
  final String uploadDate;
  final String profilePic;
  final String duration;
  final String views;
  final String videoUrl;

  const VideoTile({
    super.key,
    required this.index,
    required this.title,
    required this.imgUrl,
    required this.name,
    required this.uploadDate,
    required this.profilePic,
    required this.duration,
    required this.views,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(createRoute(
          VideoDetailScreen(
            thumbnail: imgUrl,
            title: title,
            viewCount: views,
            dayAgo: uploadDate,
            username: name,
            profile: profilePic,
            subscribeCount: "1M", // Placeholder, replace with actual data
            likeCount: "1K", // Placeholder, replace with actual data
            unlikeCount: "100", // Placeholder, replace with actual data
            videoUrl: videoUrl,
          ),
        ));
      },
      child: Column(
        children: [
          if (index == 0) SizedBox(height: 30.h),
          buildVideoThumbnail(),
          SizedBox(height: 12.h),
          buildVideoInfo(),
          SizedBox(height: 12.h),
          if (index == ytData.vidList.length - 1) SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget buildVideoThumbnail() {
    return Stack(
      children: [
        SizedBox(
          width: 0.98.sw,
          height: 0.29.sh,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.asset(
              imgUrl,
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
              child: Center(
                child: Text(
                  duration,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildVideoInfo() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 0.025.sw),
          CircleAvatar(
            backgroundImage: AssetImage(profilePic),
            radius: 24.r,
          ),
          SizedBox(width: 0.03.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: const Color(0xFFFAFAFA),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.01.sh),
                Row(
                  children: [
                    Text(
                      '$views مشاهدة',
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
                      uploadDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
