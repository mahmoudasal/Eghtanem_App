import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

enum MediaType { video, short }

abstract class MediaState {}

class MediaInitial extends MediaState {}

class MediaLoading extends MediaState {
  final List<Map<String, dynamic>> mediaItems;
  MediaLoading(this.mediaItems);
}

class MediaLoadingMore extends MediaState {}

class MediaLoaded extends MediaState {
  final List<Map<String, dynamic>> mediaItems;
  final String? nextPageToken;

  MediaLoaded(this.mediaItems, this.nextPageToken);
}

class MediaError extends MediaState {
  final String errorMessage;

  MediaError(this.errorMessage);
}

class MediaCubit extends Cubit<MediaState> {
  MediaCubit({required this.mediaType}) : super(MediaInitial());

  final MediaType mediaType;

  final _secureStorage = const FlutterSecureStorage();
  String? _nextPageToken;
  bool _hasMoreData = true;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _mediaItems = [];
  var logger = Logger();

  List<Map<String, dynamic>> get mediaItems => _mediaItems;
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _isLoading;

  Future<void> fetchMedia({bool loadMore = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    // Emit appropriate loading state
    if (!loadMore && _mediaItems.isEmpty) {
      emit(MediaLoading(_mediaItems));
    } else {
      emit(MediaLoadingMore());
    }

    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception('User not signed in');
      }

      logger.d("Access token retrieved successfully.");
      final uri = _buildUri();
      logger.d('Fetching media from URI: $uri');

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      logger.i('API Response Status Code: ${response.statusCode}');
      logger.v('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        logger.d('Parsed API Response: $data');

        final newItems = await _parseMediaData(data, accessToken);

        // Remove duplicates
        final existingVideoIds =
            _mediaItems.map((item) => item['videoId']).toSet();
        final uniqueNewItems = newItems
            .where((item) => !existingVideoIds.contains(item['videoId']))
            .toList();

        _mediaItems.addAll(uniqueNewItems);

        if (data['nextPageToken'] != null) {
          _nextPageToken = data['nextPageToken'];
          logger.d('Updated nextPageToken: $_nextPageToken');
        } else {
          _hasMoreData = false;
          logger.d('No more data to load. Setting _hasMoreData to false.');
        }

        if (!isClosed) {
          emit(MediaLoaded(_mediaItems, _nextPageToken));
        }
      } else {
        logger.e('Failed to fetch media. Status Code: ${response.statusCode}');
        throw HttpException(
            'Failed to fetch media. Status code: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      logger.e('An error occurred while fetching media', e, stacktrace);
      if (!isClosed) {
        emit(MediaError('Failed to fetch media: ${e.toString()}'));
      }
    } finally {
      _isLoading = false;
      logger.d("Media fetch operation completed.");
    }
  }

  Uri _buildUri() {
    final channelId = mediaType == MediaType.video
        ? 'UCWjCSGhmSGu0VLf2mPFS0Kg' // Replace with your channel ID
        : 'UCp479sePW_R7NM8AhPyUDoQ'; // Channel ID for shorts

    final params = {
      'part': 'snippet',
      'channelId': channelId,
      'type': 'video',
      // Remove 'order' parameter to get more randomness
      'maxResults': '10',
      // Use 'videoDuration' to help filter shorts and long videos
      if (mediaType == MediaType.video) 'videoDuration': 'any',
      if (mediaType == MediaType.short) 'videoDuration': 'short',
      if (_nextPageToken != null) 'pageToken': _nextPageToken,
    };

    final uri = Uri.https('www.googleapis.com', '/youtube/v3/search', params);
    return uri;
  }

  Future<Map<String, Map<String, dynamic>>> _fetchVideosDetails(
      String accessToken, List<String> videoIds) async {
    final Map<String, Map<String, dynamic>> videoDetailsMap = {};

    for (int i = 0; i < videoIds.length; i += 50) {
      final chunk = videoIds.sublist(
          i, i + 50 > videoIds.length ? videoIds.length : i + 50);

      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/youtube/v3/videos?part=statistics,contentDetails&id=${chunk.join(",")}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final items = json.decode(response.body)['items'];
        for (var item in items) {
          final videoId = item['id'];
          final statistics = item['statistics'];
          final contentDetails = item['contentDetails'];

          final duration = contentDetails['duration'];
          final durationSeconds = _parseDuration(duration);

          videoDetailsMap[videoId] = {
            'likeCount': statistics['likeCount'],
            'commentCount': statistics['commentCount'],
            'views': statistics['viewCount'] ?? '0',
            'duration': _formatDuration(duration),
            'durationSeconds': durationSeconds,
          };
        }
      } else {
        throw Exception('Failed to fetch video details');
      }
    }

    return videoDetailsMap;
  }

  Future<Map<String, String>> _fetchChannelsPictures(
      String accessToken, List<String> channelIds) async {
    final Map<String, String> channelPicturesMap = {};

    for (int i = 0; i < channelIds.length; i += 50) {
      final chunk = channelIds.sublist(
          i, i + 50 > channelIds.length ? channelIds.length : i + 50);

      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/youtube/v3/channels?part=snippet&id=${chunk.join(",")}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final items = json.decode(response.body)['items'];
        for (var item in items) {
          final channelId = item['id'];
          final thumbnails = item['snippet']['thumbnails'];
          final channelPicUrl = thumbnails['default']['url'];
          channelPicturesMap[channelId] = channelPicUrl;
        }
      } else {
        throw Exception('Failed to fetch channel pictures');
      }
    }

