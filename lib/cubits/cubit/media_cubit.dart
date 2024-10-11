import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum MediaType { video, short }

abstract class MediaState {}

class MediaInitial extends MediaState {}

class MediaLoading extends MediaState {}

class MediaLoaded extends MediaState {
  final List<Map<String, dynamic>> newMediaItems;

  MediaLoaded({required this.newMediaItems});
}

class MediaError extends MediaState {
  final String errorMessage;

  MediaError({required this.errorMessage});
}

class MediaCubit extends Cubit<MediaState> {
  final MediaType mediaType;
  final Logger logger = Logger();

  bool isLoading = false;
  bool hasMoreData = true;

  // Store nextPageTokens for channels
  Map<String, String?> _channelNextPageTokens = {};

  // Store media items and shown video IDs
  List<Map<String, dynamic>> mediaItems = [];
  Set<String> shownVideoIds = {};

  MediaCubit({required this.mediaType}) : super(MediaInitial());

  Future<void> fetchMedia({bool loadMore = false}) async {
    if (isLoading) return;

    isLoading = true;
    emit(MediaLoading());

    try {
      List<Map<String, dynamic>> newMediaItems = [];

      // Attempt to fetch media up to 10 times if no items are found
      int retryCount = 0;
      const int maxRetries = 10;
      bool itemsFound = false;

      while (retryCount < maxRetries && !itemsFound) {
        retryCount++;

        // Select random channels
        final channelIds = _getRandomChannelIds(5);

        for (var channelId in channelIds) {
          final uri = _buildUri(channelId, _channelNextPageTokens[channelId]);

          logger.d('Fetching media from URI: $uri');

          final response = await http.get(uri);

          logger.d('API Response Status Code: ${response.statusCode}');
          logger.v('API Response Body: ${response.body}');

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);

            // Update nextPageToken
            _channelNextPageTokens[channelId] = responseData['nextPageToken'];

            final parsedMediaItems = await _parseMediaData(responseData);

            // Filter out already shown videos
            parsedMediaItems.removeWhere(
              (item) => shownVideoIds.contains(item['videoId']),
            );

            if (parsedMediaItems.isNotEmpty) {
              itemsFound = true;
              newMediaItems.addAll(parsedMediaItems);
            } else {
              logger.w(
                  'No new items found for channel $channelId on attempt $retryCount.');
            }
          } else {
            final errorData = json.decode(response.body);
            final errorMessage =
                errorData['error']['message'] ?? 'Unknown error';
            logger.e('Failed to fetch media: $errorMessage');
          }
        }

        if (!itemsFound && retryCount < maxRetries) {
          logger.w(
              'No items found on attempt $retryCount. Retrying after delay...');
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (itemsFound) {
        // Shuffle and update media items
        newMediaItems.shuffle();
        shownVideoIds.addAll(newMediaItems.map((item) => item['videoId']));

        if (loadMore) {
          mediaItems.addAll(newMediaItems);
        } else {
          mediaItems = newMediaItems;
        }

        emit(MediaLoaded(newMediaItems: newMediaItems));

        // Check if more data is available
        hasMoreData =
            _channelNextPageTokens.values.any((token) => token != null);
      } else {
        // No items found after retries
        emit(MediaError(errorMessage: 'Check your internet connection'));
      }
    } catch (e, stacktrace) {
      logger.e('An error occurred while fetching media', e, stacktrace);
      emit(MediaError(errorMessage: 'An error occurred. Please try again.'));
    } finally {
      isLoading = false;
      logger.d('Media fetch operation completed.');
    }
  }

  // Helper method to get multiple random channel IDs
  List<String> _getRandomChannelIds(int count) {
    final channelIds = dotenv.env['CHANNEL_IDS']?.split(',');

    if (channelIds == null || channelIds.isEmpty) {
      throw Exception(
          'Channel IDs not found. Please set your channel IDs in the .env file.');
    }

    final random = Random();
    final randomChannelIds = <String>{};

    while (randomChannelIds.length < count &&
        randomChannelIds.length < channelIds.length) {
      final randomChannelId = channelIds[random.nextInt(channelIds.length)];
      randomChannelIds.add(randomChannelId);
    }

    logger.d('Selected random channel IDs: $randomChannelIds');
    return randomChannelIds.toList();
  }

  Uri _buildUri(String channelId, String? pageToken) {
    final apiKey = dotenv.env['API_KEY'];

    if (apiKey == null) {
      throw Exception(
          'API Key not found. Please set your API Key in the .env file.');
    }

    final params = {
      'part': 'snippet',
      'channelId': channelId,
      'type': 'video',
      'maxResults': '8',
      'key': apiKey,
    };

    if (pageToken != null) {
      params['pageToken'] = pageToken;
    }

    final uri = Uri.https('www.googleapis.com', '/youtube/v3/search', params);
    logger.d('Using channel ID: $channelId');
    return uri;
  }

