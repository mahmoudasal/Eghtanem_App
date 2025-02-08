// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      videoUrl: json['video'] as String?,
      thumbnailUrl: json['thumbnail'] as String?,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'video': instance.videoUrl,
      'thumbnail': instance.thumbnailUrl,
      'likes_count': instance.likesCount,
      'comments': instance.comments,
    };