    return channelPicturesMap;
  }

  Future<String?> _getAccessToken() async {
    try {
      final googleUser = await GoogleSignIn().signInSilently();
      if (googleUser == null) {
        logger.w('Google sign-in failed, user not signed in.');
        return null;
      }

      final googleAuth = await googleUser.authentication;
      await _secureStorage.write(
          key: 'accessToken', value: googleAuth.accessToken);
      logger.d('Access token saved securely.');
      return googleAuth.accessToken;
    } catch (e) {
      logger.e('Failed to get access token', e);
      throw Exception('Failed to retrieve access token.');
    }
  }

  Future<List<Map<String, dynamic>>> _parseMediaData(
      Map<String, dynamic> data, String accessToken) async {
    final items = data['items'] as List;

    // Collect video IDs and channel IDs
    final videoIds = items
        .where((item) => item['id']['kind'] == 'youtube#video')
        .map<String>((item) => item['id']['videoId'] as String)
        .toList();

    final channelIds = items
        .map<String>((item) => item['snippet']['channelId'] as String)
        .toSet()
        .toList(); // Use Set to avoid duplicates

    // Fetch all video details and channel pictures
    final videoDetailsMap = await _fetchVideosDetails(accessToken, videoIds);
    final channelPicturesMap =
        await _fetchChannelsPictures(accessToken, channelIds);

    final List<Map<String, dynamic>> resultItems = [];

    for (var item in items) {
      if (item['id']['kind'] != 'youtube#video') continue;

      final videoId = item['id']['videoId'];
      final channelId = item['snippet']['channelId'];

      final details = videoDetailsMap[videoId];
      final channelPic = channelPicturesMap[channelId];

      if (details == null || channelPic == null) continue;

      final durationSeconds = details['durationSeconds'];

      // Filter videos based on duration
      if ((mediaType == MediaType.video && durationSeconds > 60) ||
          (mediaType == MediaType.short && durationSeconds <= 60)) {
        resultItems.add({
          'videoId': videoId,
          'title': item['snippet']['title'],
          'thumbnail': item['snippet']['thumbnails']['high']['url'],
          'description': item['snippet']['description'],
          'publishedAt': item['snippet']['publishedAt'],
          'channelTitle': item['snippet']['channelTitle'],
          'channelPic': channelPic,
          'likes': details['likeCount'] ?? '0',
          'comments': details['commentCount'] ?? '0',
          'views': details['views'] ?? '0',
          'duration': details['duration'] ?? 'N/A',
        });
      }
    }

    // Shuffle to randomize videos
    resultItems.shuffle();

    return resultItems;
  }

  Future<Map<String, dynamic>> _fetchVideoDetails(
      String accessToken, String videoId) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=statistics,contentDetails&id=$videoId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final items = json.decode(response.body)['items'];
      if (items == null || items.isEmpty) {
        throw Exception('Video details not found');
      }
      final videoDetails = items[0];
      final statistics = videoDetails['statistics'];
      final contentDetails = videoDetails['contentDetails'];

      final duration = contentDetails['duration'];
      final durationSeconds = _parseDuration(duration);

      return {
        'likeCount': statistics['likeCount'],
        'commentCount': statistics['commentCount'],
        'views': statistics['viewCount'] ?? '0',
        'duration': _formatDuration(duration),
        'durationSeconds': durationSeconds,
      };
    } else {
      throw Exception('Failed to fetch video details');
    }
  }

  int _parseDuration(String duration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);

    if (match != null) {
      final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

      return hours * 3600 + minutes * 60 + seconds;
    }
    return 0;
  }

  String _formatDuration(String duration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);

    if (match != null) {
      final hours =
          match.group(1) != null ? match.group(1)!.replaceAll('H', '') : '0';
      final minutes =
          match.group(2) != null ? match.group(2)!.replaceAll('M', '') : '0';
      final seconds =
          match.group(3) != null ? match.group(3)!.replaceAll('S', '') : '0';

      final hoursInt = int.tryParse(hours) ?? 0;
      final minutesInt = int.tryParse(minutes) ?? 0;
      final secondsInt = int.tryParse(seconds) ?? 0;

      String formattedDuration = '';
      if (hoursInt > 0) {
        formattedDuration += '$hoursInt:';
      }
      formattedDuration += '${minutesInt.toString().padLeft(2, '0')}:';
      formattedDuration += secondsInt.toString().padLeft(2, '0');

      return formattedDuration;
    }
    return '0:00';
  }

  Future<String> _fetchChannelPicture(
      String accessToken, String channelId) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/youtube/v3/channels?part=snippet&id=$channelId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['items'][0]['snippet']['thumbnails']
          ['default']['url'];
    } else {
      throw const HttpException('Failed to fetch channel picture');
    }
  }

  Future<void> likeMedia(String videoId, String accessToken) async {
    try {
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

      if (response.statusCode != 204) {
        throw Exception('Failed to like video');
      }
    } catch (e) {
      throw Exception('Error liking video: $e');
    }
  }
}