  Future<List<Map<String, dynamic>>> _parseMediaData(
      Map<String, dynamic> data) async {
    final List<dynamic>? items = data['items'];
    if (items == null || items.isEmpty) {
      logger.w('No items found in the API response.');
      return [];
    }

    // Extract video IDs and channel IDs
    final videoIds = <String>[];
    final channelIds = <String>[];

    for (var item in items) {
      final videoId = item['id']?['videoId'];
      if (videoId != null) {
        videoIds.add(videoId);
      } else {
        logger.w('Video ID not found for an item.');
        continue; // Skip if no videoId
      }

      final channelId = item['snippet']?['channelId'];
      if (channelId != null) {
        channelIds.add(channelId);
      } else {
        logger.w('Channel ID not found for an item.');
      }
    }

    // Fetch additional details
    final videoDetailsMap = await _fetchVideosDetails(videoIds);
    final channelPicturesMap = await _fetchChannelsPictures(channelIds);

    // Build media items
    final mediaItems = <Map<String, dynamic>>[];
    for (var item in items) {
      try {
        final videoId = item['id']?['videoId'] ?? '';
        final snippet = item['snippet'] ?? {};
        final title = snippet['title'] ?? '';
        final thumbnail =
            snippet['thumbnails']?['high']?['url'] ?? ''; // High quality
        final channelTitle = snippet['channelTitle'] ?? '';
        final channelId = snippet['channelId'] ?? '';

        final videoDetails = videoDetailsMap[videoId];
        final channelPic = channelPicturesMap[channelId];

        final mediaItem = {
          'videoId': videoId,
          'title': title,
          'thumbnail': thumbnail,
          'channelTitle': channelTitle,
          'channelPic': channelPic ?? '',
          'views': int.parse(videoDetails?['views'] ?? '0'),
          'likes': int.parse(videoDetails?['likes'] ?? '0'),
          'comments': int.parse(videoDetails?['comments'] ?? '0'),
          'duration': videoDetails?['duration'] ?? '0',
        };

        mediaItems.add(mediaItem);
      } catch (e, stacktrace) {
        logger.e('Error parsing media item', e, stacktrace);
      }
    }

    logger.d('Parsed ${mediaItems.length} media items successfully.');
    return mediaItems;
  }

  Future<Map<String, Map<String, dynamic>>> _fetchVideosDetails(
      List<String> videoIds) async {
    final videoDetailsMap = <String, Map<String, dynamic>>{};
    final apiKey = dotenv.env['API_KEY'];

    // Fetch video details in chunks of 50
    for (int i = 0; i < videoIds.length; i += 50) {
      final chunk = videoIds.sublist(
        i,
        i + 50 > videoIds.length ? videoIds.length : i + 50,
      );

      final params = {
        'part': 'statistics,contentDetails',
        'id': chunk.join(','),
        'key': apiKey!,
      };

      final uri = Uri.https('www.googleapis.com', '/youtube/v3/videos', params);

      final response = await http.get(uri);

      logger.d('Video details response status code: ${response.statusCode}');
      logger.v('Video details response body: ${response.body}');

      if (response.statusCode == 200) {
        final items = json.decode(response.body)['items'];
        for (var item in items) {
          final videoId = item['id'];
          final statistics = item['statistics'];
          final contentDetails = item['contentDetails'];

          final duration = contentDetails['duration'];
          final durationFormatted = _formatDuration(duration);

          videoDetailsMap[videoId] = {
            'views': statistics['viewCount'] ?? '0',
            'likes': statistics['likeCount'] ?? '0',
            'comments': statistics['commentCount'] ?? '0',
            'duration': durationFormatted,
          };
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Unknown error';
        throw Exception('Failed to fetch video details: $errorMessage');
      }
    }

    return videoDetailsMap;
  }

  Future<Map<String, String>> _fetchChannelsPictures(
      List<String> channelIds) async {
    final channelPicturesMap = <String, String>{};
    final apiKey = dotenv.env['API_KEY'];

    // Fetch channel pictures in chunks of 50
    for (int i = 0; i < channelIds.length; i += 50) {
      final chunk = channelIds.sublist(
        i,
        i + 50 > channelIds.length ? channelIds.length : i + 50,
      );

      final params = {
        'part': 'snippet',
        'id': chunk.join(','),
        'key': apiKey!,
      };

      final uri =
          Uri.https('www.googleapis.com', '/youtube/v3/channels', params);

      final response = await http.get(uri);

      logger.d('Channel pictures response status code: ${response.statusCode}');
      logger.v('Channel pictures response body: ${response.body}');

      if (response.statusCode == 200) {
        final items = json.decode(response.body)['items'];
        for (var item in items) {
          final channelId = item['id'];
          final thumbnails = item['snippet']['thumbnails'];
          final channelPicUrl = thumbnails['default']['url'];
          channelPicturesMap[channelId] = channelPicUrl;
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Unknown error';
        throw Exception('Failed to fetch channel pictures: $errorMessage');
      }
    }

    return channelPicturesMap;
  }

  String _formatDuration(String duration) {
    // Parse ISO 8601 duration
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);

    if (match != null) {
      final hours = int.parse(match.group(1) ?? '0');
      final minutes = int.parse(match.group(2) ?? '0');
      final seconds = int.parse(match.group(3) ?? '0');

      if (hours > 0) {
        return '${hours.toString().padLeft(2, '0')}:'
            '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}';
      } else {
        return '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}';
      }
    } else {
      return '00:00';
    }
  }
}

class VideoCubit extends MediaCubit {
  VideoCubit() : super(mediaType: MediaType.video);
}

class ShortsCubit extends MediaCubit {
  ShortsCubit() : super(mediaType: MediaType.short);
}
