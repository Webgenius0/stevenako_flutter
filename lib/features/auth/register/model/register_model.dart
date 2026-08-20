import 'dart:convert';

class RegisterModel {
  bool? success;
  String? message;
  RegisterData? data;
  int? code;

  RegisterModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  RegisterModel copyWith({
    bool? success,
    String? message,
    RegisterData? data,
    int? code,
  }) =>
      RegisterModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory RegisterModel.fromRawJson(String str) =>
      RegisterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : RegisterData.fromJson(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}

class RegisterData {
  UserModel? user;

  RegisterData({
    this.user,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class UserModel {
  int? id;
  String? avatar;
  String? name;
  String? username;
  String? email;
  String? dateOfBirth;
  String? bio;
  String? gender;
  String? role;
  String? status;
  bool? termsAndConditions;
  int? followersCount;
  int? followingCount;
  int? likesCount;
  bool? isFollow;
  String? createdAt;
  String? updatedAt;

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
