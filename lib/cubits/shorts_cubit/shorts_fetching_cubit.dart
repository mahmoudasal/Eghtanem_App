import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:logger/logger.dart';

abstract class ShortsState {}

class ShortsInitial extends ShortsState {}

class ShortsLoading extends ShortsState {}

class ShortsLoaded extends ShortsState {
  final List<Map<String, dynamic>> shorts;

  ShortsLoaded(this.shorts);
}

class ShortsError extends ShortsState {
  final String errorMessage;

  ShortsError(this.errorMessage);
}

class ShortsCubit extends Cubit<ShortsState> {
  ShortsCubit() : super(ShortsInitial());

  final _secureStorage = const FlutterSecureStorage();
  List<Map<String, dynamic>> _shorts = [];
  bool _isLoading = false;
  int _page = 1;
  var logger = Logger();

  List<Map<String, dynamic>> get shorts => _shorts; // Add this getter

  Future<void> fetchShorts({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (!loadMore) emit(ShortsLoading());

    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception('User not signed in');
      }

      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCp479sePW_R7NM8AhPyUDoQ&maxResults=10&type=video'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newShorts = await _parseShortsData(data, accessToken);
        _shorts.addAll(newShorts);

        _page++; // Increment the page for the next load

        if (!isClosed) {
          emit(ShortsLoaded(_shorts));
        }
      } else {
        logger.e('Failed to fetch shorts. Status Code: ${response.statusCode}');
        logger.e('Response body: ${response.body}');
        throw Exception(
            'Failed to fetch shorts. Status code: ${response.statusCode}');
      }
    } on SocketException {
      if (!isClosed) {
        emit(ShortsError('No internet connection. Please try again.'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ShortsError('Failed to fetch shorts: $e'));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<String?> _getAccessToken() async {
    final googleUser = await GoogleSignIn().signInSilently();
    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;
    await _secureStorage.write(
        key: 'accessToken', value: googleAuth.accessToken);
    return googleAuth.accessToken;
  }

  Future<List<Map<String, dynamic>>> _fetchShortsData(
      String accessToken, int page) async {
    final response = await _retryHttpRequest(() => http.get(
          Uri.parse(
              'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCWjCSGhmSGu0VLf2mPFS0Kg&maxResults=10&pageToken=$page&type=video'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return await _parseShortsData(data, accessToken);
    } else {
      throw Exception(
          'Failed to fetch shorts. Status code: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> _parseShortsData(
      Map<String, dynamic> data, String accessToken) async {
    return await Future.wait(
      (data['items'] as List).map((item) async {
        final videoId = item['id']['videoId'];
        final channelId = item['snippet']['channelId'];

        final statistics = await _fetchVideoStatistics(accessToken, videoId);
        final channelPic = await _fetchChannelPicture(accessToken, channelId);

        return {
          'videoId': videoId,
          'title': item['snippet']['title'],
          'thumbnail': item['snippet']['thumbnails']['default']['url'],
          'description': item['snippet']['description'],
          'publishedAt': item['snippet']['publishedAt'],
          'channelTitle': item['snippet']['channelTitle'],
          'channelPic': channelPic,
          'likes': statistics['likeCount'] ?? '0',
          'comments': statistics['commentCount'] ?? '0',
        };
      }).toList(),
    );
  }

  Future<Map<String, dynamic>> _fetchVideoStatistics(
      String accessToken, String videoId) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=statistics&id=$videoId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final videoDetails = json.decode(response.body);
    return videoDetails['items'][0]['statistics'];
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

    final channelDetails = json.decode(response.body);
    return channelDetails['items'][0]['snippet']['thumbnails']['default']
        ['url'];
  }

  Future<void> likeVideo(String videoId, String accessToken) async {
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

  Future<http.Response> _retryHttpRequest(
      Future<http.Response> Function() request) async {
    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final response = await request();
        return response;
      } catch (e) {
        retryCount++;
        if (retryCount == maxRetries) {
          rethrow;
        }
        await Future.delayed(Duration(seconds: 2 ^ retryCount));
      }
    }
    throw Exception('Failed after $maxRetries retries');
  }
}
