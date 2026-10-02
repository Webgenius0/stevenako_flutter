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
  dynamic notifiableType;
  dynamic notifiableId;
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
    dynamic notifiableType,
    dynamic notifiableId,
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
    id: json["id"]?.toString(),
    type: json["type"]?.toString(),
    notifiableType: json["notifiable_type"]?.toString(),
    notifiableId: json["notifiable_id"],
    data: json["data"] == null || json["data"] is! Map<String, dynamic>
        ? null
        : NotificationData.fromJson(json["data"] as Map<String, dynamic>),
    readAt: json["read_at"] == null
        ? null
        : DateTime.tryParse(json["read_at"].toString()),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "notifiable_type": notifiableType?.toString(),
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
  dynamic senderId;
  String? senderUsername;
  dynamic postId;
  dynamic commentId;
  dynamic amount;
  dynamic withdrawalRequestId;
  dynamic depositId;

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
    this.depositId,
  });

  NotificationData copyWith({
    String? title,
    String? message,
    String? type,
    dynamic senderId,
    String? senderUsername,
    dynamic postId,
    dynamic commentId,
    dynamic amount,
    dynamic withdrawalRequestId,
    dynamic depositId,
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
    depositId: depositId ?? this.depositId,
  );

  factory NotificationData.fromRawJson(String str) =>
      NotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        title: json["title"]?.toString(),
        message: json["message"]?.toString(),
        type: json["type"]?.toString(),
        senderId: json["sender_id"],
        senderUsername: json["sender_username"]?.toString(),
        postId: json["post_id"],
        commentId: json["comment_id"],
        amount: json["amount"],
        withdrawalRequestId: json["withdrawal_request_id"],
        depositId: json["deposit_id"],
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
    "deposit_id": depositId,
  };
}
