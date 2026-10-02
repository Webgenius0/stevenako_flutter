import 'dart:convert';

// ─────────────────────────────────────────────────────────────────────────────
// Response: POST /user/login/google
// {
//   "success": true,
//   "message": "User logged in successfully.",
//   "data": {
//     "user": { ... },
//     "token": "eyJ..."
//   }
// }
// ─────────────────────────────────────────────────────────────────────────────

class GoogleSignInModel {
  final bool? success;
  final String? message;
  final GoogleSignInData? data;

  const GoogleSignInModel({
    this.success,
    this.message,
    this.data,
  });

  factory GoogleSignInModel.fromRawJson(String str) =>
      GoogleSignInModel.fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(toJson());

  factory GoogleSignInModel.fromJson(Map<String, dynamic> json) {
    return GoogleSignInModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? GoogleSignInData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────

class GoogleSignInData {
  final GoogleSignInUser? user;
  final String? token;

  const GoogleSignInData({this.user, this.token});

  factory GoogleSignInData.fromJson(Map<String, dynamic> json) {
    return GoogleSignInData(
      user: json['user'] is Map<String, dynamic>
          ? GoogleSignInUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'token': token,
      };
}

// ─────────────────────────────────────────────────────────────────────────────

class GoogleSignInUser {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final String? email;
  final String? dateOfBirth;
  final String? bio;
  final String? gender;
  final String? role;
  final String? status;
  final bool? termsAndConditions;
  final int? followersCount;
  final int? followingCount;
  final int? likesCount;
  final bool? isFriends;
  final bool? isFollow;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GoogleSignInUser({
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
    this.isFriends,
    this.isFollow,
    this.createdAt,
    this.updatedAt,
  });

  factory GoogleSignInUser.fromJson(Map<String, dynamic> json) {
    return GoogleSignInUser(
      id: _parseInt(json['id']),
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['date_of_birth']?.toString(),
      bio: json['bio']?.toString(),
      gender: json['gender']?.toString(),
      role: json['role'] as String?,
      status: json['status'] as String?,
      termsAndConditions: _parseBool(json['terms_and_conditions']),
      followersCount: _parseInt(json['followers_count']),
      followingCount: _parseInt(json['following_count']),
      likesCount: _parseInt(json['likes_count']),
      isFriends: _parseBool(json['is_friends']),
      isFollow: _parseBool(json['is_follow']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'name': name,
        'username': username,
        'email': email,
        'date_of_birth': dateOfBirth,
        'bio': bio,
        'gender': gender,
        'role': role,
        'status': status,
        'terms_and_conditions': termsAndConditions,
        'followers_count': followersCount,
        'following_count': followingCount,
        'likes_count': likesCount,
        'is_friends': isFriends,
        'is_follow': isFollow,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final v = value.toLowerCase().trim();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;
  }
  return null;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  final s = value.toString().trim();
  if (s.isEmpty) return null;
  return DateTime.tryParse(s);
}
