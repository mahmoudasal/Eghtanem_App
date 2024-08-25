import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger _logger = Logger();

abstract class InteractionState {}

class InteractionInitial extends InteractionState {}

class LikeToggledState extends InteractionState {
  final bool isLiked;

  LikeToggledState({required this.isLiked});
}

class InteractionCubit extends Cubit<InteractionState> {
  final Map<String, dynamic> youtubeData;
  final String videoId;
  bool isLiked = false;

  InteractionCubit({required this.youtubeData, required this.videoId})
      : super(InteractionInitial());

  void toggleLike() async {
    isLiked = !isLiked;

    try {
      if (isLiked) {
        // Perform the API call to like the video
        final accessToken = youtubeData['accessToken'];
        final response = await http.post(
          Uri.parse('https://www.googleapis.com/youtube/v3/videos/rate'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'id': videoId,
            'rating': 'like',
          }),
        );

        if (response.statusCode == 204) {
          emit(LikeToggledState(isLiked: isLiked));
        } else {
          // Handle failure to like the video
          isLiked = !isLiked; // Revert the like status
          emit(LikeToggledState(isLiked: isLiked));
          throw Exception('Failed to like video');
        }
      } else {
        // Handle unlike or no action, if needed
        emit(LikeToggledState(isLiked: isLiked));
      }
    } catch (e) {
      // Handle errors
      isLiked = !isLiked; // Revert the like status on error
      emit(LikeToggledState(isLiked: isLiked));
      _logger.i('Error toggling like: $e');
    }
  }
}
