import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:egtanem_application/data/surah_json_parse.dart'
    as surah_data; // Alias the import

class SurahPage extends StatelessWidget {
  final String initialPage;

  const SurahPage({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<surah_data.QuranPage>>(
      future: surah_data.loadPageInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<surah_data.QuranPage> pageDetails = snapshot.data ?? [];

          // Find the initial page index
          int initialPageIndex = pageDetails
              .indexWhere((pageDetail) => pageDetail.index == initialPage);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Page $initialPage',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 25.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              backgroundColor: const Color(0xff1D1D1B),
            ),
            body: PageView.builder(
              reverse: true,
              controller: PageController(
                  initialPage: initialPageIndex, viewportFraction: 1.1),
              itemCount: pageDetails.length,
              itemBuilder: (context, index) {
                final pageIndex = int.parse(pageDetails[index].index);

                return Padding(
                  padding: const EdgeInsets.all(.0),
                  child: Image.asset(
                    "assets/quran_images/$pageIndex.png",
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.red, fontSize: 18.sp),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
