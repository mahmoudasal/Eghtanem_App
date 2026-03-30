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
}
