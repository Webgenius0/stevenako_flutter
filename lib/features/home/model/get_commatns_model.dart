import 'dart:convert';

class GetUserCommentsModel {
  final bool? success;
  final String? message;
  final UserCommentsData? data;
  final int? code;

  GetUserCommentsModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory GetUserCommentsModel.fromRawJson(String str) =>
      GetUserCommentsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserCommentsModel.fromJson(Map<String, dynamic> json) {
    dynamic rawData = json["data"];

    if (rawData is List) {
      final List<Comment> commList = List<Comment>.from(
        rawData.map((x) => Comment.fromJson(x)),
      );
      return GetUserCommentsModel(
        success: _toBoolSafe(json["success"]),
        message: json["message"]?.toString(),
        data: UserCommentsData(
          post: Post(
            comments: commList,
            commentsCount: commList.length,
          ),
        ),
        code: _toIntSafe(json["code"]),
      );
    }

    return GetUserCommentsModel(
      success: _toBoolSafe(json["success"]),
      message: json["message"]?.toString(),
      data: rawData is Map<String, dynamic>
          ? UserCommentsData.fromJson(rawData)
          : null,
      code: _toIntSafe(json["code"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class UserCommentsData {
  final Post? post;

  UserCommentsData({this.post});

  factory UserCommentsData.fromRawJson(String str) =>
      UserCommentsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserCommentsData.fromJson(Map<String, dynamic> json) {
    Post? postObj;

    if (json["post"] != null && json["post"] is Map<String, dynamic>) {
      postObj = Post.fromJson(json["post"]);
    } else if (json["comments"] != null) {
      if (json["comments"] is List) {
        final List<Comment> commList = List<Comment>.from(
          (json["comments"] as List).map((x) => Comment.fromJson(x)),
        );
        postObj = Post(
          comments: commList,
          commentsCount: _toIntSafe(json["comments_count"]) ?? commList.length,
        );
      } else if (json["comments"] is Map<String, dynamic> &&
          json["comments"]["data"] is List) {
        final List<Comment> commList = List<Comment>.from(
          (json["comments"]["data"] as List).map((x) => Comment.fromJson(x)),
        );
        postObj = Post(
          comments: commList,
          commentsCount: _toIntSafe(json["comments_count"]) ?? commList.length,
        );
      }
    } else if (json["comment"] != null && json["comment"] is Map<String, dynamic>) {
      final comm = Comment.fromJson(json["comment"]);
      postObj = Post(
        comments: [comm],
        commentsCount: _toIntSafe(json["comments_count"]) ?? 1,
      );
    } else if (json["data"] != null && json["data"] is List) {
      final List<Comment> commList = List<Comment>.from(
        (json["data"] as List).map((x) => Comment.fromJson(x)),
      );
      postObj = Post(
        comments: commList,
        commentsCount: _toIntSafe(json["comments_count"]) ?? commList.length,
      );
    } else if (json["posts"] != null) {
      if (json["posts"] is Map<String, dynamic> &&
          json["posts"]["data"] is List) {
        final List list = json["posts"]["data"];
        List<Comment> allComments = [];
        int totalCount = 0;

        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final p = Post.fromJson(item);
            if (p.comments != null && p.comments!.isNotEmpty) {
              allComments.addAll(p.comments!);
            }
            if (p.commentsCount != null) {
              totalCount += p.commentsCount!;
            }
          }
        }

        if (list.isNotEmpty) {
          final firstPost = Post.fromJson(list.first as Map<String, dynamic>);
          postObj = Post(
            id: firstPost.id,
            comments: allComments.isNotEmpty ? allComments : (firstPost.comments ?? []),
            commentsCount: totalCount > 0 ? totalCount : (firstPost.commentsCount ?? allComments.length),
          );
        } else {
          postObj = Post(
            comments: [],
            commentsCount: 0,
          );
        }
      } else if (json["posts"] is List) {
        final List list = json["posts"];
        List<Comment> allComments = [];
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final p = Post.fromJson(item);
            if (p.comments != null && p.comments!.isNotEmpty) {
              allComments.addAll(p.comments!);
            }
          }
        }
        postObj = Post(
          comments: allComments,
          commentsCount: allComments.length,
        );
      } else {
        postObj = Post(
          comments: [],
          commentsCount: 0,
        );
      }
    }

    return UserCommentsData(post: postObj);
  }

  Map<String, dynamic> toJson() => {
    "post": post?.toJson(),
  };
}

class Post {
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
  final User? user;
  final List<Media>? media;
  final List<dynamic>? taggedUsers;
  final Sound? sound;
  final List<Comment>? comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.comments,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
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
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    media: json["media"] == null
        ? []
        : List<Media>.from(
        json["media"]!.map((x) => Media.fromJson(x))),
    taggedUsers: json["tagged_users"] == null
        ? []
        : List<dynamic>.from(json["tagged_users"]!.map((x) => x)),
    sound: json["sound"] == null ? null : Sound.fromJson(json["sound"]),
    comments: json["comments"] == null
        ? []
        : List<Comment>.from(
        json["comments"]!.map((x) => Comment.fromJson(x))),
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
    "tagged_users": taggedUsers == null ? [] : List<dynamic>.from(taggedUsers!.map((x) => x)),
    "sound": sound?.toJson(),
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Comment {
  final int? id;
  final int? postId;
  final String? content;
  final int? likesCount;
  final bool? isLiked;
  final int? parentId;
  final User? user;
  final List<Comment>? replies;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Comment({
    this.id,
    this.postId,
    this.content,
    this.likesCount,
    this.isLiked,
    this.parentId,
    this.user,
    this.replies,
    this.createdAt,
    this.updatedAt,
  });

  Comment copyWith({
    int? id,
    int? postId,
    String? content,
    int? likesCount,
    bool? isLiked,
    int? parentId,
    User? user,
    List<Comment>? replies,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Comment(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        content: content ?? this.content,
        likesCount: likesCount ?? this.likesCount,
        isLiked: isLiked ?? this.isLiked,
        parentId: parentId ?? this.parentId,
        user: user ?? this.user,
        replies: replies ?? this.replies,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: _toIntSafe(json["id"]),
    postId: _toIntSafe(json["post_id"]),
    content: json["content"]?.toString(),
    likesCount: _toIntSafe(json["likes_count"]),
    isLiked: _toBoolSafe(json["is_liked"]),
    parentId: _toIntSafe(json["parent_id"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    replies: json["replies"] == null
        ? []
        : List<Comment>.from(
        json["replies"]!.map((x) => Comment.fromJson(x))),
    createdAt: _toDateSafe(json["created_at"]),
    updatedAt: _toDateSafe(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_id": postId,
    "content": content,
    "likes_count": likesCount,
    "is_liked": isLiked,
    "parent_id": parentId,
    "user": user?.toJson(),
    "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class User {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final bool? isFollow;

  User({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.isFollow,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
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

class Sound {
  final int? id;
  final String? title;
  final String? artist;
  final String? audioUrl;
  final String? thumbnailUrl;
  final int? duration;
  final int? postsCount;
  final bool? isSaved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

  factory Sound.fromRawJson(String str) => Sound.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sound.fromJson(Map<String, dynamic> json) => Sound(
    id: _toIntSafe(json["id"]),
    title: json["title"]?.toString(),
    artist: json["artist"]?.toString(),
    audioUrl: json["audio_url"]?.toString(),
    thumbnailUrl: json["thumbnail_url"]?.toString(),
    duration: _toIntSafe(json["duration"]),
    postsCount: _toIntSafe(json["posts_count"]),
    isSaved: _toBoolSafe(json["is_saved"]),
    createdAt: _toDateSafe(json["created_at"]),
    updatedAt: _toDateSafe(json["updated_at"]),
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

// ==========================================
// Robust Safe Parsing Helpers for Production
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