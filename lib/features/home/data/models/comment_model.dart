import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class Comment {
  final int? id;
  final String? content;

  // The JSON key "user_name" is mapped to "userName"
  @JsonKey(name: 'user_name')
  final String? userName;

  Comment({
    this.id,
    this.content,
    this.userName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
