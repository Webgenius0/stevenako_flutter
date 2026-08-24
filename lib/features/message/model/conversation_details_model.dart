import 'dart:convert';

class ConversationDetailsModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  ConversationDetailsModel({this.success, this.message, this.data, this.code});

  ConversationDetailsModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) => ConversationDetailsModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    code: code ?? this.code,
  );

  factory ConversationDetailsModel.fromRawJson(String str) =>
      ConversationDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationDetailsModel.fromJson(Map<String, dynamic> json) =>
      ConversationDetailsModel(
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
  List<Message>? messages;

  Data({this.messages});

  Data copyWith({List<Message>? messages}) =>
      Data(messages: messages ?? this.messages);

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    messages: json["messages"] == null
        ? []
        : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messages": messages == null
        ? []
        : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  int? id;
  int? conversationId;
  int? senderId;
  String? message;
  String? type;
  dynamic mediaUrl;
  bool? isRead;
  DateTime? createdAt;
  DateTime? updatedAt;
  Sender? sender;

  Message({
    this.id,
    this.conversationId,
    this.senderId,
    this.message,
    this.type,
    this.mediaUrl,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.sender,
  });

  Message copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? message,
    String? type,
    dynamic mediaUrl,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
    Sender? sender,
  }) => Message(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    senderId: senderId ?? this.senderId,
    message: message ?? this.message,
    type: type ?? this.type,
    mediaUrl: mediaUrl ?? this.mediaUrl,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sender: sender ?? this.sender,
  );

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    conversationId: json["conversation_id"],
    senderId: json["sender_id"],
    message: json["message"],
    type: json["type"],
    mediaUrl: json["media_url"],
    isRead: json["is_read"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "conversation_id": conversationId,
    "sender_id": senderId,
    "message": message,
    "type": type,
    "media_url": mediaUrl,
    "is_read": isRead,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "sender": sender?.toJson(),
  };
}

class Sender {
  int? id;
  String? name;
  String? avatar;
  String? username;

  Sender({this.id, this.name, this.avatar, this.username});

  Sender copyWith({int? id, String? name, String? avatar, String? username}) =>
      Sender(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        username: username ?? this.username,
      );

  factory Sender.fromRawJson(String str) => Sender.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "username": username,
  };
}
