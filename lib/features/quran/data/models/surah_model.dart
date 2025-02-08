import 'package:json_annotation/json_annotation.dart';

part 'surah_model.g.dart';

@JsonSerializable()
class Surah {
  final int number;
  final SurahName name;
  final List<Verse> verses;

  Surah({
    required this.number,
    required this.name,
    required this.verses,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);
  Map<String, dynamic> toJson() => _$SurahToJson(this);
}

@JsonSerializable()
class SurahName {
  final String ar;

  SurahName({required this.ar});

  factory SurahName.fromJson(Map<String, dynamic> json) =>
      _$SurahNameFromJson(json);
  Map<String, dynamic> toJson() => _$SurahNameToJson(this);
}

@JsonSerializable()
class Verse {
  final int number;
  final int page; // Add this field
  final VerseText text;

  Verse({required this.number, required this.page, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);
  Map<String, dynamic> toJson() => _$VerseToJson(this);
}

@JsonSerializable()
class VerseText {
  final String ar;

  VerseText({required this.ar});

  factory VerseText.fromJson(Map<String, dynamic> json) =>
      _$VerseTextFromJson(json);
  Map<String, dynamic> toJson() => _$VerseTextToJson(this);
}