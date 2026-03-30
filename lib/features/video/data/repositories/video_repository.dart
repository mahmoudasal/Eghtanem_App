import 'package:eghtanem_app/features/video/data/models/video_model.dart';

abstract class VideoRepository {
  Future<List<Video>> getAllVideos();
  Future<Video> getOneVideo(int id);
}
