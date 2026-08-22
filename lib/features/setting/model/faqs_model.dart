import 'dart:convert';

class FaqsModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  FaqsModel({this.success, this.message, this.data, this.code});

  FaqsModel copyWith({bool? success, String? message, Data? data, int? code}) =>
      FaqsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory FaqsModel.fromRawJson(String str) =>
      FaqsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
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
  List<Faq>? faqs;

  Data({this.faqs});

  Data copyWith({List<Faq>? faqs}) => Data(faqs: faqs ?? this.faqs);

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    faqs: json["faqs"] == null
        ? []
        : List<Faq>.from(json["faqs"]!.map((x) => Faq.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "faqs": faqs == null
        ? []
        : List<dynamic>.from(faqs!.map((x) => x.toJson())),
  };
}

class Faq {
  int? id;
  String? question;
  String? answer;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Faq({
    this.id,
    this.question,
    this.answer,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Faq copyWith({
    int? id,
    String? question,
    String? answer,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Faq(
    id: id ?? this.id,
    question: question ?? this.question,
    answer: answer ?? this.answer,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Faq.fromRawJson(String str) => Faq.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
