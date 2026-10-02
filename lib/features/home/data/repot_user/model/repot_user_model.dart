class ReportPostModel {
  final bool? success;
  final String? message;
  final ReportData? data;
  final int? code;

  ReportPostModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory ReportPostModel.fromJson(Map<String, dynamic> json) => ReportPostModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null ? null : ReportData.fromJson(json["data"] as Map<String, dynamic>),
        code: json["code"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}

class ReportData {
  final ReportItem? report;

  ReportData({
    this.report,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
        report: json["report"] == null ? null : ReportItem.fromJson(json["report"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "report": report?.toJson(),
      };
}

class ReportItem {
  final int? postId;
  final int? userId;
  final String? reason;
  final String? description;
  final String? updatedAt;
  final String? createdAt;
  final int? id;

  ReportItem({
    this.postId,
    this.userId,
    this.reason,
    this.description,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory ReportItem.fromJson(Map<String, dynamic> json) => ReportItem(
        postId: json["post_id"] as int?,
        userId: json["user_id"] as int?,
        reason: json["reason"] as String?,
        description: json["description"] as String?,
        updatedAt: json["updated_at"] as String?,
        createdAt: json["created_at"] as String?,
        id: json["id"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "reason": reason,
        "description": description,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
      };
}
