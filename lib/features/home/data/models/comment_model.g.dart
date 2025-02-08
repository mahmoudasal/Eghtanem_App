// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      userName: json['user_name'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'user_name': instance.userName,
    };
