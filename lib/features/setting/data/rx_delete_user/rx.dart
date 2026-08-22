import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/di.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class DeleteUserRx extends RxResponseInt<Map<String, dynamic>> {
  final DeleteUserApi api = DeleteUserApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  DeleteUserRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<Map<String, dynamic>> get stream => dataFetcher.stream;

  Future<Map<String, dynamic>?> deleteUserFun() async {
    try {
      isLoading.value = true;
      final result = await api.deleteUserFun();

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Delete user error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Map<String, dynamic> handleSuccessWithReturn(
    Map<String, dynamic> data,
  ) {
    String message =
        data["message"] ?? data["vendor_message"] ?? "Account deleted successfully";

    appData.erase();
    DioSingleton.instance.update('');

    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  Map<String, dynamic>? handleErrorWithReturn(
    dynamic error,
  ) {
    String message = 'Something went wrong. Please try again.';

    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final apiMessage = responseData['message'] ?? responseData['vendor_message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      if (message == 'Something went wrong. Please try again.' &&
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
