import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'categories/categories.dart';
import 'home_screen.dart';

class NavigationScreen extends StatefulWidget {
  final Map<String, dynamic> youtubeData;

  const NavigationScreen({super.key, required this.youtubeData});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const CategoriesPage(),
      ShortsScreen(youtubeData: widget.youtubeData),
    ];
  }

  void _onItemTapped(int index) {
    if (index < 0 || index >= _pages.length) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              toolbarHeight: 100.h,
              centerTitle: true,
              backgroundColor: AppColors.primary1,
              title: Text(
                "التصنيفات",
                style: AppTextSytle.headingsH1,
              ),
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary0,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.primary1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'التصنيفات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Shorts',
          ),
        ],
      ),
    );
  }
}

class ShortsScreen extends StatelessWidget {
  final Map<String, dynamic> youtubeData;

  const ShortsScreen({super.key, required this.youtubeData});

  @override
  Widget build(BuildContext context) {
   
    return PageView.builder(
      itemCount: 10, 
      itemBuilder: (context, index) => ShortsList(
        name: "اسم المستخدم",
        caption: "شرح الفيديو هنا...",
        comments: 150,
        likes: 2500,
        vid: "videoId_$index",
        profilePic: "",
        onLike: () {
          // Handle like logic
        },
      ),
    );
  }
}
