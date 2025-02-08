// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Surah _$SurahFromJson(Map<String, dynamic> json) => Surah(
      number: (json['number'] as num).toInt(),
      name: SurahName.fromJson(json['name'] as Map<String, dynamic>),
      verses: (json['verses'] as List<dynamic>)
          .map((e) => Verse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurahToJson(Surah instance) => <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'verses': instance.verses,
    };

SurahName _$SurahNameFromJson(Map<String, dynamic> json) => SurahName(
      ar: json['ar'] as String,
    );

Map<String, dynamic> _$SurahNameToJson(SurahName instance) => <String, dynamic>{
      'ar': instance.ar,
    };

Verse _$VerseFromJson(Map<String, dynamic> json) => Verse(
      number: (json['number'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      text: VerseText.fromJson(json['text'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerseToJson(Verse instance) => <String, dynamic>{
      'number': instance.number,
      'page': instance.page,
      'text': instance.text,
    };

VerseText _$VerseTextFromJson(Map<String, dynamic> json) => VerseText(
      ar: json['ar'] as String,
    );

Map<String, dynamic> _$VerseTextToJson(VerseText instance) => <String, dynamic>{
      'ar': instance.ar,
    };
