import 'dart:convert';

class GetUserInfoModel {
  final bool? success;
  final String? message;
  final UserInfoData? data;
  final int? code;

  GetUserInfoModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetUserInfoModel copyWith({
    bool? success,
    String? message,
    UserInfoData? data,
    int? code,
  }) =>
      GetUserInfoModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory GetUserInfoModel.fromRawJson(String str) =>
      GetUserInfoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserInfoModel.fromJson(Map<String, dynamic> json) =>
      GetUserInfoModel(
        success: _toBoolSafe(json["success"]),
        message: json["message"]?.toString(),
        data: json["data"] == null ? null : UserInfoData.fromJson(json["data"]),
        code: _toIntSafe(json["code"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class UserInfoData {
  final DataUser? user;
  final UserPosts? posts;

  UserInfoData({
    this.user,
    this.posts,
  });

  UserInfoData copyWith({
    DataUser? user,
    UserPosts? posts,
  }) =>
      UserInfoData(
        user: user ?? this.user,
        posts: posts ?? this.posts,
      );

  factory UserInfoData.fromRawJson(String str) =>
      UserInfoData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfoData.fromJson(Map<String, dynamic> json) => UserInfoData(
    user: json["user"] == null ? null : DataUser.fromJson(json["user"]),
    posts: json["posts"] == null ? null : UserPosts.fromJson(json["posts"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "posts": posts?.toJson(),
  };
}

class UserPosts {
  final List<PostItem>? photo;
  final List<PostItem>? video;
  final List<PostItem>? text;

  UserPosts({
    this.photo,
    this.video,
    this.text,
  });

  UserPosts copyWith({
    List<PostItem>? photo,
    List<PostItem>? video,
    List<PostItem>? text,
  }) =>
      UserPosts(
        photo: photo ?? this.photo,
        video: video ?? this.video,
        text: text ?? this.text,
      );

  factory UserPosts.fromRawJson(String str) =>
      UserPosts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPosts.fromJson(Map<String, dynamic> json) => UserPosts(
    photo: json["photo"] == null
        ? []
        : List<PostItem>.from(
        json["photo"]!.map((x) => PostItem.fromJson(x))),
    video: json["video"] == null
        ? []
        : List<PostItem>.from(
        json["video"]!.map((x) => PostItem.fromJson(x))),
    text: json["text"] == null
        ? []
        : List<PostItem>.from(
        json["text"]!.map((x) => PostItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "photo": photo == null ? [] : List<dynamic>.from(photo!.map((x) => x.toJson())),
    "video": video == null ? [] : List<dynamic>.from(video!.map((x) => x.toJson())),
    "text": text == null ? [] : List<dynamic>.from(text!.map((x) => x.toJson())),
  };
}

class PostItem {
  final int? id;
  final String? itemType;
  final String? type;
  final String? caption;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;
  final String? privacySetting;
  final bool? allowComments;
  final bool? allowGifts;
  final bool? isDraft;
  final String? status;
  final int? viewsCount;
  final int? likesCount;
  final int? commentsCount;
  final int? sharesCount;
  final bool? isLiked;
  final bool? isViewed;
  final UserSummary? user;
  final List<Media>? media;
  final List<UserSummary>? taggedUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PostItem({
    this.id,
    this.itemType,
    this.type,
    this.caption,
    this.locationName,
    this.locationLat,
    this.locationLng,
    this.privacySetting,
    this.allowComments,
    this.allowGifts,
    this.isDraft,
    this.status,
    this.viewsCount,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.isLiked,
    this.isViewed,
    this.user,
    this.media,
    this.taggedUsers,
    this.createdAt,
    this.updatedAt,
  });

  factory PostItem.fromRawJson(String str) =>
      PostItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostItem.fromJson(Map<String, dynamic> json) => PostItem(
    id: _toIntSafe(json["id"]),
    itemType: json["item_type"]?.toString(),
    type: json["type"]?.toString(),
    caption: json["caption"]?.toString(),
    locationName: json["location_name"]?.toString(),
    locationLat: _toDoubleSafe(json["location_lat"]),
    locationLng: _toDoubleSafe(json["location_lng"]),
    privacySetting: json["privacy_setting"]?.toString(),
    allowComments: _toBoolSafe(json["allow_comments"]),
    allowGifts: _toBoolSafe(json["allow_gifts"]),
    isDraft: _toBoolSafe(json["is_draft"]),
    status: json["status"]?.toString(),
    viewsCount: _toIntSafe(json["views_count"]),
    likesCount: _toIntSafe(json["likes_count"]),
    commentsCount: _toIntSafe(json["comments_count"]),
    sharesCount: _toIntSafe(json["shares_count"]),
    isLiked: _toBoolSafe(json["is_liked"]),
    isViewed: _toBoolSafe(json["is_viewed"]),
    user: json["user"] == null ? null : UserSummary.fromJson(json["user"]),
    media: json["media"] == null
        ? []
        : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    taggedUsers: json["tagged_users"] == null
        ? []
        : List<UserSummary>.from(
        json["tagged_users"]!.map((x) => UserSummary.fromJson(x))),
    createdAt: _toDateSafe(json["created_at"]),
    updatedAt: _toDateSafe(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_type": itemType,
    "type": type,
    "caption": caption,
    "location_name": locationName,
    "location_lat": locationLat,
    "location_lng": locationLng,
    "privacy_setting": privacySetting,
    "allow_comments": allowComments,
    "allow_gifts": allowGifts,
    "is_draft": isDraft,
    "status": status,
    "views_count": viewsCount,
    "likes_count": likesCount,
    "comments_count": commentsCount,
    "shares_count": sharesCount,
    "is_liked": isLiked,
    "is_viewed": isViewed,
    "user": user?.toJson(),
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
    "tagged_users": taggedUsers == null ? [] : List<dynamic>.from(taggedUsers!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Media {
  final int? id;
  final String? mediaUrl;
  final String? mediaType;
  final int? sortOrder;

  Media({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.sortOrder,
  });

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: _toIntSafe(json["id"]),
    mediaUrl: json["media_url"]?.toString(),
    mediaType: json["media_type"]?.toString(),
    sortOrder: _toIntSafe(json["sort_order"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media_url": mediaUrl,
    "media_type": mediaType,
    "sort_order": sortOrder,
  };
}

class UserSummary {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final bool? isFollow;

  UserSummary({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.isFollow,
  });

  factory UserSummary.fromRawJson(String str) =>
      UserSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
    id: _toIntSafe(json["id"]),
    avatar: json["avatar"]?.toString(),
    name: json["name"]?.toString(),
    username: json["username"]?.toString(),
    isFollow: _toBoolSafe(json["is_follow"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "username": username,
    "is_follow": isFollow,
  };
}

class DataUser {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final String? email;
  final String? dateOfBirth;
  final String? bio;
  final String? gender;
  final String? role;
  final String? status;
  final bool? termsAndConditions;
  final int? followersCount;
  final int? followingCount;
  final int? likesCount;
  final bool? isFriends;
  final bool? isFollow;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DataUser({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.email,
    this.dateOfBirth,
    this.bio,
    this.gender,
    this.role,
    this.status,
    this.termsAndConditions,
    this.followersCount,
    this.followingCount,
    this.likesCount,
    this.isFriends,
    this.isFollow,
    this.createdAt,
    this.updatedAt,
  });

  factory DataUser.fromRawJson(String str) =>
      DataUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
    id: _toIntSafe(json["id"]),
    avatar: json["avatar"]?.toString(),
    name: json["name"]?.toString(),
    username: json["username"]?.toString(),
    email: json["email"]?.toString(),
    dateOfBirth: json["date_of_birth"]?.toString(),
    bio: json["bio"]?.toString(),
    gender: json["gender"]?.toString(),
    role: json["role"]?.toString(),
    status: json["status"]?.toString(),
    termsAndConditions: _toBoolSafe(json["terms_and_conditions"]),
    followersCount: _toIntSafe(json["followers_count"]),
    followingCount: _toIntSafe(json["following_count"]),
    likesCount: _toIntSafe(json["likes_count"]),
    isFriends: _toBoolSafe(json["is_friends"]),
    isFollow: _toBoolSafe(json["is_follow"]),
    createdAt: _toDateSafe(json["created_at"]),
    updatedAt: _toDateSafe(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "username": username,
    "email": email,
    "date_of_birth": dateOfBirth,
    "bio": bio,
    "gender": gender,
    "role": role,
    "status": status,
    "terms_and_conditions": termsAndConditions,
    "followers_count": followersCount,
    "following_count": followingCount,
    "likes_count": likesCount,
    "is_friends": isFriends,
    "is_follow": isFollow,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

// ==========================================
// Safe Helper Parsers
// ==========================================

int? _toIntSafe(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _toDoubleSafe(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool? _toBoolSafe(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

DateTime? _toDateSafe(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}