import 'dart:convert';

class GetMyVodeoPostModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  GetMyVodeoPostModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetMyVodeoPostModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) =>
      GetMyVodeoPostModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory GetMyVodeoPostModel.fromRawJson(String str) => GetMyVodeoPostModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMyVodeoPostModel.fromJson(Map<String, dynamic> json) => GetMyVodeoPostModel(
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
    posts: json["posts"] == null ? [] : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
  };
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
    Sound? sound,
    DateTime? createdAt,
    DateTime? updatedAt,
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
        sound: sound ?? this.sound,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    itemType: json["item_type"],
    type: json["type"],
    caption: json["caption"],
    locationName: json["location_name"],
    locationLat: json["location_lat"]?.toDouble(),
    locationLng: json["location_lng"]?.toDouble(),
    privacySetting: json["privacy_setting"],
    allowComments: json["allow_comments"],
    allowGifts: json["allow_gifts"],
    isDraft: json["is_draft"],
    status: json["status"],
    viewsCount: json["views_count"],
    likesCount: json["likes_count"],
    commentsCount: json["comments_count"],
    sharesCount: json["shares_count"],
    isLiked: json["is_liked"],
    isViewed: json["is_viewed"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    taggedUsers: json["tagged_users"] == null ? [] : List<User>.from(json["tagged_users"]!.map((x) => User.fromJson(x))),
    sound: json["sound"] == null ? null : Sound.fromJson(json["sound"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    "sound": sound?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Media {
  int? id;
  String? mediaUrl;
  String? mediaType;
  String? thumbnailUrl;
  int? sortOrder;

  Media({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.thumbnailUrl,
    this.sortOrder,
  });

  Media copyWith({
    int? id,
    String? mediaUrl,
    String? mediaType,
    String? thumbnailUrl,
    int? sortOrder,
  }) =>
      Media(
        id: id ?? this.id,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        mediaType: mediaType ?? this.mediaType,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        sortOrder: sortOrder ?? this.sortOrder,
      );

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    mediaUrl: json["media_url"],
    mediaType: json["media_type"],
    thumbnailUrl: json["thumbnail_url"] ?? json["thumbnail"] ?? json["poster_url"] ?? json["poster"],
    sortOrder: json["sort_order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media_url": mediaUrl,
    "media_type": mediaType,
    "thumbnail_url": thumbnailUrl,
    "sort_order": sortOrder,
  };
}

class Sound {
  int? id;
  String? title;
  String? artist;
  String? audioUrl;
  String? thumbnailUrl;
  int? duration;
  int? postsCount;
  bool? isSaved;
  DateTime? createdAt;
  DateTime? updatedAt;

  Sound({
    this.id,
    this.title,
    this.artist,
    this.audioUrl,
    this.thumbnailUrl,
    this.duration,
    this.postsCount,
    this.isSaved,
    this.createdAt,
    this.updatedAt,
  });

  Sound copyWith({
    int? id,
    String? title,
    String? artist,
    String? audioUrl,
    String? thumbnailUrl,
    int? duration,
    int? postsCount,
    bool? isSaved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Sound(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        audioUrl: audioUrl ?? this.audioUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        duration: duration ?? this.duration,
        postsCount: postsCount ?? this.postsCount,
        isSaved: isSaved ?? this.isSaved,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Sound.fromRawJson(String str) => Sound.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sound.fromJson(Map<String, dynamic> json) => Sound(
    id: json["id"],
    title: json["title"],
    artist: json["artist"],
    audioUrl: json["audio_url"],
    thumbnailUrl: json["thumbnail_url"],
    duration: json["duration"],
    postsCount: json["posts_count"],
    isSaved: json["is_saved"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "artist": artist,
    "audio_url": audioUrl,
    "thumbnail_url": thumbnailUrl,
    "duration": duration,
    "posts_count": postsCount,
    "is_saved": isSaved,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
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
