class ReelsCountModel {
  final bool? success;
  final String? message;
  final ReelsCountData? data;
  final int? code;

  ReelsCountModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory ReelsCountModel.fromJson(Map<String, dynamic> json) =>
      ReelsCountModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : ReelsCountData.fromJson(json["data"] as Map<String, dynamic>),
        code: json["code"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}

class ReelsCountData {
  final int? viewsCount;
  final bool? isUniqueViewRecorded;

  ReelsCountData({
    this.viewsCount,
    this.isUniqueViewRecorded,
  });

  factory ReelsCountData.fromJson(Map<String, dynamic> json) => ReelsCountData(
        viewsCount: json["views_count"] is int
            ? json["views_count"] as int
            : int.tryParse(json["views_count"]?.toString() ?? ''),
        isUniqueViewRecorded: json["is_unique_view_recorded"] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "views_count": viewsCount,
        "is_unique_view_recorded": isUniqueViewRecorded,
      };
}
