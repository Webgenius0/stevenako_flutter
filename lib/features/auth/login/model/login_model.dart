import 'dart:convert';

class PostLoginModel {
  final bool? success;
  final String? message;
  final LoginData? data;
  final int? code;

  const PostLoginModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  PostLoginModel copyWith({
    bool? success,
    String? message,
    LoginData? data,
    int? code,
  }) {
    return PostLoginModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  factory PostLoginModel.fromRawJson(String str) {
    return PostLoginModel.fromJson(jsonDecode(str));
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory PostLoginModel.fromJson(Map<String, dynamic> json) {
    return PostLoginModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      code: json['code'] as int?,
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

class LoginData {
  final String? token;
  final User? user;

  const LoginData({
    this.token,
    this.user,
  });

  LoginData copyWith({
    String? token,
    User? user,
  }) {
    return LoginData(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  factory LoginData.fromRawJson(String str) {
    return LoginData.fromJson(jsonDecode(str));
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] as String?,
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user?.toJson(),
    };
  }
}

class User {
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
  final bool? isFollow;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
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
    String? dateOfBirth,
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
  }) {
    return User(
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
      termsAndConditions:
      termsAndConditions ?? this.termsAndConditions,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      likesCount: likesCount ?? this.likesCount,
      isFollow: isFollow ?? this.isFollow,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory User.fromRawJson(String str) {
    return User.fromJson(jsonDecode(str));
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      termsAndConditions: _parseBool(
        json['terms_and_conditions'],
      ),
      followersCount: _parseInt(
        json['followers_count'],
      ),
      followingCount: _parseInt(
        json['following_count'],
      ),
      likesCount: _parseInt(
        json['likes_count'],
      ),
      isFollow: _parseBool(
        json['is_follow'],
      ),
      createdAt: _parseDateTime(
        json['created_at'],
      ),
      updatedAt: _parseDateTime(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'is_follow': isFollow,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Safely converts API values to int.
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

/// Safely converts API values to bool.
bool? _parseBool(dynamic value) {
  if (value == null) return null;

  if (value is bool) {
    return value;
  }

  if (value is int) {
    return value == 1;
  }

  if (value is String) {
    final normalized = value.toLowerCase().trim();

    if (normalized == 'true' || normalized == '1') {
      return true;
    }

    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }

  return null;
}

/// Safely parses API date values.
DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;

  final dateString = value.toString().trim();

  if (dateString.isEmpty) {
    return null;
  }

  return DateTime.tryParse(dateString);
}