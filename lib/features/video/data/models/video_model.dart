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

  Video copyWith({
    int? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    int? likesCount,
    List<Comment>? comments,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      likesCount: likesCount ?? this.likesCount,
      comments: comments ?? this.comments,
    );
  }
}

// If you want to keep the extension separate (optional)
extension VideoCopyWithExtension on Video {
  Video copyWithExtension({
    int? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    int? likesCount,
    List<Comment>? comments,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      likesCount: likesCount ?? this.likesCount,
      comments: comments ?? this.comments,
    );
  }
}