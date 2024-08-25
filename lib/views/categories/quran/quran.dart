import 'dart:convert';

import 'package:egtanem_application/data/qra2at_json_parse.dart';
import 'package:egtanem_application/data/surah_json_parse.dart' as surah_data;
import 'package:egtanem_application/widgets/surah_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/reciter_audio.dart';
import 'package:http/http.dart' as http;

Future<List<Reciter>> fetchReciters() async {
  final response =
      await http.get(Uri.parse('https://mp3quran.net/api/v3/reciters'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final recitersJson = jsonResponse['reciters'] as List<dynamic>;

    // List of reciter names and their corresponding server URLs you want to include
    final Map<String, String> desiredReciters = {
      "مشاري العفاسي": "https://server8.mp3quran.net/afs/",
      "سعد الغامدي": "https://server7.mp3quran.net/s_gmd/",
      "عبدالباسط عبدالصمد":
          "https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/",
      "عبدالرحمن السديس": "https://server11.mp3quran.net/sds/",
      "عبدالعزيز الزهراني": "https://server9.mp3quran.net/zahrani/",
      "عبدالله عواد الجهني": "https://server13.mp3quran.net/jhn/",
      "عبدالله غيلان": "https://server8.mp3quran.net/gulan/",
      "علي جابر": "https://server11.mp3quran.net/a_jbr/",
      "ماهر المعيقلي": "https://server12.mp3quran.net/maher/",
      "محمد ايوب": "https://server8.mp3quran.net/ayyub/",
      "محمد صديق المنشاوي": "https://server10.mp3quran.net/minsh/",
      "محمود علي البنا": "https://server8.mp3quran.net/bna/",
      "منصور السالمي": "https://server14.mp3quran.net/mansor/",
      "ناصر القطامي": "https://server6.mp3quran.net/qtm/",
      "ياسر الدوسري": "https://server11.mp3quran.net/yasser/",
    };

    // Filter reciters based on the desiredReciters list
    final filteredReciters = recitersJson
        .where((reciterJson) {
          final reciter = Reciter.fromJson(reciterJson);
          return desiredReciters.containsKey(reciter.name) &&
              reciter.serverUrl.startsWith(desiredReciters[reciter.name]!);
        })
        .map((json) => Reciter.fromJson(json))
        .toList();

    return filteredReciters;
  } else {
    throw Exception('Failed to load reciters');
  }
}

Future<List<String>> fetchReciterSurahs(int reciterId) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://mp3quran.net/api/v3/reciters?language=eng&rewaya=1&reciter=$reciterId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['reciters'] == null || data['reciters'].isEmpty) {
        throw StateError("No reciters found in the API response");
      }

      final reciterData = data['reciters'].firstWhere(
        (reciter) => reciter['id'] == reciterId,
        orElse: () {
          throw StateError("No reciter found with id $reciterId");
        },
      );

      if (reciterData['moshaf'] == null || reciterData['moshaf'].isEmpty) {
        throw StateError("No moshaf found for the reciter with id $reciterId");
      }

      final List<String> surahList =
          (reciterData['moshaf'][0]['surah_list'] as String)
              .split(',')
              .map((e) => 'Surah $e')
              .toList();

      return surahList;
    } else {
      throw Exception('Failed to load surahs: ${response.reasonPhrase}');
    }
  } catch (e) {
    print("Error fetching reciter surahs: $e");
    rethrow;
  }
}

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
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Color.fromARGB(255, 192, 158, 119),
            labelColor: Color(0xFFFAFAFA),
            unselectedLabelColor: Color(0xFF888888),
            labelStyle: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFFFAFAFA),
            ),
            tabs: [
              Tab(text: 'القراءه'),
              Tab(text: 'الاستماع'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildReadingTab(context),
            buildListeningTab(),
          ],
        ),
      ),
    );
  }

  Widget buildReadingTab(BuildContext context) {
    return FutureBuilder<List<surah_data.Surah>>(
      future: surah_data.loadSurahInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<surah_data.Surah> surahDetails = snapshot.data ?? [];
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
            itemCount: surahDetails.length,
            itemBuilder: (context, index) {
              final surah = surahDetails[index];
              return Column(
                children: [
                  SizedBox(height: 0.02.sh),
                  SurahCard(
                    title: surah.titleAr,
                    surahId: surah.index,
                    page: surah.page, // Pass the page number
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget buildListeningTab() {
    return FutureBuilder<List<Reciter>>(
      future: fetchReciters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Reciter> reciters = snapshot.data ?? [];
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
            children: [
              SizedBox(height: 0.02.sh),
              buildQuranCardList(reciters),
            ],
          );
        }
      },
    );
  }

  Widget buildQuranCardList(List<Reciter> reciters) {
    return Column(
      children: List.generate(
        reciters.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 0.01.sh),
          child: ReciterSurahs(
            title: reciters[index].name,
            reciterId: reciters[index].id,
            serverUrl: reciters[index].serverUrl, // Pass the serverUrl here
          ),
        ),
      ),
    );
  }
}
