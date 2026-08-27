import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../model/forgort_model.dart';
import '../model/post_verify_otp_model.dart';
import '../model/register_model.dart';

final class ForgotApi {
  static final ForgotApi _singleton = ForgotApi._internal();

  ForgotApi._internal();

  static ForgotApi get instance => _singleton;

  Future<PostForgotModel> forgotFun({
    required String email,
  }) async {
    final FormData data = FormData.fromMap({
      'email': email.trim(),
    });

    final Response response = await postHttp(
      Endpoints.forgetPassword(),
      data,
    );

    final res = response.data;

    if (res is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        res['message']?.toString() ??
            'Forgot password request failed',
      );
    }

    return PostForgotModel.fromJson(res);
  }
}

final class VerifyOtpApi {
  static final VerifyOtpApi _singleton = VerifyOtpApi._internal();

  VerifyOtpApi._internal();

  static VerifyOtpApi get instance => _singleton;

  Future<PostVerifyOtpModel> verifyOtpFun({
    required String email,
    required String otp,
  }) async {
    final FormData data = FormData.fromMap({
      'email': email.trim(),
      'otp': otp.trim(),
    });

    final Response response = await postHttp(
      Endpoints.registerVerifyOtp(),
      data,
    );

    final res = response.data;

    if (res is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        res['message']?.toString() ?? 'OTP verification failed',
      );
    }

    return PostVerifyOtpModel.fromJson(res);
  }
}

final class RegisterApi {
  static final RegisterApi _singleton = RegisterApi._internal();

  RegisterApi._internal();

  static RegisterApi get instance => _singleton;

  Future<RegisterModel> registerFun({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final FormData data = FormData.fromMap({
      'name': name.trim(),
      'username': username.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'password_confirmation': passwordConfirmation.trim(),
      'terms_and_conditions': 1,
    });

    final Response response = await postHttp(
      Endpoints.register(),
      data,
    );

    final res = response.data;


    if (res is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        res['message']?.toString() ?? 'Registration failed',
      );
    }

    return RegisterModel.fromJson(res);
  }
}