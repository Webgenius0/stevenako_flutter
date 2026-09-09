import 'dart:convert';

class GetAllPhotoModel {
  final bool? success;
  final String? message;
  final PhotoFeedData? data;
  final int? code;

  GetAllPhotoModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory GetAllPhotoModel.fromRawJson(String str) =>
      GetAllPhotoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllPhotoModel.fromJson(Map<String, dynamic> json) =>
      GetAllPhotoModel(
        success: _toBoolSafe(json["success"]),
        message: json["message"]?.toString(),
        data: json["data"] == null
            ? null
            : PhotoFeedData.fromJson(json["data"]),
        code: _toIntSafe(json["code"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class PhotoFeedData {
  final PostsPagination? posts;

  PhotoFeedData({this.posts});

  factory PhotoFeedData.fromRawJson(String str) =>
      PhotoFeedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhotoFeedData.fromJson(Map<String, dynamic> json) => PhotoFeedData(
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
  final List<PhotoItem>? data;
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
            : List<PhotoItem>.from(
            json["data"]!.map((x) => PhotoItem.fromJson(x))),
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

class PhotoItem {
  final int? id;
  final String? itemType; // "post" | "ad"
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
  final dynamic sound;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? mediaUrl;
  final String? mediaType;
  final String? targetUrl;
  final int? clicksCount;

  PhotoItem({
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
    this.title,
    this.mediaUrl,
    this.mediaType,
    this.targetUrl,
    this.clicksCount,
  });

  bool get isAd => itemType == "ad";
  bool get isPost => itemType == "post";

  String? get resolvedImageUrl {
    if (isAd && mediaUrl != null && mediaUrl!.isNotEmpty) {
      return mediaUrl;
    }
    if (media != null && media!.isNotEmpty) {
      return media!.first.mediaUrl;
    }
    return null;
  }

  factory PhotoItem.fromRawJson(String str) => PhotoItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhotoItem.fromJson(Map<String, dynamic> json) => PhotoItem(
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
        : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    taggedUsers: json["tagged_users"] == null
        ? []
        : List<dynamic>.from(json["tagged_users"]!.map((x) => x)),
    sound: json["sound"],
    createdAt: _toDateSafe(json["created_at"]),
    updatedAt: _toDateSafe(json["updated_at"]),
    title: json["title"]?.toString(),
    mediaUrl: json["media_url"]?.toString(),
    mediaType: json["media_type"]?.toString(),
    targetUrl: json["target_url"]?.toString(),
    clicksCount: _toIntSafe(json["clicks_count"]),
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
    "sound": sound,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "title": title,
    "media_url": mediaUrl,
    "media_type": mediaType,
    "target_url": targetUrl,
    "clicks_count": clicksCount,
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

  factory PaginationLink.fromRawJson(String str) =>
      PaginationLink.fromJson(json.decode(str));

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
// Safe Parsing Helpers
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