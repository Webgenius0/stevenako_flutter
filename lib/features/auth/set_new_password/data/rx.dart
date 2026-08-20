import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../model/set_new_passwrod_model.dart';
import 'api.dart';

final class SetNewPasswordRx extends RxResponseInt<PostSetNewPasswordModel> {
  final SetNewPasswordApi api = SetNewPasswordApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  SetNewPasswordRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostSetNewPasswordModel> get stream => dataFetcher.stream;

  Future<PostSetNewPasswordModel?> setNewPasswordFun({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String resetToken,
  }) async {
    try {
      isLoading.value = true;
      final result = await api.setNewPasswordFun(
        email: email.trim(),
        password: password.trim(),
        passwordConfirmation: passwordConfirmation.trim(),
        resetToken: resetToken.trim(),
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Set new password error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostSetNewPasswordModel handleSuccessWithReturn(
    PostSetNewPasswordModel data,
  ) {
    final String message = data.message ?? 'Password reset successfully.';
    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  PostSetNewPasswordModel? handleErrorWithReturn(
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
