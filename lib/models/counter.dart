import 'package:egtanem_application/models/azkar_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AzkarCounter extends StatefulWidget {
  final Category category; // Accept the entire category with its dhikr
  const AzkarCounter({super.key, required this.category});

  @override
  AzkarCounterState createState() => AzkarCounterState();
}

class AzkarCounterState extends State<AzkarCounter> {
  late PageController _pageController; // Declare a PageController
  int _currentPage = 0; // Track the current page

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize the PageController
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController when not needed
    super.dispose();
  }

  String getArabicCount(int count) {
    switch (count) {
      case 1:
        return 'مرة واحدة';
      case 2:
        return 'مرتين';
      case 3:
        return 'ثلاث مرات';
      case 4:
        return 'أربع مرات';
      case 7:
        return 'سبع مرات';
      case 10:
        return 'عشرة مرات';
      case 33:
        return 'مره 33';
      case 34:
        return 'مره 34';
      case 100:
        return 'مائة مرة';

      default:
        return '$count مرات';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 250, 246),
      appBar: AppBar(
        backgroundColor: AppColors.primary1,
        scrolledUnderElevation: 0.0,
        toolbarHeight: 61.h,
        centerTitle: true,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        title: Text(
          widget.category.category, // Display category name in AppBar
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        leading: const SizedBox(width: 0.0),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(
                width: 35.w,
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController, // Attach the PageController
            reverse: true, // Set this to true for right-to-left swiping
            itemCount: widget.category.array.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page; // Update the current page index
              });
            },
            itemBuilder: (context, index) {
              final dhikr = widget.category.array[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      dhikr.text, // Display the dhikr text
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                        height:
                            100), // Add padding to leave space for the floating button
                  ],
                ),
              );
            },
          ),
          // Positioned for Arabic count in the bottom-right
          Positioned(
            bottom: 90.h, // Adjust as needed to leave space for FAB
            right: 20.w,
            child: Text(
              getArabicCount(widget.category.array[_currentPage]
                  .count), // Show updated count in Arabic
              style: AppTextSytle.headingsH4,
            ),
          ),
          // Positioned FAB at the bottom-center
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: FloatingActionButton.extended(
              onPressed: () {
                final currentPage = _pageController.page?.toInt() ?? 0;

                // Logic for 'التالي' button, you can move to the next page programmatically
                if (currentPage + 1 < widget.category.array.length) {
                  // If there are more pages
                  _pageController.animateToPage(
                    currentPage + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  Navigator.pop(context); // Finish after last page
                }
              },
              label: Text(
                'التالي',
                style: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
              backgroundColor: AppColors.primary1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
