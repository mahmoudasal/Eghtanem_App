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

class SurahPageState extends State<SurahPage> {
  bool _showPageStyle = true;
  final Map<int, List<Verse>> _pages = {};

  @override
  void initState() {
    super.initState();
    _groupVersesByPage();
  }

  void _groupVersesByPage() {
    for (var verse in widget.surah.verses) {
      final page = verse.page;
      if (!_pages.containsKey(page)) {
        _pages[page] = [];
      }
      _pages[page]!.add(verse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 55.h,
        centerTitle: true,
        backgroundColor: AppColors.primary1,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        leading: IconButton(
          icon: Icon(
            _showPageStyle ? Icons.list : Icons.book,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _showPageStyle = !_showPageStyle;
            });
          },
        ),
        title: Text(
          widget.surah.name.ar,
          style: TextStyle(
            fontSize: 30.sp,
            fontFamily: 'hafs',
            color: AppColors.primary0,
          ),
        ),
        actions: [const CustomBackButton()],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return _showPageStyle ? _buildPageView() : _buildVerseList();
  }

  Widget _buildPageView() {
    return PageView.builder(
      reverse: true,
      itemCount: _pages.length,
      itemBuilder: (context, pageIndex) {
        final pageNumber = _pages.keys.elementAt(pageIndex);
        final verses = _pages[pageNumber]!;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height - kToolbarHeight - 32.h,
            ),
            child: RichText(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: _buildPageTextSpans(verses),
              ),
            ),
          ),
        );
      },
    );
  }

  List<TextSpan> _buildPageTextSpans(List<Verse> verses) {
    List<TextSpan> spans = [];
    for (var verse in verses) {
      spans.addAll([
        TextSpan(
          text: '${verse.text.ar} ',
          style: TextStyle(
            fontSize: 21.sp,
            fontFamily: 'hafs',
            fontWeight: FontWeight.w400,
            color: Colors.black,
            height: 1.5,
          ),
        ),
        TextSpan(
          text: ' ﴿${convertToArabicNumeral(verse.number)}﴾ ',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.primary0,
          ),
        ),
      ]);
    }
    return spans;
  }

  Widget _buildVerseList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: widget.surah.verses.length,
        separatorBuilder: (context, index) => SizedBox(height: 24.h),
        itemBuilder: (context, index) {
          final verse = widget.surah.verses[index];
          return Stack(
            children: [
              Positioned(
                right: 0,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary0.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    convertToArabicNumeral(verse.number),
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: AppColors.primary0,
                    ),
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, right: 50.w),
                  child: Text(
                    verse.text.ar,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontFamily: 'hafs',
                      color: Colors.black,
                      height: 1.8,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
