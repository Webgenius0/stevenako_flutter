import 'dart:convert';

class GetTapPeopleModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  GetTapPeopleModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetTapPeopleModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) =>
      GetTapPeopleModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory GetTapPeopleModel.fromRawJson(String str) => GetTapPeopleModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTapPeopleModel.fromJson(Map<String, dynamic> json) => GetTapPeopleModel(
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

  Data({
    this.users,
  });

  Data copyWith({
    List<User>? users,
  }) =>
      Data(
        users: users ?? this.users,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
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
