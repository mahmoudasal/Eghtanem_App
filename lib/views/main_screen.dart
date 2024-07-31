import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'categories/categories.dart';
import 'longvids.dart';
import 'profile.dart';
import 'home_screen.dart';
import 'yt_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

YTData ytData = YTData();

class ShortsScreen extends StatefulWidget {
  static const String id = 'ShortsScreen';

  const ShortsScreen({super.key});
  @override
  ShortsScreenState createState() => ShortsScreenState();
}

TextEditingController commentSection = TextEditingController();

class ShortsScreenState extends State<ShortsScreen> {
  int _currentIndex = 3; // Default to the 'الرئيسية' page

  final List<Widget> _pages = [
    const ProfilePage(),
    const HomeScreen(),
    const CategoriesPage(),
    const ShortsListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 58.h,
        width: 0.99.sw,
        child: BottomNavigationBar(
          enableFeedback: false, // Disable ripple effect
          selectedFontSize: 12.sp,
          unselectedFontSize: 11.sp,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          backgroundColor:
              _currentIndex == 0 || _currentIndex == 2 || _currentIndex == 1
                  ? const Color(0xff1D1D1B) // Black color for the first tab
                  : const Color.fromARGB(
                      255, 0, 0, 0), // Different color for other tabs
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 30.h,
                child: SvgPicture.asset(
                  _currentIndex == 0
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
                  _currentIndex == 1
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
                  _currentIndex == 2
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
                  _currentIndex == 3
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
        ),
      ),
    );
  }
}

class ShortsListPage extends StatelessWidget {
  const ShortsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: ytData.shortsList.length,
      itemBuilder: (context, index) {
        var item = ytData.shortsList.values.elementAt(index);
        return ShortsList(
          name: item[0],
          profilePic: item[1],
          vid: item[2],
          caption: item[3],
          likes: item[4],
          comments: item[5],
          hashtags: item[6],
        );
      },
    );
  }
}
