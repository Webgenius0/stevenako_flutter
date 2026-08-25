import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/rx_base.dart';
import '../model/login_model.dart';
import 'api.dart';

final class SigninRx extends RxResponseInt<PostLoginModel> {
  final SigninApi api = SigninApi.instance;

  SigninRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostLoginModel> get stream => dataFetcher.stream;

  Future<PostLoginModel> signInFun({
    required String email,
    required String password,
  }) async {
    log('🚀 SIGNIN START');

    try {
      final response = await api.signInFun(
        email: email,
        password: password,
      );

      return handleSuccess(response);
    } catch (e, st) {
      log('❌ SIGNIN ERROR: $e');
      log('STACK TRACE: $st');

      return handleError(e);
    }
  }

  PostLoginModel handleSuccess(PostLoginModel data) {
    final user = data.data?.user;
    final token = data.data?.token ?? '';

    log('✅ LOGIN SUCCESS');
    log('👤 Email: ${user?.email}');
    log('👤 User ID: ${user?.id}');
    log('🔑 Access token received: ${token.isNotEmpty}');

    // Save login state
    appData.write(kKeyIsLoggedIn, true);
    appData.write(kKeyAccessToken, token);
    appData.write('is_guest', false);

    // Save user ID
    appData.write(
      'user_id',
      user?.id?.toString() ?? '',
    );

    // Update Dio authorization token
    if (token.isNotEmpty) {
      DioSingleton.instance.update(token);
    }

    // Register FCM token after successful login if needed.
    // FCMNotificationService.getAndRegisterToken();

    // Emit successful response
    dataFetcher.sink.add(data);

    return data;
  }

  PostLoginModel handleError(dynamic error) {
    String message = 'Invalid email or password. Please try again.';

    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final apiMessage = responseData['message'] ??
            responseData['error'] ??
            responseData['detail'] ??
            responseData['vendor_message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        } else if (responseData['errors'] != null) {
          final errors = responseData['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstVal = errors.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              message = firstVal.first.toString();
            } else if (firstVal is String) {
              message = firstVal;
            }
          }
        }
      } else if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 422 ||
          error.response?.statusCode == 400) {
        message = 'Invalid email or password. Please try again.';
      } else if (error.message != null && error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      final errorMessage = error.toString();
      if (errorMessage.isNotEmpty) {
        message = errorMessage.replaceFirst('Exception: ', '');
      }
    }

    log('❌ LOGIN FAILED: $message');

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return PostLoginModel(
      success: false,
      code: error is DioException ? (error.response?.statusCode ?? 0) : 0,
      message: message,
      data: null,
    );
  }
}