import 'dart:convert';

class MsgNotificationModel {
  bool? success;
  String? message;
  MsgNotificationModelData? data;
  int? code;

  MsgNotificationModel({this.success, this.message, this.data, this.code});

  MsgNotificationModel copyWith({
    bool? success,
    String? message,
    MsgNotificationModelData? data,
    int? code,
  }) => MsgNotificationModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    code: code ?? this.code,
  );

  factory MsgNotificationModel.fromRawJson(String str) =>
      MsgNotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MsgNotificationModel.fromJson(Map<String, dynamic> json) =>
      MsgNotificationModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : MsgNotificationModelData.fromJson(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class MsgNotificationModelData {
  List<Notification>? notifications;

  MsgNotificationModelData({this.notifications});

  MsgNotificationModelData copyWith({List<Notification>? notifications}) =>
      MsgNotificationModelData(
        notifications: notifications ?? this.notifications,
      );

  factory MsgNotificationModelData.fromRawJson(String str) =>
      MsgNotificationModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MsgNotificationModelData.fromJson(Map<String, dynamic> json) =>
      MsgNotificationModelData(
        notifications: json["notifications"] == null
            ? []
            : List<Notification>.from(
                json["notifications"]!.map((x) => Notification.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null
        ? []
        : List<dynamic>.from(notifications!.map((x) => x.toJson())),
  };
}

class Notification {
  String? id;
  String? type;
  NotifiableType? notifiableType;
  int? notifiableId;
  NotificationData? data;
  DateTime? readAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  Notification({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  Notification copyWith({
    String? id,
    String? type,
    NotifiableType? notifiableType,
    int? notifiableId,
    NotificationData? data,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Notification(
    id: id ?? this.id,
    type: type ?? this.type,
    notifiableType: notifiableType ?? this.notifiableType,
    notifiableId: notifiableId ?? this.notifiableId,
    data: data ?? this.data,
    readAt: readAt ?? this.readAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Notification.fromRawJson(String str) =>
      Notification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    type: json["type"],
    notifiableType: notifiableTypeValues.map[json["notifiable_type"]],
    notifiableId: json["notifiable_id"],
    data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
    readAt: json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "notifiable_type": notifiableTypeValues.reverse[notifiableType],
    "notifiable_id": notifiableId,
    "data": data?.toJson(),
    "read_at": readAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class NotificationData {
  String? title;
  String? message;
  String? type;
  int? senderId;
  String? senderUsername;
  int? postId;
  int? commentId;
  int? amount;
  int? withdrawalRequestId;

  NotificationData({
    this.title,
    this.message,
    this.type,
    this.senderId,
    this.senderUsername,
    this.postId,
    this.commentId,
    this.amount,
    this.withdrawalRequestId,
  });

  NotificationData copyWith({
    String? title,
    String? message,
    String? type,
    int? senderId,
    String? senderUsername,
    int? postId,
    int? commentId,
    int? amount,
    int? withdrawalRequestId,
  }) => NotificationData(
    title: title ?? this.title,
    message: message ?? this.message,
    type: type ?? this.type,
    senderId: senderId ?? this.senderId,
    senderUsername: senderUsername ?? this.senderUsername,
    postId: postId ?? this.postId,
    commentId: commentId ?? this.commentId,
    amount: amount ?? this.amount,
    withdrawalRequestId: withdrawalRequestId ?? this.withdrawalRequestId,
  );

  factory NotificationData.fromRawJson(String str) =>
      NotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        title: json["title"],
        message: json["message"],
        type: json["type"],
        senderId: json["sender_id"],
        senderUsername: json["sender_username"],
        postId: json["post_id"],
        commentId: json["comment_id"],
        amount: json["amount"],
        withdrawalRequestId: json["withdrawal_request_id"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "message": message,
    "type": type,
    "sender_id": senderId,
    "sender_username": senderUsername,
    "post_id": postId,
    "comment_id": commentId,
    "amount": amount,
    "withdrawal_request_id": withdrawalRequestId,
  };
}

enum NotifiableType { APP_MODELS_USER }

final notifiableTypeValues = EnumValues({
  "App\\Models\\User": NotifiableType.APP_MODELS_USER,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
