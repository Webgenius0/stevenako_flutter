import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../model/forgort_model.dart';
import '../model/post_verify_otp_model.dart';
import '../model/register_model.dart';
import 'api.dart';

final class ForgotRx extends RxResponseInt<PostForgotModel> {
  final ForgotApi api = ForgotApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  ForgotRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostForgotModel> get stream => dataFetcher.stream;

  Future<PostForgotModel?> forgotFun({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      final result = await api.forgotFun(
        email: email.trim(),
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Forgot password error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostForgotModel handleSuccessWithReturn(
    PostForgotModel data,
  ) {
    final String message = data.message ?? 'Password reset link sent successfully';
    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  PostForgotModel? handleErrorWithReturn(
    dynamic error,
  ) {
    String message = 'Something went wrong';

    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final apiMessage = responseData['message'] ?? responseData['vendor_message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      if (message == 'Something went wrong' &&
          error.message != null &&
          error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error
          .toString()
          .replaceFirst('Exception: ', '');
    } else if (error is String) {
      message = error;
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}

final class VerifyOtpRx extends RxResponseInt<PostVerifyOtpModel> {
  final VerifyOtpApi api = VerifyOtpApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  VerifyOtpRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostVerifyOtpModel> get stream => dataFetcher.stream;

  Future<PostVerifyOtpModel?> verifyOtpFun({
    required String email,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      final result = await api.verifyOtpFun(
        email: email.trim(),
        otp: otp.trim(),
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Verify OTP error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostVerifyOtpModel handleSuccessWithReturn(
    PostVerifyOtpModel data,
  ) {
    final String message = data.message ?? 'OTP verified successfully';
    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  PostVerifyOtpModel? handleErrorWithReturn(
    dynamic error,
  ) {
    String message = 'Something went wrong';

    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final apiMessage = responseData['message'] ?? responseData['vendor_message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      if (message == 'Something went wrong' &&
          error.message != null &&
          error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error
          .toString()
          .replaceFirst('Exception: ', '');
    } else if (error is String) {
      message = error;
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}

final class RegisterRx extends RxResponseInt<RegisterModel> {
  final RegisterApi api = RegisterApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  RegisterRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<RegisterModel> get stream => dataFetcher.stream;

  Future<RegisterModel?> registerFun({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      isLoading.value = true;
      final result = await api.registerFun(
        name: name.trim(),
        username: username.trim(),
        email: email.trim(),
        password: password.trim(),
        passwordConfirmation: passwordConfirmation.trim(),
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Registration error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  RegisterModel handleSuccessWithReturn(
    RegisterModel data,
  ) {
    final String message = data.message ?? 'Registration successful';
    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  RegisterModel? handleErrorWithReturn(
    dynamic error,
  ) {
    String message = 'Something went wrong';

    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final apiMessage = responseData['message'] ?? responseData['vendor_message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      if (message == 'Something went wrong' &&
          error.message != null &&
          error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    } else if (error is String) {
      message = error;
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}