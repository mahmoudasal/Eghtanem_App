import 'package:json_annotation/json_annotation.dart';

part 'like_response.g.dart';

@JsonSerializable()
class LikeResponse {
  final int? id;

  // The JSON key "likes_count" is mapped to "likesCount"
  @JsonKey(name: 'likes_count')
  final int likesCount;

  LikeResponse({
    this.id,
    required this.likesCount,
  });

  factory LikeResponse.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LikeResponseToJson(this);
}
