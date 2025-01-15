import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import 'categories/categories.dart';
import 'home_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const String id = 'ShortsScreen';
  final Map<String, dynamic>? youtubeData;

  const NavigationScreen({super.key, required this.youtubeData});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const CategoriesPage(),
      ShortsListPage(youtubeData: widget.youtubeData)
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12.5,
        unselectedFontSize: 11,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        backgroundColor: currentIndex == 1 ? Colors.black : AppColors.primary1,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 0
                  ? "assets/ui icons/category_selected.svg"
                  : "assets/ui icons/category.svg",
              height: 24,
            ),
            label: 'التصنيفات',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 1
                  ? "assets/ui icons/home.svg"
                  : "assets/ui icons/home_unselected.svg",
              height: 24,
            ),
            label: 'الرئيسية',
          ),
        ],
        selectedItemColor: AppColors.primary0,
        unselectedItemColor: const Color(0xffF2EEEB),
        showUnselectedLabels: true,
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
  final List<Map<String, dynamic>> _mediaItems = [
    {
      'channelTitle': 'Sample Channel 1',
      'channelPic': 'https://picsum.photos/200',
      'videoId': 'sample_video_1',
      'title': 'Sample Video 1',
      'likes': 1000,
      'comments': 100,
    },
    {
      'channelTitle': 'Sample Channel 2',
      'channelPic': 'https://picsum.photos/201',
      'videoId': 'sample_video_2',
      'title': 'Sample Video 2',
      'likes': 2000,
      'comments': 200,
    },
    // Add more sample items as needed
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _mediaItems.length,
      itemBuilder: (context, index) {
        final short = _mediaItems[index];
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
}