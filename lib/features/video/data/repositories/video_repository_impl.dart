import 'package:dio/dio.dart';
import 'package:egtanem_application/features/video/data/services/video_service.dart';

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
      return await _videoService.getAllVideos();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<Video> getOneVideo(int id) async {
    try {
      return await _videoService.getOneVideo(id);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<Comment> addComment({required int videoId, required String comment}) async {
    try {
      return await _videoService.addComment(videoId, comment);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<LikeResponse> likeVideo(int videoId) async {
    try {
      return await _videoService.likeVideo(videoId);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorData = e.response?.data;

    if (statusCode == 422) {
      throw ValidationException(errorData['errors']);
    }

    throw ServerException(
      message: errorData['message'] ?? 'Failed to connect to the server',e,
      statusCode: statusCode,
    );
  }
}
