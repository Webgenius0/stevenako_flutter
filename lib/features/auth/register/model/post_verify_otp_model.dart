import 'dart:convert';

class PostVerifyOtpModel {
  bool? success;
  String? message;
  dynamic data;
  int? code;

  PostVerifyOtpModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  PostVerifyOtpModel copyWith({
    bool? success,
    String? message,
    dynamic data,
    int? code,
  }) =>
      PostVerifyOtpModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory PostVerifyOtpModel.fromRawJson(String str) =>
      PostVerifyOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostVerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      PostVerifyOtpModel(
        success: json["success"],
        message: json["message"],
        data: json["data"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
        "code": code,
      };
}
