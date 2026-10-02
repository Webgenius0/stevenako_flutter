import 'dart:developer' as dev;

import 'package:dio/dio.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/secure_storage_helper.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/dio/dio.dart';
import '../google_sing_in_model.dart';
import 'api.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Calls the backend Google login endpoint and handles token storage.
// ─────────────────────────────────────────────────────────────────────────────

final class GoogleSignInRx {
  final GoogleSignInApi _api = GoogleSignInApi.instance;

  Future<GoogleSignInModel?> loginWithGoogle({
    required String accessToken,
  }) async {
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignInRx');
    dev.log('🌐 Calling backend: POST /user/login/google', name: 'GoogleSignInRx');
    dev.log('   └─ access_token : $accessToken', name: 'GoogleSignInRx');

    try {
      final response = await _api.loginWithGoogle(accessToken: accessToken);
      return _handleSuccess(response);
    } catch (e, st) {
      return _handleError(e, st);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SUCCESS
  // ─────────────────────────────────────────────────────────────────────────

  GoogleSignInModel _handleSuccess(GoogleSignInModel data) {
    final user = data.data?.user;
    final token = data.data?.token ?? '';

    dev.log('✅ Backend Google Login SUCCESS:', name: 'GoogleSignInRx');
    dev.log('   ├─ success      : ${data.success}', name: 'GoogleSignInRx');
    dev.log('   ├─ message      : ${data.message}', name: 'GoogleSignInRx');
    dev.log('   ├─ user.id      : ${user?.id}', name: 'GoogleSignInRx');
    dev.log('   ├─ user.name    : ${user?.name}', name: 'GoogleSignInRx');
    dev.log('   ├─ user.email   : ${user?.email}', name: 'GoogleSignInRx');
    dev.log('   ├─ user.username: ${user?.username}', name: 'GoogleSignInRx');
    dev.log('   ├─ user.avatar  : ${user?.avatar}', name: 'GoogleSignInRx');
    dev.log('   ├─ user.role    : ${user?.role}', name: 'GoogleSignInRx');
    dev.log('   ├─ user.status  : ${user?.status}', name: 'GoogleSignInRx');
    dev.log('   └─ app token    : $token', name: 'GoogleSignInRx');

    // ── Persist session (same keys as normal login) ──────────────────────────
    appData.write(kKeyIsLoggedIn, true);
    appData.write(kKeyAccessToken, token);
    appData.write('is_guest', false);
    appData.write('user_id', user?.id?.toString() ?? '');

    if (token.isNotEmpty) {
      SecureStorageHelper.saveAccessToken(token);
    }

    // ── Update Dio authorization header ──────────────────────────────────────
    if (token.isNotEmpty) {
      DioSingleton.instance.update(token);
      dev.log('🔐 Dio token updated.', name: 'GoogleSignInRx');
    }

    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignInRx');
    return data;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ERROR
  // ─────────────────────────────────────────────────────────────────────────

  GoogleSignInModel? _handleError(dynamic error, StackTrace st) {
    String message = 'Google login failed. Please try again.';

    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final apiMessage = responseData['message'] ??
            responseData['error'] ??
            responseData['detail'];
        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    }

    dev.log('❌ Backend Google Login ERROR: $message',
        name: 'GoogleSignInRx', error: error, stackTrace: st);
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'GoogleSignInRx');

    ToastUtil.showShortToast(message);
    return null;
  }
}
