import 'package:youtube_player_flutter/youtube_player_flutter.dart';

abstract class VideoPlayerState {}

class VideoPlayerInitial extends VideoPlayerState {}

class VideoPlayerLoading extends VideoPlayerState {}

class VideoPlayerLoaded extends VideoPlayerState {
  final YoutubePlayerController videoController;
  final bool isPlaying;

  VideoPlayerLoaded({
    required this.videoController,
    required this.isPlaying,
  });
}

class VideoPlayerError extends VideoPlayerState {
  final String errorMessage;

  VideoPlayerError({required this.errorMessage});
}
