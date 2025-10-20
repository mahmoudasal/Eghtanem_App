import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../home/data/models/comment_model.dart';
import '../../../home/data/models/like_response.dart';
import '../models/video_model.dart';

part 'video_service.g.dart';

@RestApi()
abstract class VideoService {
  factory VideoService(Dio dio) = _VideoService;

  @GET("videos")
  Future<List<Video>> getAllVideos();

  @GET("video/{id}")
  Future<Video> getOneVideo(@Path("id") int id);

  @POST("videos/{id}/comments")
  @FormUrlEncoded()
  Future<Comment> addComment(
    @Path("id") int videoId,
    @Field("comment") String comment,
  );

  @PATCH("videos/{id}/like")
  Future<LikeResponse> likeVideo(@Path("id") int videoId);
}
