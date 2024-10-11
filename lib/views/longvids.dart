import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'vidplay.dart';
import 'package:egtanem_application/cubits/cubit/media_cubit.dart';
import 'package:egtanem_application/widgets/custom_page_transition.dart';

class LongVids extends StatefulWidget {
  const LongVids({super.key});

  @override
  LongVidsState createState() => LongVidsState();
}

class LongVidsState extends State<LongVids> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final ScrollController _scrollController;
  late final MediaCubit _mediaCubit;

  // Local list to manage media items
  final List<Map<String, dynamic>> _mediaItems = [];
  bool _isShowingLoadingDialog = false;
  bool _isLoadingMore = false; // Track if more data is being loaded

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _mediaCubit = MediaCubit(mediaType: MediaType.video);
    _mediaCubit.fetchMedia();
  }

  void _onScroll() {
    try {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_mediaCubit.isLoading &&
          _mediaCubit.hasMoreData) {
        _mediaCubit.fetchMedia(loadMore: true);
      }
    } catch (e, stacktrace) {
      _mediaCubit.logger.e('Error during scroll event', e, stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An error occurred while scrolling. Please try again later.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    try {
      _scrollController.dispose();
      _mediaCubit.close();
    } catch (e, stacktrace) {
      _mediaCubit.logger.e('Error during dispose', e, stacktrace);
    } finally {
      super.dispose();
    }
  }

  void _insertNewItems(List<Map<String, dynamic>> newItems) {
    final listState = _listKey.currentState;
    if (listState != null && newItems.isNotEmpty) {
      final startIndex = _mediaItems.length;
      _mediaItems.addAll(newItems);

      for (int i = 0; i < newItems.length; i++) {
        listState.insertItem(startIndex + i,
            duration: const Duration(milliseconds: 300));
      }
    }
  }

  void _showLoadingDialog() {
    if (!_isShowingLoadingDialog) {
      _isShowingLoadingDialog = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }
  }

  void _hideLoadingDialog() {
    if (_isShowingLoadingDialog) {
      _isShowingLoadingDialog = false;
      Navigator.of(context).maybePop(); // Remove the loading dialog if shown
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mediaCubit,
      child: Container(
        color: const Color(0xff1D1D1B),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xff1D1D1B),
            body: BlocListener<MediaCubit, MediaState>(
              listener: (context, state) {
                if (state is MediaLoading) {
                  if (_mediaItems.isEmpty) {
                    _showLoadingDialog();
                  } else {
                    // We are loading more data
                    setState(() {
                      _isLoadingMore = true;
                    });
                  }
                } else if (state is MediaLoaded) {
                  _hideLoadingDialog();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  _insertNewItems(state.newMediaItems);
                  setState(() {
                    _isLoadingMore = false;
                  });
                } else if (state is MediaError) {
                  _hideLoadingDialog();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.errorMessage}'),
                    ),
                  );
                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedList(
                      key: _listKey,
                      controller: _scrollController,
                      initialItemCount: _mediaItems.length,
                      itemBuilder: (context, index, animation) {
                        final videoData = _mediaItems[index];
                        return SizeTransition(
                          sizeFactor: animation,
                          child: VideoTile(
                            key: ValueKey(videoData['videoId']),
                            index: index,
                            totalItems: _mediaItems.length,
                            title: videoData['title'],
                            imgUrl: videoData['thumbnail'],
                            name: videoData['channelTitle'],
                            views: _formatViews(videoData['views'] ?? 0),
                            profilePic: videoData['channelPic'],
                            duration: videoData['duration'] ?? '0',
                            videoUrl: videoData['videoId'],
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatViews(int views) {
    try {
      if (views >= 1000000) {
        return '${(views / 1000000).toStringAsFixed(1)}M';
      } else if (views >= 1000) {
        return '${(views / 1000).toStringAsFixed(1)}K';
      } else {
        return views.toString();
      }
    } catch (e) {
      _mediaCubit.logger.e('Error formatting views', e);
      return views.toString();
    }
  }
}

class VideoTile extends StatelessWidget {
  final int index;
  final int totalItems;
  final String title;
  final String imgUrl;
  final String name;
  final String profilePic;
  final String duration;
  final String views;
  final String videoUrl;

  const VideoTile({
    super.key,
    required this.index,
    required this.totalItems,
    required this.title,
    required this.imgUrl,
    required this.name,
    required this.profilePic,
    required this.duration,
    required this.views,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final logger = context.read<MediaCubit>().logger;
    logger.d("Building VideoTile for video $title");

    return GestureDetector(
      onTap: () {
        try {
          logger.d("VideoTile tapped: $title");
          Navigator.of(context).push(
            createRoute(
              VideoDetailScreen(
                thumbnail: imgUrl,
                title: title,
                viewCount: views,
                username: name,
                profile: profilePic,
                subscribeCount: "1M", // Placeholder, replace with actual data
                likeCount: "1K", // Placeholder, replace with actual data
                videoUrl: videoUrl,
              ),
            ),
          );
        } catch (e, stacktrace) {
          logger.e('Error during navigation to video detail', e, stacktrace);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load video details. Please try again.'),
            ),
          );
        }
      },
      child: Column(
        children: [
          if (index == 0) SizedBox(height: 30.h),
          buildVideoThumbnail(logger),
          SizedBox(height: 12.h),
          buildVideoInfo(context),
          SizedBox(height: 12.h),
          if (index == totalItems - 1) SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget buildVideoThumbnail(Logger logger) {
    return Stack(
      children: [
        SizedBox(
          width: 0.98.sw,
          height: 0.29.sh,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                logger.e('Error loading image', error, stackTrace);
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

  Widget buildVideoInfo(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // For right-to-left languages
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 0.025.sw),
          CircleAvatar(
            backgroundImage: NetworkImage(profilePic),
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
