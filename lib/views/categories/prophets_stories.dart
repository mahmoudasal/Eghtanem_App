import 'package:egtanem_application/cubits/prophet_stories/prophet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProphetsStories extends StatefulWidget {
  const ProphetsStories({super.key});

  @override
  ProphetsStoriesState createState() => ProphetsStoriesState();
}

class ProphetsStoriesState extends State<ProphetsStories> {
  final List<Map<String, String>> videos = const [
    {
      "title": "قصة بداية الخلق وكيف خلق الله العالم وخلق آدم عليه السلام",
      "url": "https://www.youtube.com/watch?v=pB7uZzu2dLI"
    },
    {
      "title":
          "فسجد الملائكة، قصة سجود الملائكة لآدم عليه السلام و عصيان إبليس لأمر الله",
      "url": "https://www.youtube.com/watch?v=8UTKSiLnL7o"
    },
    {
      "title": "قصة الشجرة التي نهى عنها آدم عليه السلام",
      "url": "https://www.youtube.com/watch?v=MLuVgXMFAJs"
    },
    {
      "title": "قصة هابيل و قابيل و أول جريمة قتل في التاريخ",
      "url": "https://www.youtube.com/watch?v=8fAUzFl5eRI"
    },
    {
      "title": "قصة أول رسول يبعثه الله لأهل الأرض",
      "url": "https://www.youtube.com/watch?v=8HOQIKt3uUQ"
    },
    {
      "title": "قصة نوح عليه السلام و صناعة الفلك",
      "url": "https://www.youtube.com/watch?v=JifgWr2Xo0M"
    },
    {
      "title": "قصة نوح عليه السلام و الطوفان العظيم",
      "url": "https://www.youtube.com/watch?v=RJpQo78JvT8"
    },
    {
      "title": "هود عليه السلام يتحدى قوم عاد الجبابرة",
      "url": "https://www.youtube.com/watch?v=DdPCewixmUk"
    },
    {
      "title": "الريح العقيم و كيف أهلك الله قوم عاد بعد تجبرهم",
      "url": "https://www.youtube.com/watch?v=AS0SIybXFGg"
    },
    {
      "title": "قصة نبي الله صالح عليه السلام و إستكبار ثمود",
      "url": "https://www.youtube.com/watch?v=ZBYdoe5fNa4"
    },
    {
      "title": "قصة ناقة الله و كيف اهلك الله ثمود",
      "url": "https://www.youtube.com/watch?v=I1dUAtzk5gM"
    },
    {
      "title": "نشيدة خير الخلق  أحمد النفيس  برنامج قصص الأنبياء",
      "url": "https://www.youtube.com/watch?v=SGVaXPc__g0"
    },
    {
      "title": "قصة التسعة رهط المفسدين مع نبي الله صالح",
      "url": "https://www.youtube.com/watch?v=FTPhkGxAA3g"
    },
    {
      "title": "قصة خليل الله إبراهيم عليه السلام",
      "url": "https://www.youtube.com/watch?v=LZzTxnKPo5w"
    },
    {
      "title": "قصة إبراهيم عليه السلام و تحطيم الأصنام",
      "url": "https://www.youtube.com/watch?v=6AuGZgzuUd0"
    },
    {
      "title": "قصة إبراهيم عليه السلام مع النمرود أعتى ملوك الأرض",
      "url": "https://www.youtube.com/watch?v=mbmCUY8iaJA"
    },
    {
      "title":
          "نار لا تحرق معجزة نبي الله إبراهيم عليه السلام و خروجه من النار سالماً",
      "url": "https://www.youtube.com/watch?v=N8CUpZr8SHk"
    },
    {
      "title":
          "سيدنا ابراهيم يترك السيدة هاجر وإسماعيل عليهم السلام فى الصحراء بأمر من الله",
      "url": "https://www.youtube.com/watch?v=VQpvw49HG0Q"
    },
    {
      "title": "قصة الذبيح إسماعيل عليه السلام",
      "url": "https://www.youtube.com/watch?v=K2KHCxpGJ1s"
    },
    {
      "title": "قصة فاحشة سدوم و النهاية المفزعة لهم",
      "url": "https://www.youtube.com/watch?v=wVd6CdWhwhM"
    },
    {
      "title": "قصة بناء إبراهيم و إسماعيل عليهما السلام البيت الحرام",
      "url": "https://www.youtube.com/watch?v=k4nk2i6PEQo"
    },
    {
      "title": "أربعة من الطير .. ماذا طلب إبراهيم الخليل من ربه ؟",
      "url": "https://www.youtube.com/watch?v=SmyDB6MxvjM"
    },
    {
      "title": "قصة رؤيا يوسف عليه السلام و حسد إخوته",
      "url": "https://www.youtube.com/watch?v=Yfxzxd25s_s"
    },
    {
      "title": "قصة يوسف عليه السلام و أكذوبة الذئب",
      "url": "https://www.youtube.com/watch?v=iWLabR0VJqE"
    },
    {
      "title": "يوسف الصديق عليه السلام و فتنة داخل قصر عزيز مصر",
      "url": "https://www.youtube.com/watch?v=bmIRaxIlGj4"
    },
    {
      "title": "قصة يوسف عليه السلام و ماذا حدث داخل السجن",
      "url": "https://www.youtube.com/watch?v=PK91XcehU8I"
    },
    {
      "title": "يوسف الصديق عليه السلام عزيزًا لمصر",
      "url": "https://www.youtube.com/watch?v=-7Dvnyg8q3k"
    },
    {
      "title": "لقاء نبي الله يوسف الصديق بأخيه بعد فراق طويل",
      "url": "https://www.youtube.com/watch?v=QK2gqqETvDw"
    },
    {
      "title": "رؤيا يوسف الصديق عليه السلام تتحقق",
      "url": "https://www.youtube.com/watch?v=6zifF1cJJkU"
    },
    {
      "title": "ومضات (١) من قصص الأنبياء",
      "url": "https://www.youtube.com/watch?v=pekXxazOgsg"
    },
    {
      "title": "ومضات (2) من قصص الأنبياء",
      "url": "https://www.youtube.com/watch?v=xrtXvmyHxEA"
    },
    {
      "title": "قصة شعيب عليه السلام",
      "url": "https://www.youtube.com/watch?v=G41XJo_Z-OM"
    },
    {
      "title": "قصة أيوب عليه السلام",
      "url": "https://www.youtube.com/watch?v=UQ3eIbiij5g"
    },
    {
      "title": "قصة يونس عليه السلام و ماذا حدث في بطن الحوت",
      "url": "https://www.youtube.com/watch?v=euSfGzg0MFo"
    },
    {
      "title": "قصة كليم الله موسى عليه السلام  الجزء الاول",
      "url": "https://www.youtube.com/watch?v=Aw4FLH5c6dM"
    },
    {
      "title": "قصة كليم الله موسى عليه السلام و خروجه من مصر إلى أرض مدين",
      "url": "https://www.youtube.com/watch?v=sIRAxluOYEk"
    },
    {
      "title": "قصة موسى عليه السلام الجزء الثالث",
      "url": "https://www.youtube.com/watch?v=WDsBN-AimRY"
    },
    {
      "title": "قصة موسى عليه السلام الجزء الرابع",
      "url": "https://www.youtube.com/watch?v=l4Z36KvRBus"
    },
    {
      "title": "قصة موسى عليه السلام الجزء الخامس",
      "url": "https://www.youtube.com/watch?v=ct3azvIgxGU"
    },
    {
      "title": "قصة موسى عليه السلام الجزء السابع",
      "url": "https://www.youtube.com/watch?v=DvII6sqUP3Q"
    },
    {
      "title": "قصة موسى عليه السلام الجزء الثامن",
      "url": "https://www.youtube.com/watch?v=3PAxnK3fids"
    },
    {
      "title": "قصة موسى عليه السلام الجزء التاسع",
      "url": "https://www.youtube.com/watch?v=xE6xA4kWllk"
    },
    {
      "title": "قصة موسى عليه السلام الجزء العاشر",
      "url": "https://www.youtube.com/watch?v=qYTany6MxlU"
    },
    {
      "title": "قصة موسى عليه السلام الجزء الثالث عشر",
      "url": "https://www.youtube.com/watch?v=KqSL3jT8v-E"
    }
  ];

