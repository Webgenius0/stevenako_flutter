import 'dart:convert';

class GetuserModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  GetuserModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetuserModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) =>
      GetuserModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory GetuserModel.fromRawJson(String str) => GetuserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetuserModel.fromJson(Map<String, dynamic> json) => GetuserModel(
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
  List<Sound>? sounds;

  Data({
    this.sounds,
  });

  Data copyWith({
    List<Sound>? sounds,
  }) =>
      Data(
        sounds: sounds ?? this.sounds,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sounds: json["sounds"] == null ? [] : List<Sound>.from(json["sounds"]!.map((x) => Sound.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sounds": sounds == null ? [] : List<dynamic>.from(sounds!.map((x) => x.toJson())),
  };
}

class Sound {
  int? id;
  String? title;
  String? artist;
  String? audioUrl;
  String? thumbnailUrl;
  int? duration;
  int? postsCount;
  bool? isSaved;
  Creator? creator;
  DateTime? createdAt;
  DateTime? updatedAt;

  Sound({
    this.id,
    this.title,
    this.artist,
    this.audioUrl,
    this.thumbnailUrl,
    this.duration,
    this.postsCount,
    this.isSaved,
    this.creator,
    this.createdAt,
    this.updatedAt,
  });

  Sound copyWith({
    int? id,
    String? title,
    String? artist,
    String? audioUrl,
    String? thumbnailUrl,
    int? duration,
    int? postsCount,
    bool? isSaved,
    Creator? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Sound(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        audioUrl: audioUrl ?? this.audioUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        duration: duration ?? this.duration,
        postsCount: postsCount ?? this.postsCount,
        isSaved: isSaved ?? this.isSaved,
        creator: creator ?? this.creator,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Sound.fromRawJson(String str) => Sound.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sound.fromJson(Map<String, dynamic> json) => Sound(
    id: json["id"],
    title: json["title"],
    artist: json["artist"],
    audioUrl: json["audio_url"],
    thumbnailUrl: json["thumbnail_url"],
    duration: json["duration"],
    postsCount: json["posts_count"],
    isSaved: json["is_saved"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    "creator": creator?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Creator {
  int? id;
  String? avatar;
  String? name;
  String? username;
  bool? isFollow;

  Creator({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.isFollow,
  });

  Creator copyWith({
    int? id,
    String? avatar,
    String? name,
    String? username,
    bool? isFollow,
  }) =>
      Creator(
        id: id ?? this.id,
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        username: username ?? this.username,
        isFollow: isFollow ?? this.isFollow,
      );

  factory Creator.fromRawJson(String str) => Creator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
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
