import 'dart:convert';

class UserPostModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  UserPostModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  UserPostModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) {
    return UserPostModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  factory UserPostModel.fromRawJson(String str) {
    return UserPostModel.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory UserPostModel.fromJson(Map<String, dynamic> json) {
    return UserPostModel(
      success: json["success"] is bool ? json["success"] : null,
      message: json["message"]?.toString(),
      data: json["data"] is Map<String, dynamic>
          ? Data.fromJson(json["data"])
          : null,
      code: _parseInt(json["code"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
      "code": code,
    };
  }
}

class Data {
  Post? post;

  Data({
    this.post,
  });

  Data copyWith({
    Post? post,
  }) {
    return Data(
      post: post ?? this.post,
    );
  }

  factory Data.fromRawJson(String str) {
    return Data.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      post: json["post"] is Map<String, dynamic>
          ? Post.fromJson(json["post"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "post": post?.toJson(),
    };
  }
}

class Post {
  int? id;
  String? itemType;
  String? type;
  String? caption;
  String? locationName;
  double? locationLat;
  double? locationLng;
  String? privacySetting;
  bool? allowComments;
  bool? allowGifts;
  bool? isDraft;
  String? status;
  int? viewsCount;
  int? likesCount;
  int? commentsCount;
  int? sharesCount;
  bool? isLiked;
  bool? isViewed;
  User? user;
  List<Media> media;
  List<User> taggedUsers;
  Sound? sound;
  DateTime? createdAt;
  DateTime? updatedAt;

  Post({
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
    this.media = const [],
    this.taggedUsers = const [],
    this.sound,
    this.createdAt,
    this.updatedAt,
  });

  Post copyWith({
    int? id,
    String? itemType,
    String? type,
    String? caption,
    String? locationName,
    double? locationLat,
    double? locationLng,
    String? privacySetting,
    bool? allowComments,
    bool? allowGifts,
    bool? isDraft,
    String? status,
    int? viewsCount,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isViewed,
    User? user,
    List<Media>? media,
    List<User>? taggedUsers,
    Sound? sound,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      type: type ?? this.type,
      caption: caption ?? this.caption,
      locationName: locationName ?? this.locationName,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      privacySetting: privacySetting ?? this.privacySetting,
      allowComments: allowComments ?? this.allowComments,
      allowGifts: allowGifts ?? this.allowGifts,
      isDraft: isDraft ?? this.isDraft,
      status: status ?? this.status,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isViewed: isViewed ?? this.isViewed,
      user: user ?? this.user,
      media: media ?? this.media,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      sound: sound ?? this.sound,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Post.fromRawJson(String str) {
    return Post.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: _parseInt(json["id"]),
      itemType: json["item_type"]?.toString(),
      type: json["type"]?.toString(),
      caption: json["caption"]?.toString(),
      locationName: json["location_name"]?.toString(),

      locationLat: _parseDouble(json["location_lat"]),
      locationLng: _parseDouble(json["location_lng"]),

      privacySetting: json["privacy_setting"]?.toString(),

      allowComments: _parseBool(json["allow_comments"]),
      allowGifts: _parseBool(json["allow_gifts"]),
      isDraft: _parseBool(json["is_draft"]),

      status: json["status"]?.toString(),

      viewsCount: _parseInt(json["views_count"]),
      likesCount: _parseInt(json["likes_count"]),
      commentsCount: _parseInt(json["comments_count"]),
      sharesCount: _parseInt(json["shares_count"]),

      isLiked: _parseBool(json["is_liked"]),
      isViewed: _parseBool(json["is_viewed"]),

      user: json["user"] is Map<String, dynamic>
          ? User.fromJson(json["user"])
          : null,

      media: (json["media"] as List?)
          ?.whereType<Map<String, dynamic>>()
          .map((e) => Media.fromJson(e))
          .toList() ??
          [],

      taggedUsers: (json["tagged_users"] as List?)
          ?.whereType<Map<String, dynamic>>()
          .map((e) => User.fromJson(e))
          .toList() ??
          [],

      sound: json["sound"] is Map<String, dynamic>
          ? Sound.fromJson(json["sound"])
          : null,

      createdAt: _parseDate(json["created_at"]),
      updatedAt: _parseDate(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "media": media.map((x) => x.toJson()).toList(),
      "tagged_users": taggedUsers.map((x) => x.toJson()).toList(),
      "sound": sound?.toJson(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}

class Media {
  int? id;
  String? mediaUrl;
  String? mediaType;
  int? sortOrder;

  Media({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.sortOrder,
  });

  Media copyWith({
    int? id,
    String? mediaUrl,
    String? mediaType,
    int? sortOrder,
  }) {
    return Media(
      id: id ?? this.id,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory Media.fromRawJson(String str) {
    return Media.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: _parseInt(json["id"]),
      mediaUrl: json["media_url"]?.toString(),
      mediaType: json["media_type"]?.toString(),
      sortOrder: _parseInt(json["sort_order"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "media_url": mediaUrl,
      "media_type": mediaType,
      "sort_order": sortOrder,
    };
  }
}

class User {
  int? id;
  String? avatar;
  String? name;
  String? username;
  bool? isFollow;

  User({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.isFollow,
  });

  User copyWith({
    int? id,
    String? avatar,
    String? name,
    String? username,
    bool? isFollow,
  }) {
    return User(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      username: username ?? this.username,
      isFollow: isFollow ?? this.isFollow,
    );
  }

  factory User.fromRawJson(String str) {
    return User.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _parseInt(json["id"]),
      avatar: json["avatar"]?.toString(),
      name: json["name"]?.toString(),
      username: json["username"]?.toString(),
      isFollow: _parseBool(json["is_follow"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "avatar": avatar,
      "name": name,
      "username": username,
      "is_follow": isFollow,
    };
  }
}

class Sound {
  int? id;
  String? name;
  String? url;

  Sound({
    this.id,
    this.name,
    this.url,
  });

  Sound copyWith({
    int? id,
    String? name,
    String? url,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Sound.fromRawJson(String str) {
    return Sound.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      id: _parseInt(json["id"]),
      name: json["name"]?.toString(),
      url: json["url"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "url": url,
    };
  }
}

// ===============================
// Safe Parsers
// ===============================

int? _parseInt(dynamic value) {
  if (value == null) return null;

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString());
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;

  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

bool? _parseBool(dynamic value) {
  if (value == null) return null;

  if (value is bool) {
    return value;
  }

  if (value is int) {
    return value == 1;
  }

  if (value is String) {
    final normalized = value.toLowerCase().trim();

    if (normalized == "true" ||
        normalized == "1" ||
        normalized == "yes") {
      return true;
    }

    if (normalized == "false" ||
        normalized == "0" ||
        normalized == "no") {
      return false;
    }
  }

  return null;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(value.toString());
}