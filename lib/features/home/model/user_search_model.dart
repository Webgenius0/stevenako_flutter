import 'dart:convert';

// ─────────────────────────────────────────────────────────────────────────────
// GET /user/search?query=ferdaus
// {
//   "success": true,
//   "message": "Users searched successfully.",
//   "data": {
//     "users": [
//       { "id": 25, "avatar": "...", "name": "...", "username": "...", "is_follow": false }
//     ]
//   },
//   "code": 200
// }
// ─────────────────────────────────────────────────────────────────────────────

class UserSearchModel {
  final bool? success;
  final String? message;
  final int? code;
  final UserSearchData? data;

  const UserSearchModel({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory UserSearchModel.fromRawJson(String str) =>
      UserSearchModel.fromJson(jsonDecode(str));

  factory UserSearchModel.fromJson(Map<String, dynamic> json) {
    return UserSearchModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      data: json['data'] is Map<String, dynamic>
          ? UserSearchData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'code': code,
        'data': data?.toJson(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────

class UserSearchData {
  final List<SearchedUser> users;

  const UserSearchData({this.users = const []});

  factory UserSearchData.fromJson(Map<String, dynamic> json) {
    final rawList = json['users'];
    final users = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map(SearchedUser.fromJson)
            .toList()
        : <SearchedUser>[];
    return UserSearchData(users: users);
  }

  Map<String, dynamic> toJson() => {
        'users': users.map((u) => u.toJson()).toList(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────

class SearchedUser {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final bool? isFollow;

  const SearchedUser({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.isFollow,
  });

  factory SearchedUser.fromJson(Map<String, dynamic> json) {
    return SearchedUser(
      id: _parseInt(json['id']),
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      isFollow: json['is_follow'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'name': name,
        'username': username,
        'is_follow': isFollow,
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
