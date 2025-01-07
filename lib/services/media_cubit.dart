import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For persistent storage

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

  // Quota tracking
  static const int dailyQuotaLimit = 10000; // Set your daily quota limit here
  int quotaConsumed = 0;
  DateTime lastQuotaResetDate = DateTime.now();

  // Store nextPageTokens for channels
  final Map<String, String?> _channelNextPageTokens = {};

  // Store media items and shown video IDs
  List<Map<String, dynamic>> mediaItems = [];
  Set<String> shownVideoIds = {};

  MediaCubit({required this.mediaType}) : super(MediaInitial()) {
    _initializeQuota();
  }

  // Initialize quota from persistent storage
  Future<void> _initializeQuota() async {
    final prefs = await SharedPreferences.getInstance();
    quotaConsumed = prefs.getInt('quotaConsumed') ?? 0;
    int? lastResetTimestamp = prefs.getInt('lastQuotaResetDate');
    if (lastResetTimestamp != null) {
      lastQuotaResetDate =
          DateTime.fromMillisecondsSinceEpoch(lastResetTimestamp);
      // Reset quota if last reset was on a different day
      if (!_isSameDay(lastQuotaResetDate, DateTime.now())) {
        quotaConsumed = 0;
        lastQuotaResetDate = DateTime.now();
        await prefs.setInt('quotaConsumed', quotaConsumed);
        await prefs.setInt(
            'lastQuotaResetDate', lastQuotaResetDate.millisecondsSinceEpoch);
        logger.i('Quota has been reset for a new day.');
      }
    } else {
      // If no reset date, set it to today
      lastQuotaResetDate = DateTime.now();
      await prefs.setInt(
          'lastQuotaResetDate', lastQuotaResetDate.millisecondsSinceEpoch);
    }
    logger.i('Initialized quota. Quota consumed today: $quotaConsumed units.');
  }

  // Helper to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Save quota to persistent storage
  Future<void> _saveQuota() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quotaConsumed', quotaConsumed);
    await prefs.setInt(
        'lastQuotaResetDate', lastQuotaResetDate.millisecondsSinceEpoch);
    logger.i('Quota saved. Total quota consumed today: $quotaConsumed units.');
  }

  // Function to check if making a new API call would exceed the quota
  bool _canMakeApiCall(int quotaCost) {
    return (quotaConsumed + quotaCost) <= dailyQuotaLimit;
  }

  // Function to update quota and save it
  Future<void> _updateQuota(int quotaCost) async {
    quotaConsumed += quotaCost;
    await _saveQuota();
  }

  Future<void> fetchMedia({bool loadMore = false}) async {
    if (isLoading) return;

    // Check if enough quota is available for the next set of API calls
    // Each channel fetch consumes 100 units
    const expectedQuotaCost = 100 * 5; // 5 channels * 100 units each
    if (!_canMakeApiCall(expectedQuotaCost)) {
      emit(MediaError(
          errorMessage: 'Quota limit reached. Please try again tomorrow.'));
      logger.e('Quota limit reached. Cannot make further API calls today.');
      return;
    }

    isLoading = true;
    if (!loadMore) {
      if (isClosed) return;
      emit(MediaLoading());
    }

    try {
      List<Map<String, dynamic>> newMediaItems = [];

      int retryCount = 0;
      const int maxRetries = 10;
      bool itemsFound = false;

      while (retryCount < maxRetries && !itemsFound) {
        retryCount++;

        final channelIds = _getRandomChannelIds(5);

        for (var channelId in channelIds) {
          final uri = _buildUri(channelId, _channelNextPageTokens[channelId]);

          logger.d('Fetching media from URI: $uri');

          // Make sure making this API call won't exceed quota
          if (!_canMakeApiCall(100)) {
            // Each search.list call costs 100 units
            logger
                .e('Quota limit reached while processing channel $channelId.');
            continue; // Skip this channel
          }

          final response = await http.get(uri);

          // Update quota consumption for each search.list call
          await _updateQuota(100); // Each search.list call costs 100 units
          logger.i(
              'Quota consumed: 100 units. Total quota consumed today: $quotaConsumed units.');

          logger.d('API Response Status Code: ${response.statusCode}');
          logger.v('API Response Body: ${response.body}');

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);

            _channelNextPageTokens[channelId] = responseData['nextPageToken'];

            final parsedMediaItems = await _parseMediaData(responseData);

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
        newMediaItems.shuffle();
        shownVideoIds.addAll(newMediaItems.map((item) => item['videoId']));

        if (loadMore) {
          mediaItems.addAll(newMediaItems);
        } else {
          mediaItems = newMediaItems;
        }

        emit(MediaLoaded(newMediaItems: newMediaItems));

        hasMoreData =
            _channelNextPageTokens.values.any((token) => token != null);

        if (hasMoreData) {
          _preloadNextBatch();
        }
      } else {
        if (isClosed) return;
        emit(MediaError(errorMessage: 'No new media found.'));
      }
    } catch (e, stacktrace) {
      logger.e('An error occurred while fetching media', e, stacktrace);
      if (isClosed) return;
      emit(MediaError(errorMessage: 'An error occurred. Please try again.'));
    } finally {
      isLoading = false;
      logger.d('Media fetch operation completed.');
    }
  }

  void _preloadNextBatch() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (isClosed) return;
      if (!isLoading && hasMoreData) {
        logger.d('Preloading next batch of media items...');
        await fetchMedia(loadMore: true);
      }
    });
  }

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
      'videoDuration': 'short', // Fetch only short videos
      'maxResults': '2', // Limit to 2 videos per request
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

    final mediaItems = <Map<String, dynamic>>[];
    for (var item in items) {
      try {
        final videoId = item['id']?['videoId'] ?? '';
        final snippet = item['snippet'] ?? {};
        // final title = snippet['title'] ?? '';
        final thumbnail = snippet['thumbnails']?['high']?['url'] ??
            ''; // High quality thumbnail
        final channelTitle = snippet['channelTitle'] ?? '';

        final mediaItem = {
          'videoId': videoId,
          // 'title': title,
          'thumbnail': thumbnail,
          'channelTitle': channelTitle,
        };

        mediaItems.add(mediaItem);
      } catch (e, stacktrace) {
        logger.e('Error parsing media item', e, stacktrace);
      }
    }

    logger.d('Parsed ${mediaItems.length} media items successfully.');
    return mediaItems;
  }
}

// Extended Cubits for specific media types (if needed)
class VideoCubit extends MediaCubit {
  VideoCubit() : super(mediaType: MediaType.video);
}

class ShortsCubit extends MediaCubit {
  ShortsCubit() : super(mediaType: MediaType.short);
}
