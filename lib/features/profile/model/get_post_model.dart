import 'dart:convert';

class GetPostModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  GetPostModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetPostModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) {
    return GetPostModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  factory GetPostModel.fromRawJson(String str) {
    return GetPostModel.fromJson(
      json.decode(str) as Map<String, dynamic>,
    );
  }

  String toRawJson() => json.encode(toJson());

  factory GetPostModel.fromJson(Map<String, dynamic> json) {
    return GetPostModel(
      success: _toBool(json['success']),
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      code: _toInt(json['code']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'code': code,
    };
  }
}

class Data {
  List<Post>? posts;

  Data({
    this.posts,
  });

  Data copyWith({
    List<Post>? posts,
  }) {
    return Data(
      posts: posts ?? this.posts,
    );
  }

  factory Data.fromRawJson(String str) {
    return Data.fromJson(
      json.decode(str) as Map<String, dynamic>,
    );
  }

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      posts: (json['posts'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(Post.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts?.map((x) => x.toJson()).toList(),
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
  List<Media>? media;
  List<User>? taggedUsers;
  dynamic sound;
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
    this.media,
    this.taggedUsers,
    this.sound,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: _toInt(json['id']),
      itemType: json['item_type']?.toString(),
      type: json['type']?.toString(),
      caption: json['caption']?.toString(),
      locationName: json['location_name']?.toString(),
      locationLat: _toDouble(json['location_lat']),
      locationLng: _toDouble(json['location_lng']),
      privacySetting: json['privacy_setting']?.toString(),
      allowComments: _toBool(json['allow_comments']),
      allowGifts: _toBool(json['allow_gifts']),
      isDraft: _toBool(json['is_draft']),
      status: json['status']?.toString(),
      viewsCount: _toInt(json['views_count']),
      likesCount: _toInt(json['likes_count']),
      commentsCount: _toInt(json['comments_count']),
      sharesCount: _toInt(json['shares_count']),
      isLiked: _toBool(json['is_liked']),
      isViewed: _toBool(json['is_viewed']),
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      media: (json['media'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(Media.fromJson)
          .toList(),
      taggedUsers: (json['tagged_users'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(User.fromJson)
          .toList(),
      sound: json['sound'],
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type': itemType,
      'type': type,
      'caption': caption,
      'location_name': locationName,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'privacy_setting': privacySetting,
      'allow_comments': allowComments,
      'allow_gifts': allowGifts,
      'is_draft': isDraft,
      'status': status,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'is_liked': isLiked,
      'is_viewed': isViewed,
      'user': user?.toJson(),
      'media': media?.map((x) => x.toJson()).toList(),
      'tagged_users': taggedUsers?.map((x) => x.toJson()).toList(),
      'sound': sound,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _toInt(json['id']),
      avatar: json['avatar']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      isFollow: _toBool(json['is_follow']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
      'username': username,
      'is_follow': isFollow,
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

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: _toInt(json['id']),
      mediaUrl: json['media_url']?.toString(),
      mediaType: json['media_type']?.toString(),
      sortOrder: _toInt(json['sort_order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'sort_order': sortOrder,
    };
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool? _toBool(dynamic value) {
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

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
