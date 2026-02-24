import 'package:eghtanem_app/widgets/back_button.dart';
import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/core/utilities/string_utils.dart';

import 'package:eghtanem_app/features/quran/data/models/surah_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurahPage extends StatefulWidget {
  final Surah surah;

  const SurahPage({super.key, required this.surah});

  @override
  SurahPageState createState() => SurahPageState();
}

class SurahPageState extends State<SurahPage>
    with SingleTickerProviderStateMixin {
  bool _showPageStyle = true;
  List<List<Verse>> _screenPages = [];
  late PageController _pageController;
  int _currentPageIndex = 0;
  late AnimationController _animationController;
  bool _isDraggingSlider = false;
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _groupVersesByScreenHeight(double availableHeight) {
    _screenPages = [];
    List<Verse> currentPage = [];
    double currentHeight = 0;

    // Calculate based on actual text styling
    // fontSize: 22.sp, lineHeight: 1.8
    const double baseLineHeight = 22 * 1.8; // 39.6
    const double averageCharsPerLine =
        68; // Characters per line in justified text
    const double verseNumberSpace = 5; // Small space for verse number

    for (var verse in widget.surah.verses) {
      // Estimate lines needed for this verse (text length + verse number chars)
      final totalChars =
          verse.text.ar.length + 8; // +8 for verse number display
      final int estimatedLines =
          (totalChars / averageCharsPerLine).ceil().clamp(1, 100);
      final double verseHeight =
          (baseLineHeight * estimatedLines) + verseNumberSpace;

      if (currentHeight + verseHeight > availableHeight &&
          currentPage.isNotEmpty) {
        // Current page is full, start a new page
        _screenPages.add(List.from(currentPage));
        currentPage = [verse];
        currentHeight = verseHeight;
      } else {
        currentPage.add(verse);
        currentHeight += verseHeight;
      }
    }

    // Add the last page if it has verses
    if (currentPage.isNotEmpty) {
      _screenPages.add(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            scrolledUnderElevation: 0.0,
            toolbarHeight: 70.h,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary0.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    _showPageStyle
                        ? Icons.view_list_rounded
                        : Icons.menu_book_rounded,
                    key: ValueKey(_showPageStyle),
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showPageStyle = !_showPageStyle;
                    _screenPages = []; // Reset pages when toggling
                    _animationController.reset();
                    _animationController.forward();
                  });
                },
              ),
            ),
            title: Column(
              children: [
                Text(
                  widget.surah.name.ar,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontFamily: 'hafs',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${widget.surah.verses.length} آيات',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary0.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const CustomBackButton(),
              ),
            ],
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _animationController,
      child: _showPageStyle ? _buildPageView() : _buildVerseList(),
    );
  }

  Widget _buildPageView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available height (total height - slider height ~80h)
        final availableHeight = constraints.maxHeight - 80.h;

        // Group verses by screen height if not already done
        if (_screenPages.isEmpty) {
          _groupVersesByScreenHeight(availableHeight);
        }

        return Stack(
          children: [
            // Decorative background
            Positioned.fill(
              child: CustomPaint(
                painter: IslamicPatternPainter(),
              ),
            ),
            // Main content
            PageView.builder(
              reverse: true,
              controller: _pageController,
              itemCount: _screenPages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                  _sliderValue = index.toDouble();
                });
              },
              itemBuilder: (context, pageIndex) {
                final verses = _screenPages[pageIndex];
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 15.h),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RichText(
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: _buildPageTextSpans(verses),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Interactive Slider with Popup
            if (_screenPages.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Popup overlay when dragging
                    if (_isDraggingSlider)
                      Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2B),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'صفحة ${convertToArabicNumeral(_getPageNumberForIndex(_sliderValue.round()))}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              widget.surah.name.ar,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontFamily: 'hafs',
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Slider
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4.h,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 12.r,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 20.r,
                            ),
                            activeTrackColor: AppColors.primary0,
                            inactiveTrackColor:
                                Colors.grey.withValues(alpha: 0.3),
                            thumbColor: AppColors.primary0,
                            overlayColor:
                                AppColors.primary0.withValues(alpha: 0.3),
                          ),
                          child: Slider(
                            value: _sliderValue,
                            min: 0,
                            max: (_screenPages.length - 1).toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                                _isDraggingSlider = true;
                              });
                            },
                            onChangeEnd: (value) {
                              setState(() {
                                _isDraggingSlider = false;
                                final pageIndex = value.round();
                                _currentPageIndex = pageIndex;
                                _pageController.animateToPage(
                                  pageIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  // Helper method to get the actual Quran page number for a given screen page index
  int _getPageNumberForIndex(int index) {
    if (index >= 0 && index < _screenPages.length) {
      final verses = _screenPages[index];
      if (verses.isNotEmpty) {
        return verses.first.page;
      }
    }
    return 1;
  }

  List<TextSpan> _buildPageTextSpans(List<Verse> verses) {
    List<TextSpan> spans = [];
    for (var verse in verses) {
      spans.addAll([
        TextSpan(
          text: '${verse.text.ar} ',
          style: TextStyle(
            fontSize: 22.sp,
            fontFamily: 'hafs',
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            height: 1.8,
            letterSpacing: 0.3,
          ),
        ),
        TextSpan(
          text: ' ﴿${convertToArabicNumeral(verse.number)}﴾ ',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.primary0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]);
    }
    return spans;
  }

  Widget _buildVerseList() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F3EE),
      ),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: widget.surah.verses.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final verse = widget.surah.verses[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 50)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary0.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.primary0.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Verse header with number
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          AppColors.primary0.withValues(alpha: 0.1),
                          AppColors.primary0.withValues(alpha: 0.02),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Decorative element
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary0.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'صفحة ${convertToArabicNumeral(verse.page)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.primary0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Verse number with decorative design
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 48.sp,
                              color: AppColors.primary0.withValues(alpha: 0.15),
                            ),
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary0.withValues(alpha: 0.9),
                                    AppColors.primary0.withValues(alpha: 0.7),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary0
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                convertToArabicNumeral(verse.number),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Verse text
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Text(
                        verse.text.ar,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontFamily: 'hafs',
                          color: AppColors.textPrimary,
                          height: 2.0,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  // Bottom decorative line
                  Container(
                    height: 3.h,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          AppColors.primary0.withValues(alpha: 0.3),
                          AppColors.primary0.withValues(alpha: 0.0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter for decorative Islamic pattern background
class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary0.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 60.0;

    // Draw geometric pattern
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Draw star pattern
        final path = Path();
        final center = Offset(x, y);
        final radius = 20.0;

        for (int i = 0; i < 8; i++) {
          final angle = (i * 45) * 3.14159 / 180;
          final point = Offset(
            center.dx + radius * cos(angle),
            center.dy + radius * sin(angle),
          );
          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper function for cosine
double cos(double radians) {
  return radians.isNaN ? 0 : (radians == 0 ? 1 : _cos(radians));
}

double _cos(double x) {
  // Simple cosine approximation
  x = x % (2 * 3.14159);
  if (x < 0) x = -x;
  if (x > 3.14159) x = 2 * 3.14159 - x;

  final x2 = x * x;
  return 1 - x2 / 2 + x2 * x2 / 24 - x2 * x2 * x2 / 720;
}

// Helper function for sine
double sin(double radians) {
  return cos(radians - 3.14159 / 2);
}
