import 'dart:convert';

class GetAllPostModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  GetAllPostModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetAllPostModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) =>
      GetAllPostModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory GetAllPostModel.fromRawJson(String str) =>
      GetAllPostModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllPostModel.fromJson(Map<String, dynamic> json) =>
      GetAllPostModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class Data {
  List<Post>? posts;

  Data({
    this.posts,
  });

  Data copyWith({
    List<Post>? posts,
  }) =>
      Data(
        posts: posts ?? this.posts,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    posts: json["posts"] == null
        ? []
        : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "posts": posts == null
        ? []
        : List<dynamic>.from(posts!.map((x) => x.toJson())),
  };
}

class Post {
  int? id;
  ItemType? itemType;
  Type? type;
  String? caption;
  String? locationName;
  double? locationLat;
  double? locationLng;
  PrivacySetting? privacySetting;
  bool? allowComments;
  bool? allowGifts;
  bool? isDraft;
  Status? status;
  int? viewsCount;
  int? likesCount;
  int? commentsCount;
  int? sharesCount;
  bool? isLiked;
  bool? isViewed;
  User? user;
  List<Media>? media;
  List<User>? taggedUsers;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  String? mediaUrl;
  MediaType? mediaType;
  String? targetUrl;
  int? clicksCount;

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
    ItemType? itemType,
    Type? type,
    String? caption,
    String? locationName,
    double? locationLat,
    double? locationLng,
    PrivacySetting? privacySetting,
    bool? allowComments,
    bool? allowGifts,
    bool? isDraft,
    Status? status,
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
    MediaType? mediaType,
    String? targetUrl,
    int? clicksCount,
  }) =>
      Post(
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

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    itemType: itemTypeValues.map[json["item_type"]],
    type: typeValues.map[json["type"]],
    caption: json["caption"],
    locationName: json["location_name"],
    locationLat: json["location_lat"]?.toDouble(),
    locationLng: json["location_lng"]?.toDouble(),
    privacySetting: privacySettingValues.map[json["privacy_setting"]],
    allowComments: json["allow_comments"],
    allowGifts: json["allow_gifts"],
    isDraft: json["is_draft"],
    status: statusValues.map[json["status"]],
    viewsCount: json["views_count"],
    likesCount: json["likes_count"],
    commentsCount: json["comments_count"],
    sharesCount: json["shares_count"],
    isLiked: json["is_liked"],
    isViewed: json["is_viewed"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    media: json["media"] == null
        ? []
        : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    taggedUsers: json["tagged_users"] == null
        ? []
        : List<User>.from(
        json["tagged_users"]!.map((x) => User.fromJson(x))),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
    title: json["title"],
    mediaUrl: json["media_url"],
    mediaType: mediaTypeValues.map[json["media_type"]],
    targetUrl: json["target_url"],
    clicksCount: json["clicks_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_type": itemTypeValues.reverse[itemType],
    "type": typeValues.reverse[type],
    "caption": caption,
    "location_name": locationName,
    "location_lat": locationLat,
    "location_lng": locationLng,
    "privacy_setting": privacySettingValues.reverse[privacySetting],
    "allow_comments": allowComments,
    "allow_gifts": allowGifts,
    "is_draft": isDraft,
    "status": statusValues.reverse[status],
    "views_count": viewsCount,
    "likes_count": likesCount,
    "comments_count": commentsCount,
    "shares_count": sharesCount,
    "is_liked": isLiked,
    "is_viewed": isViewed,
    "user": user?.toJson(),
    "media": media == null
        ? []
        : List<dynamic>.from(media!.map((x) => x.toJson())),
    "tagged_users": taggedUsers == null
        ? []
        : List<dynamic>.from(taggedUsers!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "title": title,
    "media_url": mediaUrl,
    "media_type": mediaTypeValues.reverse[mediaType],
    "target_url": targetUrl,
    "clicks_count": clicksCount,
  };
}

enum ItemType { AD, POST }

final itemTypeValues = EnumValues({
  "ad": ItemType.AD,
  "post": ItemType.POST,
});

class Media {
  int? id;
  String? mediaUrl;
  MediaType? mediaType;
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
    MediaType? mediaType,
    int? sortOrder,
  }) =>
      Media(
        id: id ?? this.id,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        mediaType: mediaType ?? this.mediaType,
        sortOrder: sortOrder ?? this.sortOrder,
      );

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    mediaUrl: json["media_url"],
    mediaType: mediaTypeValues.map[json["media_type"]],
    sortOrder: json["sort_order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media_url": mediaUrl,
    "media_type": mediaTypeValues.reverse[mediaType],
    "sort_order": sortOrder,
  };
}

enum Type { AD, PHOTO, TEXT, VIDEO }

final typeValues = EnumValues({
  "ad": Type.AD,
  "photo": Type.PHOTO,
  "text": Type.TEXT,
  "video": Type.VIDEO,
});

enum MediaType { IMAGE, VIDEO }

final mediaTypeValues = EnumValues({
  "image": MediaType.IMAGE,
  "video": MediaType.VIDEO,
});

enum PrivacySetting { EVERYONE, FOLLOWERS_ONLY, FRIENDS }

final privacySettingValues = EnumValues({
  "everyone": PrivacySetting.EVERYONE,
  "followers_only": PrivacySetting.FOLLOWERS_ONLY,
  "friends": PrivacySetting.FRIENDS,
});

enum Status { ACTIVE }

final statusValues = EnumValues({
  "active": Status.ACTIVE,
});

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
  }) =>
      User(
        id: id ?? this.id,
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        username: username ?? this.username,
        isFollow: isFollow ?? this.isFollow,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    avatar: json["avatar"],
    name: json["name"],
    username: json["username"],
    isFollow: json["is_follow"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "username": username,
    "is_follow": isFollow,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? _reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse =>
      _reverseMap ??= map.map((k, v) => MapEntry(v, k));
}