import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../cubits/cubit/media_cubit.dart';
import '../cubits/navigation_cubit/navigation_cubit.dart';
import 'categories/categories.dart';
import 'longvids.dart';
import 'profile.dart';
import 'home_screen.dart';

class NaviagionScreen extends StatelessWidget {
  static const String id = 'ShortsScreen';
  final Map<String, dynamic>? youtubeData;

  const NaviagionScreen({super.key, required this.youtubeData});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      ProfilePage(youtubeData: youtubeData!),
      const LongVids(),
      const CategoriesPage(),
      ShortsListPage(youtubeData: youtubeData),
    ];

    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, currentIndex) {
            return pages[currentIndex];
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
          builder: (context, currentIndex) {
            return BottomNavigationBar(
              selectedFontSize: 12,
              unselectedFontSize: 11,
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<NavigationCubit>().changePage(index);
              },
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
              backgroundColor:
                  currentIndex == 3 ? Colors.black : const Color(0xff1D1D1B),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 0
                        ? "assets/ui icons/profile_selected.svg"
                        : "assets/ui icons/profile.svg",
                    height: 24,
                  ),
                  label: 'الملف الشخصي',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 1
                        ? "assets/ui icons/video-play_selected.svg"
                        : "assets/ui icons/video-play.svg",
                    height: 24,
                  ),
                  label: 'طويلة',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 2
                        ? "assets/ui icons/category_selected.svg"
                        : "assets/ui icons/category.svg",
                    height: 24,
                  ),
                  label: 'التصنيفات',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 3
                        ? "assets/ui icons/home.svg"
                        : "assets/ui icons/home_unselected.svg",
                    height: 24,
                  ),
                  label: 'الرئيسية',
                ),
              ],
              selectedItemColor: const Color.fromARGB(255, 192, 158, 119),
              unselectedItemColor: const Color(0xffF2EEEB),
              showUnselectedLabels: true,
            );
          },
        ),
      ),
    );
  }
}

class ShortsListPage extends StatefulWidget {
  final Map<String, dynamic>? youtubeData;

  const ShortsListPage({super.key, required this.youtubeData});

  @override
  ShortsListPageState createState() => ShortsListPageState();
}

class ShortsListPageState extends State<ShortsListPage> {
  late final PageController _pageController;
  late final MediaCubit _mediaCubit;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _mediaCubit = MediaCubit(mediaType: MediaType.short);
    _mediaCubit.fetchMedia();

    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.position.atEdge) {
      bool isBottom = _pageController.position.pixels != 0;
      if (isBottom && !_mediaCubit.isLoading && _mediaCubit.hasMoreData) {
        _mediaCubit.fetchMedia(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mediaCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediaCubit>.value(
      value: _mediaCubit,
      child: BlocBuilder<MediaCubit, MediaState>(
        builder: (context, state) {
          if (state is MediaLoading && _mediaCubit.mediaItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MediaError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _mediaCubit.mediaItems.length +
                  (_mediaCubit.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _mediaCubit.mediaItems.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final short = _mediaCubit.mediaItems[index];
                return ShortsList(
                  name: short['channelTitle'] ?? '',
                  profilePic: short['channelPic'] ?? '',
                  vid: short['videoId'] ?? '',
                  caption: short['title'] ?? '',
                  likes: short['likes'] ?? 0,
                  comments: short['comments'] ?? 0,
                  youtubeData: widget.youtubeData,
                );
              },
            );
          }
        },
      ),
    );
  }
}
