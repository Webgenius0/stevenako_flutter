import 'dart:convert';

class PostStartConversationModel {
  final bool? success;
  final String? message;
  final ConversationData? data;
  final int? code;

  PostStartConversationModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  PostStartConversationModel copyWith({
    bool? success,
    String? message,
    ConversationData? data,
    int? code,
  }) =>
      PostStartConversationModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory PostStartConversationModel.fromRawJson(String str) =>
      PostStartConversationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostStartConversationModel.fromJson(Map<String, dynamic> json) =>
      PostStartConversationModel(
        success: _toBoolSafe(json["success"]),
        message: json["message"]?.toString(),
        data: json["data"] == null
            ? null
            : ConversationData.fromJson(json["data"]),
        code: _toIntSafe(json["code"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class ConversationData {
  final Conversation? conversation;

  ConversationData({
    this.conversation,
  });

  ConversationData copyWith({
    Conversation? conversation,
  }) =>
      ConversationData(
        conversation: conversation ?? this.conversation,
      );

  factory ConversationData.fromRawJson(String str) =>
      ConversationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationData.fromJson(Map<String, dynamic> json) =>
      ConversationData(
        conversation: json["conversation"] == null
            ? null
            : Conversation.fromJson(json["conversation"]),
      );

  Map<String, dynamic> toJson() => {
    "conversation": conversation?.toJson(),
  };
}

class Conversation {
  final int? id;
  final OtherUser? otherUser;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Conversation({
    this.id,
    this.otherUser,
    this.createdAt,
    this.updatedAt,
  });

  Conversation copyWith({
    int? id,
    OtherUser? otherUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Conversation(
        id: id ?? this.id,
        otherUser: otherUser ?? this.otherUser,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Conversation.fromRawJson(String str) =>
      Conversation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: _toIntSafe(json["id"]),
    otherUser: json["other_user"] == null
        ? null
        : OtherUser.fromJson(json["other_user"]),
    createdAt: _toDateSafe(json["created_at"]),
    updatedAt: _toDateSafe(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "other_user": otherUser?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class OtherUser {
  final int? id;
  final String? avatar;
  final String? name;
  final String? username;
  final bool? isFollow;

  OtherUser({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.isFollow,
  });

  OtherUser copyWith({
    int? id,
    String? avatar,
    String? name,
    String? username,
    bool? isFollow,
  }) =>
      OtherUser(
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
    id: _toIntSafe(json["id"]),
    avatar: json["avatar"]?.toString(),
    name: json["name"]?.toString(),
    username: json["username"]?.toString(),
    isFollow: _toBoolSafe(json["is_follow"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "username": username,
    "is_follow": isFollow,
  };
}

// ==========================================
// Safe Helper Parsers
// ==========================================

int? _toIntSafe(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool? _toBoolSafe(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

DateTime? _toDateSafe(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}