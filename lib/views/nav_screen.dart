import 'package:egtanem_application/cubits/shorts_cubit/shorts_fetching_cubit.dart';
import 'package:egtanem_application/cubits/video_player_cubit/video_player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubits/navigation_cubit/navigation_cubit.dart';
import 'categories/categories.dart';
import 'longvids.dart';
import 'profile.dart';
import 'home_screen.dart';

class NaviagionScreen extends StatelessWidget {
  static const String id = 'ShortsScreen';
  final Map<String, dynamic> youtubeData;

  const NaviagionScreen({super.key, required this.youtubeData});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ProfilePage(youtubeData: youtubeData),
      const HomeScreen(),
      const CategoriesPage(),
      ShortsListPage(youtubeData: youtubeData),
    ];

    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, currentIndex) {
            return pages[currentIndex];
          },
        ),
        bottomNavigationBar: SizedBox(
          height: 58.h,
          width: 0.99.sw,
          child: BlocBuilder<NavigationCubit, int>(
            builder: (context, currentIndex) {
              return BottomNavigationBar(
                enableFeedback: false,
                selectedFontSize: 12.sp,
                unselectedFontSize: 11.sp,
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<NavigationCubit>().changePage(index);
                },
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w700),
                backgroundColor:
                    currentIndex == 0 || currentIndex == 2 || currentIndex == 1
                        ? const Color(0xff1D1D1B)
                        : const Color.fromARGB(255, 0, 0, 0),
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      height: 30.h,
                      child: SvgPicture.asset(
                        currentIndex == 0
                            ? "assets/ui icons/profile_selected.svg"
                            : "assets/ui icons/profile.svg",
                      ),
                    ),
                    label: 'الملف الشخصي',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      height: 30.h,
                      child: SvgPicture.asset(
                        currentIndex == 1
                            ? "assets/ui icons/video-play_selected.svg"
                            : "assets/ui icons/video-play.svg",
                      ),
                    ),
                    label: 'فيديوهات طويلة',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      height: 30.h,
                      child: SvgPicture.asset(
                        currentIndex == 2
                            ? "assets/ui icons/category_selected.svg"
                            : "assets/ui icons/category.svg",
                      ),
                    ),
                    label: 'التصنيفات',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      height: 30.h,
                      child: SvgPicture.asset(
                        currentIndex == 3
                            ? "assets/ui icons/home.svg"
                            : "assets/ui icons/home_unselected.svg",
                      ),
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
      ),
    );
  }
}

class ShortsListPage extends StatelessWidget {
  final Map<String, dynamic> youtubeData;

  const ShortsListPage({super.key, required this.youtubeData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShortsCubit()..fetchShorts(),
      child: BlocBuilder<ShortsCubit, ShortsState>(
        builder: (context, state) {
          if (state is ShortsLoading &&
              context.read<ShortsCubit>().shorts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ShortsError) {
            return Center(child: Text(state.errorMessage));
          } else if (state is ShortsLoaded) {
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: context.read<ShortsCubit>().shorts.length + 1,
              itemBuilder: (context, index) {
                if (index == context.read<ShortsCubit>().shorts.length) {
                  context.read<ShortsCubit>().fetchShorts(loadMore: true);
                  return const Center(child: CircularProgressIndicator());
                }
                final short = context.read<ShortsCubit>().shorts[index];
                return ShortsList(
                  name: short['channelTitle'],
                  profilePic: short['channelPic'],
                  vid: short['videoId'],
                  caption: short['title'],
                  likes: short['likes'],
                  comments: short['comments'],
                  onLikePressed: () => context
                      .read<ShortsCubit>()
                      .likeVideo(short['videoId'], youtubeData['accessToken']),
                  youtubeData: youtubeData,
                );
              },
            );
          } else {
            return const Center(child: Text('Unknown error occurred.'));
          }
        },
      ),
    );
  }
}
