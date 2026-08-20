import 'dart:convert';

class GetReelsListModel {
  final bool? success;
  final String? message;
  final ReelsData? data;
  final int? code;

  const GetReelsListModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetReelsListModel copyWith({
    bool? success,
    String? message,
    ReelsData? data,
    int? code,
  }) {
    return GetReelsListModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  factory GetReelsListModel.fromRawJson(String source) {
    return GetReelsListModel.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory GetReelsListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return GetReelsListModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      data: data is Map<String, dynamic>
          ? ReelsData.fromJson(data)
          : null,
      code: _parseInt(json['code']),
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

class ReelsData {
  final List<Post> posts;

  const ReelsData({
    this.posts = const [],
  });

  ReelsData copyWith({
    List<Post>? posts,
  }) {
    return ReelsData(
      posts: posts ?? this.posts,
    );
  }

  factory ReelsData.fromRawJson(String source) {
    return ReelsData.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory ReelsData.fromJson(Map<String, dynamic> json) {
    final postsJson = json['posts'];

    return ReelsData(
      posts: postsJson is List
          ? postsJson
          .whereType<Map<String, dynamic>>()
          .map(Post.fromJson)
          .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((post) => post.toJson()).toList(),
    };
  }
}

class Post {
  final int? id;
  final ReelItemType? itemType;
  final ReelContentType? type;
  final String? caption;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;
  final String? privacySetting;
  final bool? allowComments;
  final bool? allowGifts;
  final bool? isDraft;
  final PostStatus? status;
  final int? viewsCount;
  final int? likesCount;
  final int? commentsCount;
  final int? sharesCount;
  final bool? isLiked;
  final bool? isViewed;
  final User? user;
  final List<Media> media;
  final List<User> taggedUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Advertisement-related fields.
  final String? title;
  final String? mediaUrl;
  final String? mediaType;
  final String? targetUrl;
  final int? clicksCount;

  const Post({
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
    this.createdAt,
    this.updatedAt,
    this.title,
    this.mediaUrl,
    this.mediaType,
    this.targetUrl,
    this.clicksCount,
  });

  Post copyWith({
    int? id,
    ReelItemType? itemType,
    ReelContentType? type,
    String? caption,
    String? locationName,
    double? locationLat,
    double? locationLng,
    String? privacySetting,
    bool? allowComments,
    bool? allowGifts,
    bool? isDraft,
    PostStatus? status,
    int? viewsCount,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isViewed,
    User? user,
    List<Media>? media,
    List<User>? taggedUsers,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? mediaUrl,
    String? mediaType,
    String? targetUrl,
    int? clicksCount,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      targetUrl: targetUrl ?? this.targetUrl,
      clicksCount: clicksCount ?? this.clicksCount,
    );
  }

  factory Post.fromRawJson(String source) {
    return Post.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final mediaJson = json['media'];
    final taggedUsersJson = json['tagged_users'];

    return Post(
      id: _parseInt(json['id']),
      itemType: ReelItemTypeX.fromJson(json['item_type']),
      type: ReelContentTypeX.fromJson(json['type']),
      caption: _parseString(json['caption']),
      locationName: _parseString(json['location_name']),
      locationLat: _parseDouble(json['location_lat']),
      locationLng: _parseDouble(json['location_lng']),
      privacySetting: _parseString(json['privacy_setting']),
      allowComments: _parseBool(json['allow_comments']),
      allowGifts: _parseBool(json['allow_gifts']),
      isDraft: _parseBool(json['is_draft']),
      status: PostStatusX.fromJson(json['status']),
      viewsCount: _parseInt(json['views_count']),
      likesCount: _parseInt(json['likes_count']),
      commentsCount: _parseInt(json['comments_count']),
      sharesCount: _parseInt(json['shares_count']),
      isLiked: _parseBool(json['is_liked']),
      isViewed: _parseBool(json['is_viewed']),
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      media: mediaJson is List
          ? mediaJson
          .whereType<Map<String, dynamic>>()
          .map(Media.fromJson)
          .toList()
          : const [],
      taggedUsers: taggedUsersJson is List
          ? taggedUsersJson
          .whereType<Map<String, dynamic>>()
          .map(User.fromJson)
          .toList()
          : const [],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      title: _parseString(json['title']),
      mediaUrl: _parseString(json['media_url']),
      mediaType: _parseString(json['media_type']),
      targetUrl: _parseString(json['target_url']),
      clicksCount: _parseInt(json['clicks_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type': itemType?.value,
      'type': type?.value,
      'caption': caption,
      'location_name': locationName,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'privacy_setting': privacySetting,
      'allow_comments': allowComments,
      'allow_gifts': allowGifts,
      'is_draft': isDraft,
      'status': status?.value,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'is_liked': isLiked,
      'is_viewed': isViewed,
      'user': user?.toJson(),
      'media': media.map((item) => item.toJson()).toList(),
      'tagged_users':
      taggedUsers.map((item) => item.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'title': title,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'target_url': targetUrl,
      'clicks_count': clicksCount,
    };
  }
}

enum ReelItemType {
  ad,
  post,
}

extension ReelItemTypeX on ReelItemType {
  String get value {
    switch (this) {
      case ReelItemType.ad:
        return 'ad';
      case ReelItemType.post:
        return 'post';
    }
  }

  static ReelItemType? fromJson(dynamic value) {
    switch (value?.toString()) {
      case 'ad':
        return ReelItemType.ad;
      case 'post':
        return ReelItemType.post;
      default:
        return null;
    }
  }
}

enum ReelContentType {
  ad,
  video,
}

extension ReelContentTypeX on ReelContentType {
  String get value {
    switch (this) {
      case ReelContentType.ad:
        return 'ad';
      case ReelContentType.video:
        return 'video';
    }
  }

  static ReelContentType? fromJson(dynamic value) {
    switch (value?.toString()) {
      case 'ad':
        return ReelContentType.ad;
      case 'video':
        return ReelContentType.video;
      default:
        return null;
    }
  }
}

enum PostStatus {
  active,
}

extension PostStatusX on PostStatus {
  String get value {
    switch (this) {
      case PostStatus.active:
        return 'active';
    }
  }

  static PostStatus? fromJson(dynamic value) {
    switch (value?.toString()) {
      case 'active':
        return PostStatus.active;
      default:
        return null;
    }
  }
}

class Media {
  final int? id;
  final String? mediaUrl;
  final ReelContentType? mediaType;
  final int? sortOrder;

  const Media({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.sortOrder,
  });

  Media copyWith({
    int? id,
    String? mediaUrl,
    ReelContentType? mediaType,
    int? sortOrder,
  }) {
    return Media(
      id: id ?? this.id,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory Media.fromRawJson(String source) {
    return Media.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: _parseInt(json['id']),
      mediaUrl: _parseString(json['media_url']),
      mediaType: ReelContentTypeX.fromJson(json['media_type']),
      sortOrder: _parseInt(json['sort_order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_url': mediaUrl,
      'media_type': mediaType?.value,
      'sort_order': sortOrder,
    };
  }
}

class User {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final bool? isFollow;

  const User({
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

  factory User.fromRawJson(String source) {
    return User.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _parseInt(json['id']),
      avatar: _parseString(json['avatar']),
      name: _parseString(json['name']),
      username: _parseString(json['username']),
      isFollow: _parseBool(json['is_follow']),
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

// -----------------------------------------------------------------------------
// SAFE PARSERS
// -----------------------------------------------------------------------------

String? _parseString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

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

  if (value is num) {
    if (value == 1) return true;
    if (value == 0) return false;
  }

  final normalized = value.toString().toLowerCase().trim();

  if (normalized == 'true' || normalized == '1') {
    return true;
  }

  if (normalized == 'false' || normalized == '0') {
    return false;
  }

  return null;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;

  final stringValue = value.toString().trim();

  if (stringValue.isEmpty) return null;

  return DateTime.tryParse(stringValue);
}