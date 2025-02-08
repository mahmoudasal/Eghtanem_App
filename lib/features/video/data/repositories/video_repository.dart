import '../../../home/data/models/comment_model.dart';
import '../../../home/data/models/like_response.dart';
import '../models/video_model.dart';

abstract class VideoRepository {
  Future<List<Video>> getAllVideos();
  Future<Video> getOneVideo(int id);
  Future<Comment> addComment({required int videoId, required String comment});
  Future<LikeResponse> likeVideo(int videoId);
}
