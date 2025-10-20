import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/comment_model.dart';
import '../../../home/data/models/like_response.dart';
import '../models/video_model.dart';
import '../services/video_service.dart';
import 'video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoService _videoService;
  List<Video>? _cachedVideos;

  VideoRepositoryImpl(this._videoService);

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

  @override
  Future<Comment> addComment({
    required int videoId,
    required String comment,
  }) async {
    try {
      return await _videoService.addComment(videoId, comment);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  @override
  Future<LikeResponse> likeVideo(int videoId) async {
    try {
      return await _videoService.likeVideo(videoId);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to like video: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorData = e.response?.data as Map<String, dynamic>?;

    if (statusCode == 422) {
      final errors = errorData?['errors'] ?? 'Validation error';
      return ValidationException(errors);
    }

    final message = errorData?['message'] ?? 'Failed to connect to server';
    return ServerException(
      message: message,
      statusCode: statusCode,
      dioException: e,
    );
  }
}
