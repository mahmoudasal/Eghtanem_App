import 'package:json_annotation/json_annotation.dart';
import '../../../home/data/models/comment_model.dart';

part 'video_model.g.dart';

@JsonSerializable()
class Video {
  final int? id;
  final String? title;
  final String? description;

  @JsonKey(name: 'video')
  final String? videoUrl;

  @JsonKey(name: 'thumbnail')
  final String? thumbnailUrl;

  @JsonKey(name: 'likes_count')
  int likesCount;

  final List<Comment> comments;

  Video({
    this.id,
    this.title,
    this.description,
    this.videoUrl,
    this.thumbnailUrl,
    this.likesCount = 0,
    this.comments = const [],
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
