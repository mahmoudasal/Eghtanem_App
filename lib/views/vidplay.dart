import 'package:egtanem_application/widgets/share_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../cubits/cubit/media_cubit.dart'; // Import MediaCubit

class VideoDetailScreen extends StatefulWidget {
  final String thumbnail;
  final String title;
  final String viewCount;
  final String username;
  final String profile;
  final String subscribeCount;
  final String likeCount;
  final String videoUrl;

  const VideoDetailScreen({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.viewCount,
    required this.username,
    required this.profile,
    required this.subscribeCount,
    required this.likeCount,
    required this.videoUrl,
  });

  @override
  VideoDetailScreenState createState() => VideoDetailScreenState();
}

class VideoDetailScreenState extends State<VideoDetailScreen> {
  late YoutubePlayerController _controller;
  late MediaCubit _mediaCubit;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        controlsVisibleAtStart: true,
      ),
    );

    _mediaCubit = MediaCubit(mediaType: MediaType.video);
    _mediaCubit.fetchMedia();

    // Remove the ScrollController initialization
    // _scrollController = ScrollController();
    // _scrollController.addListener(_onScroll);
  }

  // Remove the _onScroll method since it is no longer needed
  // void _onScroll() {}

  @override
  void dispose() {
    _controller.dispose();
    _mediaCubit.close();
    // Remove the ScrollController disposal
    // _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onBackButtonPressed(BuildContext context) async {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediaCubit>.value(
      value: _mediaCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF1D1D1B),
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _buildVideoPlayer(),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    children: <Widget>[
                      _buildVideoInfo(),
                      SizedBox(height: 20.h),
                      _buildActionRow(),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      _buildProfileSection(),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      _buildUpNextSection(),
                      SizedBox(height: 10.h),
                      _buildVideoList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1D1D1B),
      elevation: 0,
      leading: const SizedBox(width: 0.0),
      actions: [
        Row(
          children: [
            IconButton(
              icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
              onPressed: () => _onBackButtonPressed(context),
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ],
      centerTitle: true,
    );
  }

  Widget _buildVideoPlayer() {
    return WillPopScope(
      onWillPop: () async {
        if (_controller.value.isPlaying) {
          _controller.pause();
        }
        return true;
      },
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {},
        ),
        builder: (context, player) {
          return Container(
            height: 0.25.sh,
            color: Colors.black,
            child: player,
          );
        },
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
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
        const SizedBox(height: 10),
        _buildViewCountText(),
      ],
    );
  }

  Widget _buildViewCountText() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '  مشاهدة ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13.sp,
            ),
          ),
          Text(
            widget.viewCount,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildActionColumn(
              icon: Icons.thumb_up_alt_outlined, label: widget.likeCount),
          _buildActionColumn(
              icon: Icons.share,
              label: 'مشاركة',
              onPressed: () => showShareBottomSheet(context)),
          _buildActionColumn(icon: Icons.add_outlined, label: 'حفظ'),
        ],
      ),
    );
  }

  Column _buildActionColumn(
      {required IconData icon,
      required String label,
      VoidCallback? onPressed}) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onPressed,
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.5),
            size: 26.sp,
          ),
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

  Widget _buildProfileSection() {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildProfileInfo(),
        _buildSubscribeButton(),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Row(
      textDirection: TextDirection.rtl,
      children: <Widget>[
        CircleAvatar(
          radius: 20.r,
          backgroundImage: NetworkImage(widget.profile),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
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
        const SizedBox(
          width: 5,
        )
      ],
    );
  }

  Widget _buildSubscribeButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color.fromARGB(255, 204, 141, 5),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
      child: const Center(
        child: Text(
          'متابعة',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpNextSection() {
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

  Widget _buildVideoList() {
    return BlocBuilder<MediaCubit, MediaState>(
      builder: (context, state) {
        if (state is MediaLoading && _mediaCubit.mediaItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MediaLoaded || state is MediaLoading) {
          // Fetch only the first 5 videos
          final mediaItems = _mediaCubit.mediaItems
              .take(5)
              .toList(); // Take only the first 5 videos
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaItems.length,
            itemBuilder: (context, index) {
              final video = mediaItems[index];
              return GestureDetector(
                onTap: () {
                  // Implement navigation or video playback
                },
                child: Column(
                  children: [
                    if (index == 0) SizedBox(height: 30.h),
                    _buildVideoThumbnail(video['thumbnail'], video['duration']),
                    SizedBox(height: 12.h),
                    _buildVideoInfoTile(video),
                    SizedBox(height: 12.h),
                    if (index == mediaItems.length - 1) SizedBox(height: 60.h),
                  ],
                ),
              );
            },
          );
        } else if (state is MediaError) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildVideoInfoTile(Map<String, dynamic> videoData) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 0.025.sw),
          CircleAvatar(
            backgroundImage: NetworkImage(videoData['channelPic']),
            radius: 24.r,
          ),
          SizedBox(width: 0.03.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoData['title'],
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
                      '${_formatViews(videoData['views'] ?? '0')} مشاهدة',
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

  String _formatViews(String views) {
    int viewsInt = int.tryParse(views) ?? 0;
    if (viewsInt >= 1000000) {
      return '${(viewsInt / 1000000).toStringAsFixed(1)}M';
    } else if (viewsInt >= 1000) {
      return '${(viewsInt / 1000).toStringAsFixed(1)}K';
    } else {
      return views;
    }
  }

  Widget _buildVideoThumbnail(String imgUrl, String duration) {
    return Stack(
      children: [
        SizedBox(
          width: 0.98.sw,
          height: 0.29.sh,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.network(
              imgUrl,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                _mediaCubit.logger.e('Error loading image', error, stackTrace);
                return const Icon(Icons.error, color: Colors.red);
              },
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
}
