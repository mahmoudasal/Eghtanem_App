import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:logger/logger.dart';

// Define VideoPlayerStates
abstract class VideoPlayerState extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoPlayerState {}

class VideoLoading extends VideoPlayerState {}

class VideoPlaying extends VideoPlayerState {
  final VideoPlayerController controller;

  VideoPlaying(this.controller);

  @override
  List<Object> get props => [controller];
}

class VideoPaused extends VideoPlayerState {
  final VideoPlayerController controller;

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
  VideoPlayerController? _videoController;
  final Logger _logger = Logger();
  int? _currentlyExpandedIndex; // Store the index of the expanded tile

  VideoPlayerCubit() : super(VideoInitial());

  int? get currentlyExpandedIndex => _currentlyExpandedIndex;

  Future<void> playVideo(String url, int index) async {
    try {
      emit(VideoLoading());

      var yt = YoutubeExplode();
      var videoId = VideoId.fromString(url);

      _logger.i("Fetching stream manifest for video: $url");
      var manifest = await yt.videos.streamsClient.getManifest(videoId);

      var streamInfo = manifest.muxed.withHighestBitrate();
      var videoUrl = streamInfo.url.toString();

      _logger.i("Stream URL fetched successfully: $videoUrl");

      // Stop and dispose the previous video controller if necessary
      _disposeVideoController();

      // Initialize the new video controller
      _videoController = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          _videoController!.play();
          _currentlyExpandedIndex = index; // Set the expanded index
          emit(VideoPlaying(_videoController!));
        });

      yt.close();
    } catch (e, stackTrace) {
      _logger.e("Error playing video: $url", e, stackTrace);
      emit(VideoError("Failed to load video. Please try again."));
    }
  }

  void pauseVideo() {
    if (_videoController != null && _videoController!.value.isPlaying) {
      _videoController!.pause();
      emit(VideoPaused(_videoController!));
    }
  }

  void resumeVideo() {
    if (_videoController != null && !_videoController!.value.isPlaying) {
      _videoController!.play();
      emit(VideoPlaying(_videoController!));
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
    if (_videoController != null) {
      _logger.i("Disposing video controller");
      _videoController!.pause();
      _videoController!.dispose();
      _videoController = null;
    }
  }

  void skipForward() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      final newPosition =
          _videoController!.value.position + const Duration(seconds: 5);
      _videoController!.seekTo(newPosition);
    }
  }

  void skipBackward() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      final newPosition =
          _videoController!.value.position - const Duration(seconds: 5);
      _videoController!.seekTo(newPosition);
    }
  }

  @override
  Future<void> close() {
    _disposeVideoController();
    return super.close();
  }
}
