import 'dart:convert';
import 'package:flutter/services.dart';

class Surah {
  final String place;
  final String type;
  final int count;
  final int revelationOrder;
  final int rukus;
  final String title;
  final String titleAr;
  final String titleEn;
  final String index;
  final String pages;
  final String page;
  final int start;
  final List<Juz> juz;

  Surah({
    required this.place,
    required this.type,
    required this.count,
    required this.revelationOrder,
    required this.rukus,
    required this.title,
    required this.titleAr,
    required this.titleEn,
    required this.index,
    required this.pages,
    required this.page,
    required this.start,
    required this.juz,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var juzList = json['juz'] as List;
    List<Juz> juz = juzList.map((i) => Juz.fromJson(i)).toList();

    return Surah(
      place: json['place'],
      type: json['type'],
      count: json['count'],
      revelationOrder: json['revelationOrder'],
      rukus: json['rukus'],
      title: json['title'],
      titleAr: json['titleAr'],
      titleEn: json['titleEn'],
      index: json['index'],
      pages: json['pages'],
      page: json['page'],
      start: json['start'],
      juz: juz,
    );
  }
}

class Juz {
  final String index;
  final Verse verse;

  Juz({
    required this.index,
    required this.verse,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      index: json['index'],
      verse: Verse.fromJson(json['verse']),
    );
  }
}

class Verse {
  final String start;
  final String end;

  Verse({
    required this.start,
    required this.end,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      start: json['start'],
      end: json['end'],
    );
  }
}

class QuranPage {
  final String index;
  final PageDetail start;
  final PageDetail end;

  QuranPage({
    required this.index,
    required this.start,
    required this.end,
  });

  factory QuranPage.fromJson(Map<String, dynamic> json) {
    return QuranPage(
      index: json['index'],
      start: PageDetail.fromJson(json['start']),
      end: PageDetail.fromJson(json['end']),
    );
  }
}

class PageDetail {
  final String index;
  final String verse;
  final String name;
  final String nameAr;

  PageDetail({
    required this.index,
    required this.verse,
    required this.name,
    required this.nameAr,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) {
    return PageDetail(
      index: json['index'],
      verse: json['verse'],
      name: json['name'],
      nameAr: json['nameAr'],
    );
  }
}

Future<List<Surah>> loadSurahInfo() async {
  String jsonString =
      await rootBundle.loadString('assets/quran_metadata/surah.json');
  List<dynamic> jsonResponse = jsonDecode(jsonString);
  return jsonResponse.map<Surah>((json) => Surah.fromJson(json)).toList();
}

Future<List<QuranPage>> loadPageInfo() async {
  String jsonString =
      await rootBundle.loadString('assets/quran_metadata/page.json');
  List<dynamic> jsonResponse = jsonDecode(jsonString);
  return jsonResponse
      .map<QuranPage>((json) => QuranPage.fromJson(json))
      .toList();
}
