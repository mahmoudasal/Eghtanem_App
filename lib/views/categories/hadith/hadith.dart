import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/prophet_speech_json.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'liked_hadith.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Prophetspeech extends StatefulWidget {
  const Prophetspeech({super.key});

  @override
  ProphetspeechState createState() => ProphetspeechState();
}

class ProphetspeechState extends State<Prophetspeech> {
  late Future<List<Hadith>> futureHadiths;
  final Set<int> likedHadiths = {};

  @override
  void initState() {
    super.initState();
    futureHadiths = _loadHadiths();
    _loadLikedHadiths();
  }

  Future<List<Hadith>> _loadHadiths() async {
    final String response =
        await rootBundle.loadString('assets/quran_metadata/ibn_maja.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Hadith.fromJson(json)).toList();
  }

  void _loadLikedHadiths() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? likedHadithStrings =
        prefs.getStringList('likedHadiths');

    if (likedHadithStrings != null) {
      setState(() {
        likedHadiths.addAll(likedHadithStrings.map(int.parse));
      });
    }
  }

  void _toggleLike(int hadithNumber) async {
    setState(() {
      if (likedHadiths.contains(hadithNumber)) {
        likedHadiths.remove(hadithNumber);
      } else {
        likedHadiths.add(hadithNumber);
      }
    });

    // Save the updated likedHadiths to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'likedHadiths', likedHadiths.map((e) => e.toString()).toList());
  }

  void _navigateToLikedHadiths() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LikedHadiths(
          likedHadiths: likedHadiths,
          allHadiths: futureHadiths,
        ),
      ),
    ).then((_) {
      setState(() {}); // Refresh the state when coming back
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primary1,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        centerTitle: true,
        backgroundColor: AppColors.primary1,
        shadowColor: AppColors.primary1,
        foregroundColor: AppColors.primary1,
        title: Text("الاحاديث", style: AppTextSytle.headingsH1),
        leading: const SizedBox(width: 0.0),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: _navigateToLikedHadiths,
          ),
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
      ),
      body: FutureBuilder<List<Hadith>>(
        future: futureHadiths,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 24.sp),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No hadiths found.',
                style: TextStyle(color: Colors.white, fontSize: 24.sp),
              ),
            );
          } else {
            final hadiths = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 130.h),
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                final hadith = hadiths[index];
                final isLiked = likedHadiths.contains(hadith.number);
                return Card(
                  color: const Color(0XFF171715),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleLike(hadith.number),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          textDirection: TextDirection.rtl,
                          hadith.hadith,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: const Color(0xFFFAFAFA),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          textDirection: TextDirection.rtl,
                          hadith.description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFFFAFAFA),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