  late VideoPlayerCubit _videoPlayerCubit;

  @override
  void initState() {
    super.initState();
    _videoPlayerCubit = VideoPlayerCubit();
  }

  @override
  void dispose() {
    _videoPlayerCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _videoPlayerCubit,
      child: WillPopScope(
        onWillPop: () async {
          _videoPlayerCubit.stopVideo();
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color(0xff1D1D1B),
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            toolbarHeight: 100.h,
            centerTitle: true,
            backgroundColor: const Color(0xff1D1D1B),
            shadowColor: const Color(0xff1D1D1B),
            foregroundColor: const Color(0xff1D1D1B),
            title: Text(
              'قصص الأنبياء',
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
                      _videoPlayerCubit.stopVideo();
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
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        dividerColor: Colors.transparent,
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
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onExpansionChanged: (bool expanded) {
                          final cubit = _videoPlayerCubit;
                          if (expanded) {
                            // Collapse the previously expanded tile
                            if (cubit.currentlyExpandedIndex != null &&
                                cubit.currentlyExpandedIndex != index) {
                              cubit.collapseTile(cubit.currentlyExpandedIndex!);
                            }

                            // Play the video for the current tile
                            cubit.playVideo(video["url"]!, index);
                          } else {
                            // Stop the video if the tile is collapsed
                            if (cubit.currentlyExpandedIndex == index) {
                              cubit.stopVideo();
                            }
                          }
                        },
                        children: [
                          BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
                            builder: (context, state) {
                              final cubit = _videoPlayerCubit;
                              if (state is VideoLoading &&
                                  cubit.currentlyExpandedIndex == index) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if ((state is VideoPlaying ||
                                      state is VideoPaused) &&
                                  cubit.currentlyExpandedIndex == index) {
                                final controller = state.controller;
                                return Column(
                                  children: [
                                    YoutubePlayer(
                                      controller: controller,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: Colors.red,
                                      progressColors: const ProgressBarColors(
                                        playedColor: Colors.red,
                                        handleColor: Colors.redAccent,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.replay_5,
                                              color: Colors.white),
                                          onPressed: () {
                                            cubit.skipBackward();
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
                                              cubit.pauseVideo();
                                            } else {
                                              cubit.resumeVideo();
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.forward_5,
                                              color: Colors.white),
                                          onPressed: () {
                                            cubit.skipForward();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else if (state is VideoError &&
                                  cubit.currentlyExpandedIndex == index) {
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
