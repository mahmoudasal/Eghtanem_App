import 'package:egtanem_application/cubits/prophet_stories/prophet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class PropheticBiography extends StatelessWidget {
  PropheticBiography({super.key});

  final List<Map<String, String>> videos = const [
    {
      "title": "الدرس الأول- العالم قبل الإسلام",
      "url": "https://www.youtube.com/watch?v=LI99lWP1zac"
    },
    {
      "title": "الدرس الثاني- مولد النبي وبداية شبابه",
      "url": "https://www.youtube.com/watch?v=A6_y0HuwSQw"
    },
    {
      "title":
          "الدرس الثالث الجزء الأول- وصف النبي صلي الله عليه وسلم وزواجه من السيدة خديجة",
      "url": "https://www.youtube.com/watch?v=nqpVIANGU-o"
    },
    {
      "title":
          "الدرس الثالث الجزء الثاني- وصف النبي صلي الله عليه وسلم وزواجه من السيدة خديجة",
      "url": "https://www.youtube.com/watch?v=YdWK45slrqc"
    },
    {
      "title": "الدرس الرابع- نزول الوحي علي النبي والدعوة السرية بمكة",
      "url": "https://www.youtube.com/watch?v=6SiKw-qQ6mk"
    },
    {
      "title": "الدرس الخامس- بداية الجهر بالدعوة",
      "url": "https://www.youtube.com/watch?v=GLvr-pYGLOs"
    },
    {
      "title":
          "الدرس السادس- بداية فترة استضعاف المسلمين في مكة والهجرة إلى الحبشة",
      "url": "https://www.youtube.com/watch?v=aliwSuClQRI"
    },
    {
      "title": "الدرس السابع- إسلام عمر بن الخطاب ووفاة أبو طالب عم النبي",
      "url": "https://www.youtube.com/watch?v=dZ1EkPuj91w"
    },
    {
      "title":
          "الدرس الثامن- عام الحزن ورحلة النبي صلي الله عليه وسلم إلى الطائف",
      "url": "https://www.youtube.com/watch?v=Tl1NmCYk1G4"
    },
    {
      "title": "الدرس التاسع- رحلة الإسراء والمعراج",
      "url": "https://www.youtube.com/watch?v=mvwhozvTKd8"
    },
    {
      "title": "الدرس العاشر- الطواف علي القبائل وبيعة العقبة الأولي",
      "url": "https://www.youtube.com/watch?v=SlBo6bmtuTI"
    },
    {
      "title": "الدرس الحادي عشر- أحداث الهجرة إلى المدينة",
      "url": "https://www.youtube.com/watch?v=GGFse7G6cAs"
    },
    {
      "title": "الدرس الثاني عشر- بداية العهد المدني وتأسيس مدينة المسلمين",
      "url": "https://www.youtube.com/watch?v=3rzbyI2_cvc"
    },
    {
      "title": "الدرس الثالث عشر- مجتمع المدينة ومفهوم الجهاد في سبيل الله",
      "url": "https://www.youtube.com/watch?v=7spRnIahHk4"
    },
    {
      "title": "الدرس الرابع عشر- غزوة بدر",
      "url": "https://www.youtube.com/watch?v=b7YVYhcQdfU"
    },
    {
      "title": "الدرس الخامس عشر- أحداث ما بين بدر وأحد",
      "url": "https://www.youtube.com/watch?v=Pt2EEsFtf5Y"
    },
    {
      "title": "الدرس السادس عشر- غزوة أحد",
      "url": "https://www.youtube.com/watch?v=EWvAT3HcUic"
    },
    {
      "title": "الدرس السابع عشر- حادثة الإفك",
      "url": "https://www.youtube.com/watch?v=2XJ1102-9rg"
    },
    {
      "title": "الدرس الثامن عشر- غزوة الخندق",
      "url": "https://www.youtube.com/watch?v=XPql-o9tQ0s"
    },
    {
      "title": "الدرس التاسع عشر- صلح الحديبية",
      "url": "https://www.youtube.com/watch?v=mbsTyEaQmJY"
    },
    {
      "title": "الدرس العشرون- غزوة خيبر",
      "url": "https://www.youtube.com/watch?v=3MF0xKJ2DWo"
    },
    {
      "title": "الدرس الواحد والعشرون- أحداث ما قبل فتح مكة",
      "url": "https://www.youtube.com/watch?v=9SX9K1csx28"
    },
    {
      "title": "الدرس الثاني والعشرون- فتح مكة",
      "url": "https://www.youtube.com/watch?v=TSkXmxSs-pA"
    },
    {
      "title": "الدرس الثالث والعشرون- غزوة حنين وحصار الطائف",
      "url": "https://www.youtube.com/watch?v=ySswp1_bn4A"
    },
    {
      "title": "الدرس الرابع والعشرون- غزوة تبوك",
      "url": "https://www.youtube.com/watch?v=ZrcxE10HVoQ"
    },
    {
      "title": "الدرس الخامس والعشرون والأخير- وفاة النبي",
      "url": "https://www.youtube.com/watch?v=k8CLspkQSEk"
    },
  ];

  ExpansionTileController? _activeController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoPlayerCubit(),
      child: WillPopScope(
        onWillPop: () async {
          context.read<VideoPlayerCubit>().stopVideo();
          return true;
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xff1D1D1B),
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            toolbarHeight: 100.h,
            centerTitle: true,
            backgroundColor: const Color(0xff1D1D1B),
            shadowColor: const Color(0xff1D1D1B),
            foregroundColor: const Color(0xff1D1D1B),
            title: Text(
              'السيره النبوية',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                fontSize: 25.sp,
                height: 1.2,
                color: const Color(0xFFFAFAFA),
              ),
            ),
            leading: const SizedBox(width: 0.0),
            actions: [
              Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
                    onPressed: () {
                      context.read<VideoPlayerCubit>().stopVideo();
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 35.w),
                ],
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                final ExpansionTileController controller =
                    ExpansionTileController();

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Card(
                    color: const Color(0xff2A2A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Theme(
                      data: ThemeData(
                        /// Prevents to splash effect when clicking.
                        splashColor: Colors.transparent,

                        /// Prevents the mouse cursor to highlight the tile when hovering on web.
                        hoverColor: Colors.transparent,

                        /// Hides the highlight color when the tile is pressed.
                        highlightColor: Colors.transparent,

                        /// Makes the top and bottom dividers invisible when expanded.
                        dividerColor: Colors.transparent,

                        /// Make background transparent.
                        expansionTileTheme: const ExpansionTileThemeData(
                          backgroundColor: Colors.transparent,
                          collapsedBackgroundColor: Colors.transparent,
                        ),
                      ),
                      child: ExpansionTile(
                        controller: controller,
                        key: PageStorageKey<int>(index),
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        title: Text(
                          video["title"]!,
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            // Collapse the previously expanded tile
                            if (_activeController != null &&
                                _activeController != controller) {
                              _activeController!.collapse();
                              context.read<VideoPlayerCubit>().stopVideo();
                            }
                            _activeController = controller;

                            // Play the video for the current tile
                            context
                                .read<VideoPlayerCubit>()
                                .playVideo(video["url"]!, index);
                          } else {
                            if (_activeController == controller) {
                              _activeController = null;
                            }
                            context.read<VideoPlayerCubit>().stopVideo();
                          }
                        },
                        children: [
                          BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
                            builder: (context, state) {
                              if (state is VideoLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is VideoPlaying ||
                                  state is VideoPaused) {
                                var controller = state is VideoPlaying
                                    ? state.controller
                                    : (state as VideoPaused).controller;
                                return Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    ),
                                    VideoProgressIndicator(controller,
                                        allowScrubbing: true),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.replay_5,
                                              color: Colors.white),
                                          onPressed: () {
                                            context
                                                .read<VideoPlayerCubit>()
                                                .skipBackward();
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            controller.value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            if (controller.value.isPlaying) {
                                              context
                                                  .read<VideoPlayerCubit>()
                                                  .pauseVideo();
                                            } else {
                                              context
                                                  .read<VideoPlayerCubit>()
                                                  .resumeVideo();
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.forward_5,
                                              color: Colors.white),
                                          onPressed: () {
                                            context
                                                .read<VideoPlayerCubit>()
                                                .skipForward();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else if (state is VideoError) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state.error,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
