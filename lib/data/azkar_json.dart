// models/adhkar_model.dart

import 'dart:convert';

import 'package:flutter/services.dart';

class Dhikr {
  final int id;
  final String text;
  final int count;
  final String audio;
  final String filename;

  Dhikr({
    required this.id,
    required this.text,
    required this.count,
    required this.audio,
    required this.filename,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      id: json['id'],
      text: json['text'],
      count: json['count'],
      audio: json['audio'],
      filename: json['filename'],
    );
  }
}

class Category {
  final int id;
  final String category;
  final String audio;
  final String filename;
  final List<Dhikr> array;

  Category({
    required this.id,
    required this.category,
    required this.audio,
    required this.filename,
    required this.array,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['array'] as List;
    List<Dhikr> arrayList = list.map((i) => Dhikr.fromJson(i)).toList();

    return Category(
      id: json['id'],
      category: json['category'],
      audio: json['audio'],
      filename: json['filename'],
      array: arrayList,
    );
  }
}

class AdhkarService {
  Future<List<Category>> loadAdhkar() async {
    final String response =
        await rootBundle.loadString('assets/quran_metadata/adhkar.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Category.fromJson(json)).toList();
  }
}
