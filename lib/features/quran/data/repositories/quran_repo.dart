import 'dart:convert';
import 'package:egtanem_application/features/quran/data/models/qra2at_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

Future<List<Reciter>> fetchReciters() async {
  final response =
      await http.get(Uri.parse('https://mp3quran.net/api/v3/reciters'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final recitersJson = jsonResponse['reciters'] as List<dynamic>;

    final List<Reciter> reciters = recitersJson
        .map((reciterJson) => Reciter.fromJson(reciterJson))
        .toList();

    // Filter reciters based on the desiredReciters map
    final filteredReciters = reciters.where((reciter) {
      // Check if this reciter is in the desiredReciters map
      final desiredReciter = desiredReciters[reciter.name];

      if (desiredReciter != null) {
        // Find the desired moshaf within the reciter's moshaf list
        final desiredMoshafList = reciter.moshaf
            .where((moshaf) => moshaf.name == desiredReciter['moshaf'])
            .toList();

        if (desiredMoshafList.isNotEmpty) {
          final desiredMoshaf = desiredMoshafList.first;
          // Replace the reciter's moshaf list with only the desired moshaf
          reciter.moshaf.clear();
          reciter.moshaf.add(desiredMoshaf);
          return true;
        }
      }
      return false;
    }).toList();

    return filteredReciters;
  } else {
    throw Exception('Failed to load reciters');
  }
}

Future<List<String>> fetchReciterSurahs(int reciterId) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://mp3quran.net/api/v3/reciters?language=eng&rewaya=1&reciter=$reciterId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

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
    } else {
      throw Exception('Failed to load surahs: ${response.reasonPhrase}');
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching reciter surahs: $e");
    }
    rethrow;
  }
}
