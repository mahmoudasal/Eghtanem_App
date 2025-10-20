import 'package:eghtanem_app/features/video/data/models/video_model.dart';
import 'package:eghtanem_app/features/video/data/repositories/video_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final VideoRepository _repository;

  VideoCubit(this._repository) : super(VideoInitial());

  Future<void> loadVideos() async {
    emit(VideoLoading());
    try {
      final videos = await _repository.getAllVideos();
      emit(VideoLoaded(videos));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> likeVideo(int videoId) async {
    try {
      await _repository.likeVideo(videoId);

      if (state is VideoLoaded) {
        final videos = (state as VideoLoaded).videos;
        final updatedVideos = videos.map((v) {
          if (v.id == videoId) {
            return Video(
              id: v.id,
              title: v.title,
              description: v.description,
              videoUrl: v.videoUrl,
              thumbnailUrl: v.thumbnailUrl,
              likesCount: v.likesCount + 1,
              comments: v.comments,
            );
          } else {
            return v;
          }
        }).toList();
        emit(VideoLoaded(updatedVideos));
      }
    } catch (e) {
      emit(VideoError('Failed to like video'));
    }
  }
}
