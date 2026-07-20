

class ErrorMessageHelper {
  static String extractMessage(dynamic data) {
    if (data is Map) {
      if (data["message"] != null && data["message"].toString().isNotEmpty) {
        return data["message"].toString();
      }
      if (data["error"] is String) {
        return data["error"];
      }
      if (data["error"] is List && (data["error"] as List).isNotEmpty) {
        return (data["error"] as List).first.toString();
      }
    } else if (data is String) {
      return data;
    }
    return "An unexpected error occurred";
  }
}
