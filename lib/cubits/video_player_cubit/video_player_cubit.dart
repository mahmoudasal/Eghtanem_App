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
            hideThumbnail: false),
      );

      // Check if controller is successfully created
      if (_videoController == null) {
        throw Exception("Failed to initialize YoutubePlayerController.");
      }

      emit(VideoPlayerLoaded(
        videoController: _videoController!,
        isPlaying: true,
      ));
    } catch (e) {
      _logger.e("Error loading video: $e");
      emit(VideoPlayerError(errorMessage: "Failed to load video: $e"));
    }
  }

  void playPauseVideo(bool isPlaying) {
    if (_videoController != null && state is VideoPlayerLoaded) {
      try {
        if (isPlaying) {
          _videoController?.play();
        } else {
          _videoController?.pause();
        }
        emit(VideoPlayerLoaded(
          videoController: _videoController!,
          isPlaying: isPlaying,
        ));
      } catch (e) {
        _logger.e("Error playing/pausing video: $e");
        emit(VideoPlayerError(errorMessage: "Failed to play/pause video: $e"));
      }
    } else {
      _logger.w("VideoController is null or state is not VideoPlayerLoaded");
    }
  }

  @override
  Future<void> close() async {
    // Dispose the video controller and set it to null
    if (_videoController != null) {
      _videoController!.dispose();
      _videoController = null;
    }
    return super.close();
  }

  String formatLikes(String likes) {
    final int likesCount = int.tryParse(likes) ?? 0;
    if (likesCount > 999) {
      return '${(likesCount / 1000).toStringAsFixed(1)}k';
    }
    return likes;
  }
}
