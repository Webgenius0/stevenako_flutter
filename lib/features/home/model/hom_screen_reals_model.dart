// import 'dart:convert';
//
// class GetReelsListModel {
//   final bool? success;
//   final String? message;
//   final ReelsData? data;
//   final int? code;
//
//   const GetReelsListModel({
//     this.success,
//     this.message,
//     this.data,
//     this.code,
//   });
//
//   GetReelsListModel copyWith({
//     bool? success,
//     String? message,
//     ReelsData? data,
//     int? code,
//   }) {
//     return GetReelsListModel(
//       success: success ?? this.success,
//       message: message ?? this.message,
//       data: data ?? this.data,
//       code: code ?? this.code,
//     );
//   }
//
//   factory GetReelsListModel.fromRawJson(String source) {
//     return GetReelsListModel.fromJson(
//       jsonDecode(source) as Map<String, dynamic>,
//     );
//   }
//
//   String toRawJson() {
//     return jsonEncode(toJson());
//   }
//
//   factory GetReelsListModel.fromJson(Map<String, dynamic> json) {
//     final data = json['data'];
//
//     return GetReelsListModel(
//       success: _parseBool(json['success']),
//       message: _parseString(json['message']),
//       data: data is Map<String, dynamic>
//           ? ReelsData.fromJson(data)
//           : null,
//       code: _parseInt(json['code']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toJson(),
//       'code': code,
//     };
//   }
// }
//
// class ReelsData {
//   final List<Post> posts;
//
//   const ReelsData({
//     this.posts = const [],
//   });
//
//   ReelsData copyWith({
//     List<Post>? posts,
//   }) {
//     return ReelsData(
//       posts: posts ?? this.posts,
//     );
//   }
//
//   factory ReelsData.fromRawJson(String source) {
//     return ReelsData.fromJson(
//       jsonDecode(source) as Map<String, dynamic>,
//     );
//   }
//
//   String toRawJson() {
//     return jsonEncode(toJson());
//   }
//
//   factory ReelsData.fromJson(Map<String, dynamic> json) {
//     final postsJson = json['posts'];
//
//     return ReelsData(
//       posts: postsJson is List
//           ? postsJson
//           .whereType<Map<String, dynamic>>()
//           .map(Post.fromJson)
//           .toList()
//           : const [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'posts': posts.map((post) => post.toJson()).toList(),
//     };
//   }
// }
//
// class Post {
//   final int? id;
//   final ReelItemType? itemType;
//   final ReelContentType? type;
//   final String? caption;
//   final String? locationName;
//   final double? locationLat;
//   final double? locationLng;
//   final String? privacySetting;
//   final bool? allowComments;
//   final bool? allowGifts;
//   final bool? isDraft;
//   final PostStatus? status;
//   final int? viewsCount;
//   final int? likesCount;
//   final int? commentsCount;
//   final int? sharesCount;
//   final bool? isLiked;
//   final bool? isViewed;
//   final User? user;
//   final List<Media> media;
//   final List<User> taggedUsers;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   // Advertisement-related fields.
//   final String? title;
//   final String? mediaUrl;
//   final String? mediaType;
//   final String? targetUrl;
//   final int? clicksCount;
//
//   const Post({
//     this.id,
//     this.itemType,
//     this.type,
//     this.caption,
//     this.locationName,
//     this.locationLat,
//     this.locationLng,
//     this.privacySetting,
//     this.allowComments,
//     this.allowGifts,
//     this.isDraft,
//     this.status,
//     this.viewsCount,
//     this.likesCount,
//     this.commentsCount,
//     this.sharesCount,
//     this.isLiked,
//     this.isViewed,
//     this.user,
//     this.media = const [],
//     this.taggedUsers = const [],
//     this.createdAt,
//     this.updatedAt,
//     this.title,
//     this.mediaUrl,
//     this.mediaType,
//     this.targetUrl,
//     this.clicksCount,
//   });
//
//   Post copyWith({
//     int? id,
//     ReelItemType? itemType,
//     ReelContentType? type,
//     String? caption,
//     String? locationName,
//     double? locationLat,
//     double? locationLng,
//     String? privacySetting,
//     bool? allowComments,
//     bool? allowGifts,
//     bool? isDraft,
//     PostStatus? status,
//     int? viewsCount,
//     int? likesCount,
//     int? commentsCount,
//     int? sharesCount,
//     bool? isLiked,
//     bool? isViewed,
//     User? user,
//     List<Media>? media,
//     List<User>? taggedUsers,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     String? title,
//     String? mediaUrl,
//     String? mediaType,
//     String? targetUrl,
//     int? clicksCount,
//   }) {
//     return Post(
//       id: id ?? this.id,
//       itemType: itemType ?? this.itemType,
//       type: type ?? this.type,
//       caption: caption ?? this.caption,
//       locationName: locationName ?? this.locationName,
//       locationLat: locationLat ?? this.locationLat,
//       locationLng: locationLng ?? this.locationLng,
//       privacySetting: privacySetting ?? this.privacySetting,
//       allowComments: allowComments ?? this.allowComments,
//       allowGifts: allowGifts ?? this.allowGifts,
//       isDraft: isDraft ?? this.isDraft,
//       status: status ?? this.status,
//       viewsCount: viewsCount ?? this.viewsCount,
//       likesCount: likesCount ?? this.likesCount,
//       commentsCount: commentsCount ?? this.commentsCount,
//       sharesCount: sharesCount ?? this.sharesCount,
//       isLiked: isLiked ?? this.isLiked,
//       isViewed: isViewed ?? this.isViewed,
//       user: user ?? this.user,
//       media: media ?? this.media,
//       taggedUsers: taggedUsers ?? this.taggedUsers,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       title: title ?? this.title,
//       mediaUrl: mediaUrl ?? this.mediaUrl,
//       mediaType: mediaType ?? this.mediaType,
//       targetUrl: targetUrl ?? this.targetUrl,
//       clicksCount: clicksCount ?? this.clicksCount,
//     );
//   }
//
//   factory Post.fromRawJson(String source) {
//     return Post.fromJson(
//       jsonDecode(source) as Map<String, dynamic>,
//     );
//   }
//
//   String toRawJson() {
//     return jsonEncode(toJson());
//   }
//
//   factory Post.fromJson(Map<String, dynamic> json) {
//     final mediaJson = json['media'];
//     final taggedUsersJson = json['tagged_users'];
//
//     return Post(
//       id: _parseInt(json['id']),
//       itemType: ReelItemTypeX.fromJson(json['item_type']),
//       type: ReelContentTypeX.fromJson(json['type']),
//       caption: _parseString(json['caption']),
//       locationName: _parseString(json['location_name']),
//       locationLat: _parseDouble(json['location_lat']),
//       locationLng: _parseDouble(json['location_lng']),
//       privacySetting: _parseString(json['privacy_setting']),
//       allowComments: _parseBool(json['allow_comments']),
//       allowGifts: _parseBool(json['allow_gifts']),
//       isDraft: _parseBool(json['is_draft']),
//       status: PostStatusX.fromJson(json['status']),
//       viewsCount: _parseInt(json['views_count']),
//       likesCount: _parseInt(json['likes_count']),
//       commentsCount: _parseInt(json['comments_count']),
//       sharesCount: _parseInt(json['shares_count']),
//       isLiked: _parseBool(json['is_liked']),
//       isViewed: _parseBool(json['is_viewed']),
//       user: json['user'] is Map<String, dynamic>
//           ? User.fromJson(json['user'] as Map<String, dynamic>)
//           : null,
//       media: mediaJson is List
//           ? mediaJson
//           .whereType<Map<String, dynamic>>()
//           .map(Media.fromJson)
//           .toList()
//           : const [],
//       taggedUsers: taggedUsersJson is List
//           ? taggedUsersJson
//           .whereType<Map<String, dynamic>>()
//           .map(User.fromJson)
//           .toList()
//           : const [],
//       createdAt: _parseDateTime(json['created_at']),
//       updatedAt: _parseDateTime(json['updated_at']),
//       title: _parseString(json['title']),
//       mediaUrl: _parseString(json['media_url']),
//       mediaType: _parseString(json['media_type']),
//       targetUrl: _parseString(json['target_url']),
//       clicksCount: _parseInt(json['clicks_count']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'item_type': itemType?.value,
//       'type': type?.value,
//       'caption': caption,
//       'location_name': locationName,
//       'location_lat': locationLat,
//       'location_lng': locationLng,
//       'privacy_setting': privacySetting,
//       'allow_comments': allowComments,
//       'allow_gifts': allowGifts,
//       'is_draft': isDraft,
//       'status': status?.value,
//       'views_count': viewsCount,
//       'likes_count': likesCount,
//       'comments_count': commentsCount,
//       'shares_count': sharesCount,
//       'is_liked': isLiked,
//       'is_viewed': isViewed,
//       'user': user?.toJson(),
//       'media': media.map((item) => item.toJson()).toList(),
//       'tagged_users':
//       taggedUsers.map((item) => item.toJson()).toList(),
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//       'title': title,
//       'media_url': mediaUrl,
//       'media_type': mediaType,
//       'target_url': targetUrl,
//       'clicks_count': clicksCount,
//     };
//   }
// }
//
// enum ReelItemType {
//   ad,
//   post,
// }
//
// extension ReelItemTypeX on ReelItemType {
//   String get value {
//     switch (this) {
//       case ReelItemType.ad:
//         return 'ad';
//       case ReelItemType.post:
//         return 'post';
//     }
//   }
//
//   static ReelItemType? fromJson(dynamic value) {
//     switch (value?.toString()) {
//       case 'ad':
//         return ReelItemType.ad;
//       case 'post':
//         return ReelItemType.post;
//       default:
//         return null;
//     }
//   }
// }
//
// enum ReelContentType {
//   ad,
//   video,
// }
//
// extension ReelContentTypeX on ReelContentType {
//   String get value {
//     switch (this) {
//       case ReelContentType.ad:
//         return 'ad';
//       case ReelContentType.video:
//         return 'video';
//     }
//   }
//
//   static ReelContentType? fromJson(dynamic value) {
//     switch (value?.toString()) {
//       case 'ad':
//         return ReelContentType.ad;
//       case 'video':
//         return ReelContentType.video;
//       default:
//         return null;
//     }
//   }
// }
//
// enum PostStatus {
//   active,
// }
//
// extension PostStatusX on PostStatus {
//   String get value {
//     switch (this) {
//       case PostStatus.active:
//         return 'active';
//     }
//   }
//
//   static PostStatus? fromJson(dynamic value) {
//     switch (value?.toString()) {
//       case 'active':
//         return PostStatus.active;
//       default:
//         return null;
//     }
//   }
// }
//
// class Media {
//   final int? id;
//   final String? mediaUrl;
//   final ReelContentType? mediaType;
//   final int? sortOrder;
//
//   const Media({
//     this.id,
//     this.mediaUrl,
//     this.mediaType,
//     this.sortOrder,
//   });
//
//   Media copyWith({
//     int? id,
//     String? mediaUrl,
//     ReelContentType? mediaType,
//     int? sortOrder,
//   }) {
//     return Media(
//       id: id ?? this.id,
//       mediaUrl: mediaUrl ?? this.mediaUrl,
//       mediaType: mediaType ?? this.mediaType,
//       sortOrder: sortOrder ?? this.sortOrder,
//     );
//   }
//
//   factory Media.fromRawJson(String source) {
//     return Media.fromJson(
//       jsonDecode(source) as Map<String, dynamic>,
//     );
//   }
//
//   String toRawJson() {
//     return jsonEncode(toJson());
//   }
//
//   factory Media.fromJson(Map<String, dynamic> json) {
//     return Media(
//       id: _parseInt(json['id']),
//       mediaUrl: _parseString(json['media_url']),
//       mediaType: ReelContentTypeX.fromJson(json['media_type']),
//       sortOrder: _parseInt(json['sort_order']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'media_url': mediaUrl,
//       'media_type': mediaType?.value,
//       'sort_order': sortOrder,
//     };
//   }
// }
//
// class User {
//   final int? id;
//   final String? avatar;
//   final String? name;
//   final String? username;
//   final bool? isFollow;
//
//   const User({
//     this.id,
//     this.avatar,
//     this.name,
//     this.username,
//     this.isFollow,
//   });
//
//   User copyWith({
//     int? id,
//     String? avatar,
//     String? name,
//     String? username,
//     bool? isFollow,
//   }) {
//     return User(
//       id: id ?? this.id,
//       avatar: avatar ?? this.avatar,
//       name: name ?? this.name,
//       username: username ?? this.username,
//       isFollow: isFollow ?? this.isFollow,
//     );
//   }
//
//   factory User.fromRawJson(String source) {
//     return User.fromJson(
//       jsonDecode(source) as Map<String, dynamic>,
//     );
//   }
//
//   String toRawJson() {
//     return jsonEncode(toJson());
//   }
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: _parseInt(json['id']),
//       avatar: _parseString(json['avatar']),
//       name: _parseString(json['name']),
//       username: _parseString(json['username']),
//       isFollow: _parseBool(json['is_follow']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'avatar': avatar,
//       'name': name,
//       'username': username,
//       'is_follow': isFollow,
//     };
//   }
// }
//
// // -----------------------------------------------------------------------------
// // SAFE PARSERS
// // -----------------------------------------------------------------------------
//
// String? _parseString(dynamic value) {
//   if (value == null) return null;
//   return value.toString();
// }
//
// int? _parseInt(dynamic value) {
//   if (value == null) return null;
//
//   if (value is int) {
//     return value;
//   }
//
//   if (value is num) {
//     return value.toInt();
//   }
//
//   return int.tryParse(value.toString());
// }
//
// double? _parseDouble(dynamic value) {
//   if (value == null) return null;
//
//   if (value is double) {
//     return value;
//   }
//
//   if (value is num) {
//     return value.toDouble();
//   }
//
//   return double.tryParse(value.toString());
// }
//
// bool? _parseBool(dynamic value) {
//   if (value == null) return null;
//
//   if (value is bool) {
//     return value;
//   }
//
//   if (value is num) {
//     if (value == 1) return true;
//     if (value == 0) return false;
//   }
//
//   final normalized = value.toString().toLowerCase().trim();
//
//   if (normalized == 'true' || normalized == '1') {
//     return true;
//   }
//
//   if (normalized == 'false' || normalized == '0') {
//     return false;
//   }
//
//   return null;
// }
//
// DateTime? _parseDateTime(dynamic value) {
//   if (value == null) return null;
//
//   final stringValue = value.toString().trim();
//
//   if (stringValue.isEmpty) return null;
//
//   return DateTime.tryParse(stringValue);
// }

