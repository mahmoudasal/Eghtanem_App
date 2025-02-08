// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeResponse _$LikeResponseFromJson(Map<String, dynamic> json) => LikeResponse(
      id: (json['id'] as num?)?.toInt(),
      likesCount: (json['likes_count'] as num).toInt(),
    );

Map<String, dynamic> _$LikeResponseToJson(LikeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'likes_count': instance.likesCount,
    };
