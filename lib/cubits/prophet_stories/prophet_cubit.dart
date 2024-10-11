import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:logger/logger.dart';

// Define VideoPlayerStates
abstract class VideoPlayerState extends Equatable {
  @override
  List<Object> get props => [];
  late final YoutubePlayerController controller;
}

class VideoInitial extends VideoPlayerState {}

class VideoLoading extends VideoPlayerState {}

class VideoPlaying extends VideoPlayerState {
  final YoutubePlayerController controller;

  VideoPlaying(this.controller);

  @override
  List<Object> get props => [controller];
}

class VideoPaused extends VideoPlayerState {
  final YoutubePlayerController controller;

  VideoPaused(this.controller);

  @override
  List<Object> get props => [controller];
}

class VideoError extends VideoPlayerState {
  final String error;

  VideoError(this.error);

  @override
  List<Object> get props => [error];
}

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  YoutubePlayerController? _youtubeController;
  final Logger _logger = Logger();
  int? _currentlyExpandedIndex; // Store the index of the expanded tile

  VideoPlayerCubit() : super(VideoInitial());

  int? get currentlyExpandedIndex => _currentlyExpandedIndex;

  void playVideo(String url, int index) {
    try {
      emit(VideoLoading());

      String? videoId = YoutubePlayer.convertUrlToId(url);

      if (videoId != null) {
        // Stop and dispose the previous video controller if necessary
        _disposeVideoController();

        // Initialize the new youtube player controller
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
              controlsVisibleAtStart: false,
              hideControls: true,
              forceHD: false),
        );

        _currentlyExpandedIndex = index; // Set the expanded index

        emit(VideoPlaying(_youtubeController!));
      } else {
        emit(VideoError("Invalid YouTube video URL."));
      }
    } catch (e, stackTrace) {
      _logger.e("Error playing video: $url", e, stackTrace);
      emit(VideoError("Failed to load video. Please try again."));
    }
  }

  void pauseVideo() {
    if (_youtubeController != null && _youtubeController!.value.isPlaying) {
      _youtubeController!.pause();
      emit(VideoPaused(_youtubeController!));
    }
  }

  void resumeVideo() {
    if (_youtubeController != null && !_youtubeController!.value.isPlaying) {
      _youtubeController!.play();
      emit(VideoPlaying(_youtubeController!));
    }
  }

  void stopVideo() {
    _disposeVideoController();
    _currentlyExpandedIndex = null; // Reset expanded index
    emit(VideoInitial());
  }

  void collapseTile(int index) {
    if (_currentlyExpandedIndex == index) {
      stopVideo();
    }
  }

  void _disposeVideoController() {
    if (_youtubeController != null) {
      _logger.i("Disposing YouTube player controller");
      _youtubeController!.pause();
      _youtubeController!.dispose();
      _youtubeController = null;
    }
  }

  void skipForward() {
    if (_youtubeController != null && _youtubeController!.value.isReady) {
      final currentPosition = _youtubeController!.value.position;
      final newPosition = currentPosition + const Duration(seconds: 5);
      _youtubeController!.seekTo(newPosition);
    }
  }

  void skipBackward() {
    if (_youtubeController != null && _youtubeController!.value.isReady) {
      final currentPosition = _youtubeController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 5);
      _youtubeController!.seekTo(newPosition);
    }
  }

  @override
  Future<void> close() {
    _disposeVideoController();
    return super.close();
  }
}