import 'dart:convert';

class GetReelsListModel {
  final bool? success;
  final String? message;
  final ReelsData? data;
  final int? code;

  GetReelsListModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory GetReelsListModel.fromRawJson(String str) =>
      GetReelsListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReelsListModel.fromJson(Map<String, dynamic> json) =>
      GetReelsListModel(
        success: _toBoolSafe(json["success"]),
        message: json["message"]?.toString(),
        data: json["data"] == null ? null : ReelsData.fromJson(json["data"]),
        code: _toIntSafe(json["code"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class ReelsData {
  final PostsPagination? posts;

  ReelsData({this.posts});

  factory ReelsData.fromRawJson(String str) =>
      ReelsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReelsData.fromJson(Map<String, dynamic> json) => ReelsData(
    posts: json["posts"] == null
        ? null
        : PostsPagination.fromJson(json["posts"]),
  );

  Map<String, dynamic> toJson() => {
    "posts": posts?.toJson(),
  };
}

class PostsPagination {
  final int? currentPage;
  final List<ReelItem>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PaginationLink>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  PostsPagination({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PostsPagination.fromRawJson(String str) =>
      PostsPagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostsPagination.fromJson(Map<String, dynamic> json) =>
      PostsPagination(
        currentPage: _toIntSafe(json["current_page"]),
        data: json["data"] == null
            ? []
            : List<ReelItem>.from(
            json["data"]!.map((x) => ReelItem.fromJson(x))),
        firstPageUrl: json["first_page_url"]?.toString(),
        from: _toIntSafe(json["from"]),
        lastPage: _toIntSafe(json["last_page"]),
        lastPageUrl: json["last_page_url"]?.toString(),
        links: json["links"] == null
            ? []
            : List<PaginationLink>.from(
            json["links"]!.map((x) => PaginationLink.fromJson(x))),
        nextPageUrl: json["next_page_url"]?.toString(),
        path: json["path"]?.toString(),
        perPage: _toIntSafe(json["per_page"]),
        prevPageUrl: json["prev_page_url"]?.toString(),
        to: _toIntSafe(json["to"]),
        total: _toIntSafe(json["total"]),
      );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class ReelItem {
  final int? id;
  final String? itemType; // "post" | "ad"
  final String? type; // "video" | "ad"
  final String? caption;
  final String? title; // Ad title
  final String? mediaUrl; // Direct Ad media URL
  final String? mediaType; // "video" | "image"
  final String? targetUrl; // Ad destination URL
  final int? clicksCount;
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
  final ReelUser? user;
  final List<Media>? media;
  final List<ReelUser>? taggedUsers;
  final ReelSound? sound;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReelItem({
    this.id,
    this.itemType,
    this.type,
    this.caption,
    this.title,
    this.mediaUrl,
    this.mediaType,
    this.targetUrl,
    this.clicksCount,
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

  bool get isAd => itemType == "ad" || type == "ad";
  bool get isPost => itemType == "post";

  String? get resolvedMediaUrl {
    if (isAd && mediaUrl != null && mediaUrl!.isNotEmpty) {
      return mediaUrl;
    }
    if (media != null && media!.isNotEmpty) {
      return media!.first.mediaUrl;
    }
    return null;
  }

  factory ReelItem.fromRawJson(String str) => ReelItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReelItem.fromJson(Map<String, dynamic> json) => ReelItem(
    id: _toIntSafe(json["id"]),
    itemType: json["item_type"]?.toString(),
    type: json["type"]?.toString(),
    caption: json["caption"]?.toString(),
    title: json["title"]?.toString(),
    mediaUrl: json["media_url"]?.toString(),
    mediaType: json["media_type"]?.toString(),
    targetUrl: json["target_url"]?.toString(),
    clicksCount: _toIntSafe(json["clicks_count"]),
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
    user: json["user"] == null ? null : ReelUser.fromJson(json["user"]),
    media: json["media"] == null
        ? []
        : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    taggedUsers: json["tagged_users"] == null
        ? []
        : List<ReelUser>.from(
        json["tagged_users"]!.map((x) => ReelUser.fromJson(x))),
    sound: json["sound"] == null ? null : ReelSound.fromJson(json["sound"]),
    createdAt: _toDateSafe(json["created_at"]),
    updatedAt: _toDateSafe(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_type": itemType,
    "type": type,
    "caption": caption,
    "title": title,
    "media_url": mediaUrl,
    "media_type": mediaType,
    "target_url": targetUrl,
    "clicks_count": clicksCount,
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

class ReelUser {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final bool? isFollow;

  ReelUser({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.isFollow,
  });

  factory ReelUser.fromRawJson(String str) => ReelUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReelUser.fromJson(Map<String, dynamic> json) => ReelUser(
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

class ReelSound {
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

  ReelSound({
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

  factory ReelSound.fromRawJson(String str) => ReelSound.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReelSound.fromJson(Map<String, dynamic> json) => ReelSound(
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

class PaginationLink {
  final String? url;
  final String? label;
  final int? page;
  final bool? active;

  PaginationLink({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory PaginationLink.fromRawJson(String str) => PaginationLink.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginationLink.fromJson(Map<String, dynamic> json) => PaginationLink(
    url: json["url"]?.toString(),
    label: json["label"]?.toString(),
    page: _toIntSafe(json["page"]),
    active: _toBoolSafe(json["active"]),
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "page": page,
    "active": active,
  };
}

// ==========================================
// Safe Production Parser Helpers
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