import 'dart:convert';

class PostSetNewPasswordModel {
  bool? success;
  String? message;
  List<dynamic>? data;
  int? code;

  PostSetNewPasswordModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  PostSetNewPasswordModel copyWith({
    bool? success,
    String? message,
    List<dynamic>? data,
    int? code,
  }) =>
      PostSetNewPasswordModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory PostSetNewPasswordModel.fromRawJson(String str) =>
      PostSetNewPasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSetNewPasswordModel.fromJson(Map<String, dynamic> json) =>
      PostSetNewPasswordModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<dynamic>.from(json["data"]!.map((x) => x)),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
        "code": code,
      };
}
