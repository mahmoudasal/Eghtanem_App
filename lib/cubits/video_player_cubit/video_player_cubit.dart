import 'package:bloc/bloc.dart';
import 'package:egtanem_application/cubits/video_player_cubit/video_player_state.dart';
import 'package:logger/logger.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final Logger _logger = Logger();

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit() : super(VideoPlayerInitial());

  YoutubePlayerController? _videoController;

  void loadVideo(String videoId) async {
    try {
      emit(VideoPlayerLoading());

      // Ensure videoId is valid
      if (videoId.isEmpty) {
        throw Exception("Video ID is empty.");
      }

      _videoController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            forceHD: false,
            hideControls: true,
            loop: true,
            controlsVisibleAtStart: false),
      );

      // Check if controller is successfully created
      if (_videoController == null) {
        throw Exception("Failed to initialize YoutubePlayerController.");
      }

      emit(VideoPlayerLoaded(
          videoController: _videoController!, isPlaying: true));
    } catch (e) {
      _logger.i("Error loading video: $e");
      emit(VideoPlayerError(errorMessage: "Failed to load video: $e"));
    }
  }

  void playPauseVideo(bool isPlaying) {
    if (state is VideoPlayerLoaded) {
      if (isPlaying) {
        _videoController?.play();
      } else {
        _videoController?.pause();
      }
      emit(VideoPlayerLoaded(
          videoController: _videoController!, isPlaying: isPlaying));
    }
  }

  @override
  Future<void> close() {
    _videoController?.dispose();
    return super.close();
  }
}

String formatLikes(String likes) {
  final int likesCount = int.tryParse(likes) ?? 0;
  if (likesCount > 999) {
    return '${(likesCount / 1000).toStringAsFixed(1)}k';
  }
  return likes;
}
