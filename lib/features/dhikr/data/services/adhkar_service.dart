// data/services/adhkar_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/azkar_json.dart';

class AdhkarService {
  Future<List<Category>> loadAdhkar() async {
    try {
      final jsonString = await rootBundle.loadString('assets/quran_metadata/adhkar.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load adhkar: $e');
    }
  }
}
