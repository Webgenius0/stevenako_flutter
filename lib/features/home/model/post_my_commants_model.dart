import 'dart:convert';

class PostSentMyCommantsModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  PostSentMyCommantsModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  PostSentMyCommantsModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) {
    return PostSentMyCommantsModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  factory PostSentMyCommantsModel.fromRawJson(String str) {
    return PostSentMyCommantsModel.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory PostSentMyCommantsModel.fromJson(Map<String, dynamic> json) {
    return PostSentMyCommantsModel(
      success: json["success"] as bool?,
      message: json["message"]?.toString(),
      data: json["data"] is Map<String, dynamic>
          ? Data.fromJson(json["data"])
          : null,
      code: json["code"] is int
          ? json["code"]
          : int.tryParse(json["code"]?.toString() ?? ''),
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
  Comment? comment;
  int? commentsCount;

  Data({
    this.comment,
    this.commentsCount,
  });

  Data copyWith({
    Comment? comment,
    int? commentsCount,
  }) {
    return Data(
      comment: comment ?? this.comment,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }

  factory Data.fromRawJson(String str) {
    return Data.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      comment: json["comment"] is Map<String, dynamic>
          ? Comment.fromJson(json["comment"])
          : null,
      commentsCount: json["comments_count"] is int
          ? json["comments_count"]
          : int.tryParse(
        json["comments_count"]?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "comment": comment?.toJson(),
      "comments_count": commentsCount,
    };
  }
}

class Comment {
  int? id;
  String? postId;
  String? content;
  int? likesCount;
  bool? isLiked;
  int? parentId;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;

  Comment({
    this.id,
    this.postId,
    this.content,
    this.likesCount,
    this.isLiked,
    this.parentId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  Comment copyWith({
    int? id,
    String? postId,
    String? content,
    int? likesCount,
    bool? isLiked,
    int? parentId,
    User? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      parentId: parentId ?? this.parentId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Comment.fromRawJson(String str) {
    return Comment.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(json["id"]?.toString() ?? ''),

      // Supports both String and int post_id
      postId: json["post_id"]?.toString(),

      content: json["content"]?.toString(),

      likesCount: json["likes_count"] is int
          ? json["likes_count"]
          : int.tryParse(
        json["likes_count"]?.toString() ?? '',
      ),

      isLiked: json["is_liked"] is bool
          ? json["is_liked"]
          : json["is_liked"]?.toString().toLowerCase() == "true",

      parentId: json["parent_id"] is int
          ? json["parent_id"]
          : int.tryParse(
        json["parent_id"]?.toString() ?? '',
      ),

      user: json["user"] is Map<String, dynamic>
          ? User.fromJson(json["user"])
          : null,

      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(
        json["created_at"].toString(),
      ),

      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.tryParse(
        json["updated_at"].toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "post_id": postId,
      "content": content,
      "likes_count": likesCount,
      "is_liked": isLiked,
      "parent_id": parentId,
      "user": user?.toJson(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
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

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(
        json["id"]?.toString() ?? '',
      ),

      avatar: json["avatar"]?.toString(),

      name: json["name"]?.toString(),

      username: json["username"]?.toString(),

      isFollow: json["is_follow"] is bool
          ? json["is_follow"]
          : json["is_follow"]?.toString().toLowerCase() == "true",
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