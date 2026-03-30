import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eghtanem_app/features/quran/data/models/qra2at_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, Map<String, String>> desiredReciters = {
  "مشاري العفاسي": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server8.mp3quran.net/afs/",
  },
  "سعد الغامدي": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server7.mp3quran.net/s_gmd/",
  },
  "عبدالباسط عبدالصمد": {
    "moshaf": "المصحف المجود - المصحف المجود",
    "serverUrl": "https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/",
  },
  "عبدالرحمن السديس": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server11.mp3quran.net/sds/",
  },
  "عبدالعزيز الزهراني": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server9.mp3quran.net/zahrani/",
  },
  "عبدالله عواد الجهني": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server13.mp3quran.net/jhn/",
  },
  "عبدالله غيلان": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server8.mp3quran.net/gulan/",
  },
  "علي جابر": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server11.mp3quran.net/a_jbr/",
  },
  "ماهر المعيقلي": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server12.mp3quran.net/maher/",
  },
  "محمد ايوب": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server8.mp3quran.net/ayyub/",
  },
  "محمود علي البنا": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server8.mp3quran.net/bna/",
  },
  "منصور السالمي": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server14.mp3quran.net/mansor/",
  },
  "ناصر القطامي": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server6.mp3quran.net/qtm/",
  },
  "ياسر الدوسري": {
    "moshaf": "حفص عن عاصم - مرتل",
    "serverUrl": "https://server11.mp3quran.net/yasser/",
  },
  "محمد صديق المنشاوي": {
    "moshaf": "المصحف المجود - المصحف المجود",
    "serverUrl": "https://server10.mp3quran.net/minsh/Almusshaf-Al-Mojawwad/",
  },
};

final _dio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));

const _cacheKey = 'cached_reciters';

Future<List<Reciter>> fetchReciters() async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final response = await _dio.get('https://mp3quran.net/api/v3/reciters');

    final jsonResponse = response.data as Map<String, dynamic>;
    final recitersJson = jsonResponse['reciters'] as List<dynamic>;

    // Cache raw JSON for offline use (fire-and-forget)
    unawaited(prefs.setString(_cacheKey, json.encode(recitersJson)));

    return _filterReciters(recitersJson);
  } on DioException catch (e) {
    // If network fails, try returning cached data
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        final recitersJson = json.decode(cached) as List<dynamic>;
        return _filterReciters(recitersJson);
      }
    }
    rethrow;
  }
}

List<Reciter> _filterReciters(List<dynamic> recitersJson) {
  final List<Reciter> reciters =
      recitersJson.map((reciterJson) => Reciter.fromJson(reciterJson)).toList();

  final filteredReciters = reciters.where((reciter) {
    final desiredReciter = desiredReciters[reciter.name];

    if (desiredReciter != null) {
      final desiredMoshafList = reciter.moshaf
          .where((moshaf) => moshaf.name == desiredReciter['moshaf'])
          .toList();

      if (desiredMoshafList.isNotEmpty) {
        final desiredMoshaf = desiredMoshafList.first;
        reciter.moshaf.clear();
        reciter.moshaf.add(desiredMoshaf);
        return true;
      }
    }
    return false;
  }).toList();

  return filteredReciters;
}

Future<List<String>> fetchReciterSurahs(int reciterId) async {
  try {
    final response = await _dio.get(
      'https://mp3quran.net/api/v3/reciters',
      queryParameters: {
        'language': 'eng',
        'rewaya': '1',
        'reciter': reciterId,
      },
    );

    final data = response.data;

    if (data['reciters'] == null || data['reciters'].isEmpty) {
      throw StateError("No reciters found in the API response");
    }

    final reciterData = data['reciters'].firstWhere(
      (reciter) => reciter['id'] == reciterId,
      orElse: () {
        throw StateError("No reciter found with id $reciterId");
      },
    );

    if (reciterData['moshaf'] == null || reciterData['moshaf'].isEmpty) {
      throw StateError("No moshaf found for the reciter with id $reciterId");
    }

    final List<String> surahList =
        (reciterData['moshaf'][0]['surah_list'] as String)
            .split(',')
            .map((e) => 'Surah $e')
            .toList();

    return surahList;
  } catch (e) {
    if (kDebugMode) {
      debugPrint("Error fetching reciter surahs: $e");
    }
    rethrow;
  }
}
