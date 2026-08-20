import 'dart:convert';

class PostForgotModel {
  bool? success;
  String? message;
  List<dynamic>? data;
  int? code;

  PostForgotModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  PostForgotModel copyWith({
    bool? success,
    String? message,
    List<dynamic>? data,
    int? code,
  }) =>
      PostForgotModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory PostForgotModel.fromRawJson(String str) => PostForgotModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostForgotModel.fromJson(Map<String, dynamic> json) => PostForgotModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    "code": code,
  };
}
