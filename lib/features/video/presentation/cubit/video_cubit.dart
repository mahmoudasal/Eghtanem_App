import 'package:egtanem_application/features/video/data/models/video_model.dart';
import 'package:egtanem_application/features/video/data/repositories/video_repository.dart';
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
        final updatedVideos = (state as VideoLoaded)
            .videos
            .map((v) => v.id == videoId ? v.copyWith(likesCount: v.likesCount + 1) : v)
            .toList();
        emit(VideoLoaded(updatedVideos));
      }
    } catch (e) {
      emit(VideoError('Failed to like video'));
    }
  }
}