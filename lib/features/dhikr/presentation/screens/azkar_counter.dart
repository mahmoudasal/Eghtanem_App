import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/back_button.dart';
import '../../../../models/counter.dart';
import '../../data/models/azkar_json.dart';

class AzkarCounter extends StatefulWidget {
  final Category category;

  const AzkarCounter({super.key, required this.category});

  @override
  State<AzkarCounter> createState() => _AzkarCounterState();
}

class _AzkarCounterState extends State<AzkarCounter> {
  int currentDhikrIndex = 0;
  late Counter counter;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    counter = Counter();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _nextDhikr() {
    if (currentDhikrIndex < widget.category.array.length - 1) {
      setState(() {
        currentDhikrIndex++;
        counter.reset();
      });
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousDhikr() {
    if (currentDhikrIndex > 0) {
      setState(() {
        currentDhikrIndex--;
        counter.reset();
      });
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _incrementCounter() {
    setState(() {
      counter.increment();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDhikr = widget.category.array[currentDhikrIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          widget.category.category,
          style: AppTextStyles.headingsH2,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: LinearProgressIndicator(
              value: (currentDhikrIndex + 1) / widget.category.array.length,
              backgroundColor: AppColors.secondary,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary0),
            ),
          ),

          // Dhikr text
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentDhikrIndex = index;
                  counter.reset();
                });
              },
              itemCount: widget.category.array.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(20.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.category.array[index].text,
                      style: AppTextStyles.headingsH4.copyWith(
                        fontSize: 18.sp,
                        height: 1.8,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              },
            ),
          ),

          // Counter section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'العدد المطلوب: ${currentDhikr.count}',
                  style: AppTextStyles.headingsH5.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  '${counter.count}',
                  style: AppTextStyles.headingsH1.copyWith(
                    fontSize: 48.sp,
                    color: AppColors.primary0,
                  ),
                ),
                SizedBox(height: 16.h),

                // Counter buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Decrement button
                    ElevatedButton(
                      onPressed: counter.count > 0
                          ? () {
                              setState(() {
                                counter.decrement();
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(16.w),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: AppColors.textPrimary,
                        size: 24.sp,
                      ),
                    ),
                    // Main counter button
                    GestureDetector(
                      onTap: _incrementCounter,
                      child: Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary0,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary0.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'سبح',
                            style: AppTextStyles.headingsH4.copyWith(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Reset button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          counter.reset();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(16.w),
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: AppColors.textPrimary,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: currentDhikrIndex > 0 ? _previousDhikr : null,
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('السابق'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary0,
                    foregroundColor: Colors.white,
                  ),
                ),
                Text(
                  '${currentDhikrIndex + 1} من ${widget.category.array.length}',
                  style: AppTextStyles.headingsH5,
                ),
                ElevatedButton.icon(
                  onPressed:
                      currentDhikrIndex < widget.category.array.length - 1
                          ? _nextDhikr
                          : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                  label: const Text('التالي'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary0,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
