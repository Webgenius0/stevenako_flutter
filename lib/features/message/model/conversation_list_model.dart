import 'dart:convert';

class ConversationListModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  ConversationListModel({this.success, this.message, this.data, this.code});

  ConversationListModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) => ConversationListModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    code: code ?? this.code,
  );

  factory ConversationListModel.fromRawJson(String str) =>
      ConversationListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationListModel.fromJson(Map<String, dynamic> json) =>
      ConversationListModel(
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
  List<Conversation>? conversations;

  Data({this.conversations});

  Data copyWith({List<Conversation>? conversations}) =>
      Data(conversations: conversations ?? this.conversations);

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    conversations: json["conversations"] == null
        ? []
        : List<Conversation>.from(
            json["conversations"]!.map((x) => Conversation.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "conversations": conversations == null
        ? []
        : List<dynamic>.from(conversations!.map((x) => x.toJson())),
  };
}

class Conversation {
  int? id;
  OtherUser? otherUser;
  LatestMessage? latestMessage;
  DateTime? createdAt;
  DateTime? updatedAt;

  Conversation({
    this.id,
    this.otherUser,
    this.latestMessage,
    this.createdAt,
    this.updatedAt,
  });

  Conversation copyWith({
    int? id,
    OtherUser? otherUser,
    LatestMessage? latestMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Conversation(
    id: id ?? this.id,
    otherUser: otherUser ?? this.otherUser,
    latestMessage: latestMessage ?? this.latestMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Conversation.fromRawJson(String str) =>
      Conversation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json["id"],
    otherUser: json["other_user"] == null
        ? null
        : OtherUser.fromJson(json["other_user"]),
    latestMessage: json["latest_message"] == null
        ? null
        : LatestMessage.fromJson(json["latest_message"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "other_user": otherUser?.toJson(),
    "latest_message": latestMessage?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class LatestMessage {
  int? id;
  String? message;
  String? type;
  dynamic mediaUrl;
  int? senderId;
  bool? isRead;
  DateTime? createdAt;

  LatestMessage({
    this.id,
    this.message,
    this.type,
    this.mediaUrl,
    this.senderId,
    this.isRead,
    this.createdAt,
  });

  LatestMessage copyWith({
    int? id,
    String? message,
    String? type,
    dynamic mediaUrl,
    int? senderId,
    bool? isRead,
    DateTime? createdAt,
  }) => LatestMessage(
    id: id ?? this.id,
    message: message ?? this.message,
    type: type ?? this.type,
    mediaUrl: mediaUrl ?? this.mediaUrl,
    senderId: senderId ?? this.senderId,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );

  factory LatestMessage.fromRawJson(String str) =>
      LatestMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
    id: json["id"],
    message: json["message"],
    type: json["type"],
    mediaUrl: json["media_url"],
    senderId: json["sender_id"],
    isRead: json["is_read"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "type": type,
    "media_url": mediaUrl,
    "sender_id": senderId,
    "is_read": isRead,
    "created_at": createdAt?.toIso8601String(),
  };
}

class OtherUser {
  int? id;
  String? avatar;
  String? name;
  String? username;
  bool? isFollow;

  OtherUser({this.id, this.avatar, this.name, this.username, this.isFollow});

  OtherUser copyWith({
    int? id,
    String? avatar,
    String? name,
    String? username,
    bool? isFollow,
  }) => OtherUser(
    id: id ?? this.id,
    avatar: avatar ?? this.avatar,
    name: name ?? this.name,
    username: username ?? this.username,
    isFollow: isFollow ?? this.isFollow,
  );

  factory OtherUser.fromRawJson(String str) =>
      OtherUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
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
