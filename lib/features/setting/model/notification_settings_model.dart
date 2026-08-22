import 'dart:convert';

class NotificationSettingsModel {
  bool? success;
  String? message;
  NotificationSettingsData? data;
  int? code;

  NotificationSettingsModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  NotificationSettingsModel copyWith({
    bool? success,
    String? message,
    NotificationSettingsData? data,
    int? code,
  }) =>
      NotificationSettingsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory NotificationSettingsModel.fromRawJson(String str) =>
      NotificationSettingsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : NotificationSettingsData.fromJson(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}

class NotificationSettingsData {
  NotificationSettings? settings;

  NotificationSettingsData({this.settings});

  NotificationSettingsData copyWith({NotificationSettings? settings}) =>
      NotificationSettingsData(
        settings: settings ?? this.settings,
      );

  factory NotificationSettingsData.fromRawJson(String str) =>
      NotificationSettingsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationSettingsData.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsData(
        settings: json["settings"] == null
            ? null
            : NotificationSettings.fromJson(json["settings"]),
      );

  Map<String, dynamic> toJson() => {
        "settings": settings?.toJson(),
      };
}

class NotificationSettings {
  bool? allNotification;
  bool? chatManage;
  bool? photoVideoUpdate;
  bool? settingsUpdate;

  NotificationSettings({
    this.allNotification,
    this.chatManage,
    this.photoVideoUpdate,
    this.settingsUpdate,
  });

  NotificationSettings copyWith({
    bool? allNotification,
    bool? chatManage,
    bool? photoVideoUpdate,
    bool? settingsUpdate,
  }) =>
      NotificationSettings(
        allNotification: allNotification ?? this.allNotification,
        chatManage: chatManage ?? this.chatManage,
        photoVideoUpdate: photoVideoUpdate ?? this.photoVideoUpdate,
        settingsUpdate: settingsUpdate ?? this.settingsUpdate,
      );

  factory NotificationSettings.fromRawJson(String str) =>
      NotificationSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        allNotification: json["all_notification"],
        chatManage: json["chat_manage"],
        photoVideoUpdate: json["photo_video_update"],
        settingsUpdate: json["settings_update"],
      );

  Map<String, dynamic> toJson() => {
        "all_notification": allNotification,
        "chat_manage": chatManage,
        "photo_video_update": photoVideoUpdate,
        "settings_update": settingsUpdate,
      };
}
