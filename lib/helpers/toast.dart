import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

final class ToastUtil {
  ToastUtil._();

  static String cleanErrorMessage(dynamic error) {
    if (error == null) return 'Something went wrong. Please try again.';

    final String rawStr = error.toString().trim();
    final String lower = rawStr.toLowerCase();

    // Catch offline / connection / socket lookup failures
    if (lower.contains('socketexception') ||
        lower.contains('connection error') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('handshakeexception') ||
        lower.contains('timeout') ||
        lower.contains('connectiontimeout') ||
        lower.contains('clientexception') ||
        lower.contains('no address associated with hostname')) {
      return 'No internet connection. Please check your network.';
    }

    // Catch server errors
    if (lower.contains('500') || lower.contains('internal server error')) {
      return 'Server is temporarily unavailable. Please try again later.';
    }

    if (lower.contains('401') || lower.contains('unauthenticated')) {
      return 'Session expired. Please log in again.';
    }

    // Strip raw exception class names
    String cleaned = rawStr.replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
    if (cleaned.startsWith('DioException')) {
      cleaned = 'Network connection failed. Please try again.';
    }

    if (cleaned.isEmpty || cleaned.length > 120) {
      return 'Something went wrong. Please try again.';
    }

    return cleaned;
  }

  static void showLongToast(String message) {
    final String cleaned = cleanErrorMessage(message);
    Fluttertoast.showToast(
      msg: cleaned.tr,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showShortToast(String message) {
    final String cleaned = cleanErrorMessage(message);
    Fluttertoast.showToast(
      msg: cleaned.tr,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void showNoInternetToast() {
    Fluttertoast.showToast(
      msg: "No internet connection. Please check your network.".tr,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void showNotLoggedInToast() {
    Fluttertoast.showToast(
      msg: "Please login to perform this operation".tr,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
