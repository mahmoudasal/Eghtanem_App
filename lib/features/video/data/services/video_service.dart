import 'package:dio/dio.dart';
import 'package:egtanem_application/core/constants/api_endpoints.dart';
import 'package:egtanem_application/core/utilities/secure_storage.dart';
import 'package:egtanem_application/features/home/data/models/comment_model.dart';
import 'package:egtanem_application/features/home/data/models/like_response.dart';
import 'package:egtanem_application/features/video/data/models/video_model.dart';
import 'package:retrofit/retrofit.dart';


part 'video_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl )
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

class VideoServiceImplementation implements VideoService {
  final Dio dio;
  late final VideoService _videoService;

  VideoServiceImplementation() : dio = Dio() {
    // Add auth interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    _videoService = _VideoService(dio); // Initialize the actual service
  }

  @override
  Future<List<Video>> getAllVideos() {
    return _videoService.getAllVideos();
  }

  @override
  Future<Video> getOneVideo(int id) {
    return _videoService.getOneVideo(id);
  }

  @override
  Future<Comment> addComment(int videoId, String comment) {
    return _videoService.addComment(videoId, comment);
  }

  @override
  Future<LikeResponse> likeVideo(int videoId) {
    return _videoService.likeVideo(videoId);
  }
}
