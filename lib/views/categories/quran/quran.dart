import 'package:egtanem_application/widgets/telwah_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/custom_card_quran.dart';

class QuranSubCat extends StatelessWidget {
  final String title;

  const QuranSubCat({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xff1D1D1B),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          toolbarHeight: 55.h,
          centerTitle: true,
          backgroundColor: const Color(0xff1D1D1B),
          shadowColor: const Color(0xff1D1D1B),
          foregroundColor: const Color(0xff1D1D1B),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 25.sp,
              height: 1.2,
              color: const Color(0xFFFAFAFA),
            ),
          ),
          leading: const SizedBox(width: 0.0),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 35.w),
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: const Color(0xFFFAFAFA),
            labelColor: const Color(0xFFFAFAFA),
            unselectedLabelColor: const Color(0xFF888888),
            tabs: [
              Tab(text: 'الاستماع'),
              Tab(text: 'القراءه'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildListeningTab(),
            buildReadingTab(),
          ],
        ),
      ),
    );
  }

  Widget buildReadingTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
      children: [
        SizedBox(
          height: 0.05.sh,
        ),
        TelawhCard(title: 'الفاتحة', surahId: '1'),
      ],
    );
  }

  Widget buildListeningTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
      children: [
        buildSectionHeader('استماع 1'),
        buildQuranCardList(),
        buildSectionHeader('استماع 2'),
        buildQuranCardList(),
      ],
    );
  }

  Widget buildSectionHeader(String text) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Image.asset(
          'assets/photo3.png',
          width: 0.21.sw,
          height: 0.1.sh,
          colorBlendMode: BlendMode.plus,
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 25.sp,
            color: const Color(0xFFFAFAFA),
          ),
        )
      ],
    );
  }

  Widget buildQuranCardList() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 0.01.sh),
          child: const QuranCard(
            imagePath: 'images/عبد الباسط profile pic.jpg',
            title: 'عبد الباسط عبد الصمد',
          ),
        ),
      ),
    );
  }
}
