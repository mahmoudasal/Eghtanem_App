import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeApiService {
  final String apiKey;

  YouTubeApiService({required this.apiKey});

  Future<List<Map<String, dynamic>>> fetchShortsFromChannel(String channelId,
      {required String parts, required int maxResults}) async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&type=video&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> shorts = [];

      for (var item in data['items']) {
        final short = {
          'videoId': item['id']['videoId'],
          'title': item['snippet']['title'],
          'description': item['snippet']['description'],
          'thumbnail': item['snippet']['thumbnails']['default']['url'],
          'channelTitle': item['snippet']['channelTitle']
        };
        shorts.add(short);
      }
      return shorts;
    } else {
      throw Exception('Failed to load shorts: ${response.statusCode}');
    }
  }
}
