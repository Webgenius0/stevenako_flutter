import 'dart:convert';

class MyBlockedUsersModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  MyBlockedUsersModel({this.success, this.message, this.data, this.code});

  MyBlockedUsersModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) => MyBlockedUsersModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    code: code ?? this.code,
  );

  factory MyBlockedUsersModel.fromRawJson(String str) =>
      MyBlockedUsersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyBlockedUsersModel.fromJson(Map<String, dynamic> json) =>
      MyBlockedUsersModel(
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
  List<User>? users;

  Data({this.users});

  Data copyWith({List<User>? users}) => Data(users: users ?? this.users);

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    users: json["users"] == null
        ? []
        : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": users == null
        ? []
        : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class User {
  int? id;
  String? avatar;
  String? name;
  String? username;
  String? email;
  dynamic dateOfBirth;
  String? bio;
  String? gender;
  String? role;
  String? status;
  bool? termsAndConditions;
  int? followersCount;
  int? followingCount;
  int? likesCount;
  bool? isFollow;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.email,
    this.dateOfBirth,
    this.bio,
    this.gender,
    this.role,
    this.status,
    this.termsAndConditions,
    this.followersCount,
    this.followingCount,
    this.likesCount,
    this.isFollow,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    int? id,
    String? avatar,
    String? name,
    String? username,
    String? email,
    dynamic dateOfBirth,
    String? bio,
    String? gender,
    String? role,
    String? status,
    bool? termsAndConditions,
    int? followersCount,
    int? followingCount,
    int? likesCount,
    bool? isFollow,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    avatar: avatar ?? this.avatar,
    name: name ?? this.name,
    username: username ?? this.username,
    email: email ?? this.email,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    bio: bio ?? this.bio,
    gender: gender ?? this.gender,
    role: role ?? this.role,
    status: status ?? this.status,
    termsAndConditions: termsAndConditions ?? this.termsAndConditions,
    followersCount: followersCount ?? this.followersCount,
    followingCount: followingCount ?? this.followingCount,
    likesCount: likesCount ?? this.likesCount,
    isFollow: isFollow ?? this.isFollow,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    avatar: json["avatar"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    dateOfBirth: json["date_of_birth"],
    bio: json["bio"],
    gender: json["gender"],
    role: json["role"],
    status: json["status"],
    termsAndConditions: json["terms_and_conditions"],
    followersCount: json["followers_count"],
    followingCount: json["following_count"],
    likesCount: json["likes_count"],
    isFollow: json["is_follow"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "username": username,
    "email": email,
    "date_of_birth": dateOfBirth,
    "bio": bio,
    "gender": gender,
    "role": role,
    "status": status,
    "terms_and_conditions": termsAndConditions,
    "followers_count": followersCount,
    "following_count": followingCount,
    "likes_count": likesCount,
    "is_follow": isFollow,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
