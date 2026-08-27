import 'dart:convert';

class GetMyPhotoPostModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  GetMyPhotoPostModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetMyPhotoPostModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) {
    return GetMyPhotoPostModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  factory GetMyPhotoPostModel.fromRawJson(String str) {
    return GetMyPhotoPostModel.fromJson(
      json.decode(str) as Map<String, dynamic>,
    );
  }

  String toRawJson() => json.encode(toJson());

  factory GetMyPhotoPostModel.fromJson(Map<String, dynamic> json) {
    return GetMyPhotoPostModel(
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
    final postsJson = json['posts'];

    return Data(
      posts: postsJson is List
          ? postsJson
          .whereType<Map<String, dynamic>>()
          .map(Post.fromJson)
          .toList()
          : <Post>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts?.map((x) => x.toJson()).toList() ?? [],
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
    dynamic sound,
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
    return Post.fromJson(
      json.decode(str) as Map<String, dynamic>,
    );
  }

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) {
    final mediaJson = json['media'];
    final taggedUsersJson = json['tagged_users'];

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
      media: mediaJson is List
          ? mediaJson
          .whereType<Map<String, dynamic>>()
          .map(Media.fromJson)
          .toList()
          : <Media>[],
      taggedUsers: taggedUsersJson is List
          ? taggedUsersJson
          .whereType<Map<String, dynamic>>()
          .map(User.fromJson)
          .toList()
          : <User>[],
      sound: json['sound'],
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
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
      'media': media?.map((x) => x.toJson()).toList() ?? [],
      'tagged_users':
      taggedUsers?.map((x) => x.toJson()).toList() ?? [],
      'sound': sound,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
    return Media.fromJson(
      json.decode(str) as Map<String, dynamic>,
    );
  }

  String toRawJson() => json.encode(toJson());

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
    return User.fromJson(
      json.decode(str) as Map<String, dynamic>,
    );
  }

  String toRawJson() => json.encode(toJson());

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

/// Safely converts int, double, or numeric String to int.
int? _toInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  }

  return null;
}

/// Safely converts int, double, or numeric String to double.
double? _toDouble(dynamic value) {
  if (value == null) return null;

  if (value is double) return value;

  if (value is int) return value.toDouble();

  if (value is String) {
    return double.tryParse(value);
  }

  return null;
}

/// Safely converts different boolean formats.
bool? _toBool(dynamic value) {
  if (value == null) return null;

  if (value is bool) return value;

  if (value is int) {
    if (value == 1) return true;
    if (value == 0) return false;
  }

  if (value is String) {
    final normalized = value.toLowerCase().trim();

    if (normalized == 'true' || normalized == '1') {
      return true;
    }

    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }

  return null;
}

/// Safely parses DateTime.
DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(value.toString());
}