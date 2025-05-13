import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:egtanem_application/features/video/data/services/video_service.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../home/data/models/comment_model.dart';
import '../../../home/data/models/like_response.dart';
import '../models/video_model.dart';

import 'video_repository.dart';
import '../../../../core/errors/exceptions.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoService _videoService;

  VideoRepositoryImpl(this._videoService);

  @override
  Future<List<Video>> getAllVideos() async {
    try {
      // Load videos from local JSON file
      final String jsonString =
          await rootBundle.loadString('assets/data/videos.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      final videos = jsonData.map((video) => Video.fromJson(video)).toList();

      return videos;
    } catch (e) {
      throw Exception('Failed to load videos: ${e.toString()}');
    }
  }

  @override
  Future<Video> getOneVideo(int id) async {
    try {
      // Load video from local JSON file
      final String jsonString =
          await rootBundle.loadString('assets/data/videos.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      final videoData = jsonData.firstWhere((video) => video['id'] == id,
          orElse: () => throw Exception('Video not found'));
      return Video.fromJson(videoData);
    } catch (e) {
      throw Exception('Failed to load video: ${e.toString()}');
    }
  }

  @override
  Future<Comment> addComment(
      {required int videoId, required String comment}) async {
    try {
      // For now, we'll keep the API call since we're focusing on video loading
      return await _videoService.addComment(videoId, comment);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw Exception('Failed to add comment: ${e.toString()}');
    }
  }

  @override
  Future<LikeResponse> likeVideo(int videoId) async {
    try {
      // For now, we'll keep the API call since we're focusing on video loading
      return await _videoService.likeVideo(videoId);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw Exception('Failed to like video: ${e.toString()}');
    }
  }

  dynamic _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorData = e.response?.data as Map<String, dynamic>?;

    if (statusCode == 422) {
      final errors = errorData?['errors'] ?? 'Validation error';
      throw ValidationException(errors);
    }

    final message = errorData?['message'] ?? 'Failed to connect to server';
    throw ServerException(
      message: message,
      statusCode: statusCode,
      dioException: e,
    );
  }
}
