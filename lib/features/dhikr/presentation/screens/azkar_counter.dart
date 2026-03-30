import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/core/theme/app_text_styles.dart';
import 'package:eghtanem_app/widgets/back_button.dart';
import 'package:eghtanem_app/models/counter.dart';
import 'package:eghtanem_app/features/dhikr/data/models/azkar_json.dart';

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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F3EE),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary1,
                  AppColors.primary1.withValues(alpha: 0.9),
                  AppColors.primary0.withValues(alpha: 0.3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary0.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const CustomBackButton(),
              title: Text(
                widget.category.category,
                style: AppTextStyles.headingsH2.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: Column(
          children: [
            // Progress indicator
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: (currentDhikrIndex + 1) / widget.category.array.length,
                  backgroundColor: AppColors.primary0.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary0),
                  minHeight: 6.h,
                ),
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.white,
                          AppColors.primary0.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.primary0.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary0.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
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
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white,
                    AppColors.primary0.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primary0.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary0.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                      // Reset button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary0.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              counter.reset();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary0,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(16.w),
                            elevation: 0,
                          ),
                          child: Icon(
                            Icons.refresh,
                            color: AppColors.primary0,
                            size: 24.sp,
                          ),
                        ),
                      ),
                      // Main counter button
                      GestureDetector(
                        onTap: _incrementCounter,
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary0,
                                AppColors.primary0.withValues(alpha: 0.9),
                                AppColors.primary1.withValues(alpha: 0.3),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary0.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                                color:
                                    AppColors.primary0.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'سبح',
                              style: AppTextStyles.headingsH4.copyWith(
                                color: Colors.white,
                                fontSize: 18.sp,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Decrement button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary0.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: counter.count > 0
                              ? () {
                                  setState(() {
                                    counter.decrement();
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary0,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(16.w),
                            elevation: 0,
                          ),
                          child: Icon(
                            Icons.remove,
                            color: AppColors.primary0,
                            size: 24.sp,
                          ),
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary0.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: currentDhikrIndex > 0 ? _previousDhikr : null,
                      icon: const Icon(Icons.arrow_back_ios),
                      label: const Text('السابق'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary0,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  Text(
                    '${currentDhikrIndex + 1} من ${widget.category.array.length}',
                    style: AppTextStyles.headingsH5.copyWith(
                      color: AppColors.primary0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary0.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed:
                          currentDhikrIndex < widget.category.array.length - 1
                              ? _nextDhikr
                              : null,
                      icon: const Icon(Icons.arrow_forward_ios),
                      label: const Text('التالي'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary0,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
