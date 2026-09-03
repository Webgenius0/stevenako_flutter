import 'dart:convert';

class UserPostLikeModel {
  final bool? success;
  final String? message;
  final UserPostLikeData? data;
  final int? code;

  UserPostLikeModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  UserPostLikeModel copyWith({
    bool? success,
    String? message,
    UserPostLikeData? data,
    int? code,
  }) =>
      UserPostLikeModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory UserPostLikeModel.fromRawJson(String str) =>
      UserPostLikeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPostLikeModel.fromJson(Map<String, dynamic> json) =>
      UserPostLikeModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : UserPostLikeData.fromJson(json["data"]),
        code: json["code"] as int?,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class UserPostLikeData {
  final bool? isLiked;
  final int? likesCount;

  UserPostLikeData({
    this.isLiked,
    this.likesCount,
  });

  UserPostLikeData copyWith({
    bool? isLiked,
    int? likesCount,
  }) =>
      UserPostLikeData(
        isLiked: isLiked ?? this.isLiked,
        likesCount: likesCount ?? this.likesCount,
      );

  factory UserPostLikeData.fromRawJson(String str) =>
      UserPostLikeData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPostLikeData.fromJson(Map<String, dynamic> json) =>
      UserPostLikeData(
        isLiked: json["is_liked"] as bool?,
        likesCount: json["likes_count"] is String
            ? int.tryParse(json["likes_count"])
            : json["likes_count"] as int?,
      );

  Map<String, dynamic> toJson() => {
    "is_liked": isLiked,
    "likes_count": likesCount,
  };
}