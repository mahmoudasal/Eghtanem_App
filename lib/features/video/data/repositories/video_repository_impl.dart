import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:eghtanem_app/features/video/data/models/video_model.dart';
import 'package:eghtanem_app/features/video/data/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  List<Video>? _cachedVideos;

  @override
  Future<List<Video>> getAllVideos() async {
    if (_cachedVideos != null) return _cachedVideos!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/videos.json');
      final jsonData = json.decode(jsonString) as List<dynamic>;
      _cachedVideos = jsonData.map((video) => Video.fromJson(video)).toList();
      return _cachedVideos!;
    } catch (e) {
      throw Exception('Failed to load videos: $e');
    }
  }

  @override
  Future<Video> getOneVideo(int id) async {
    final videos = await getAllVideos();
    try {
      return videos.firstWhere((video) => video.id == id);
    } catch (e) {
      throw Exception('Video with id $id not found');
    }
  }
}
