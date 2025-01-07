import 'dart:convert';
import 'package:flutter/services.dart';

class Surah {
  final int count;
  final int revelationOrder;
  final String title;
  final String titleAr;
  final String index;
  final String pages;
  final String page;
  final int start;

  Surah({
    required this.count,
    required this.revelationOrder,
    required this.title,
    required this.titleAr,
    required this.index,
    required this.pages,
    required this.page,
    required this.start,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      count: json['count'],
      revelationOrder: json['revelationOrder'],
      title: json['title'],
      titleAr: json['titleAr'],
      index: json['index'],
      pages: json['pages'],
      page: json['page'],
      start: json['start'],
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
