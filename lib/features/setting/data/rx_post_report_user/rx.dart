import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class ReportUserRx extends RxResponseInt<Map<String, dynamic>> {
  final ReportUserApi api = ReportUserApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  ReportUserRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<Map<String, dynamic>> get stream => dataFetcher.stream;

  Future<Map<String, dynamic>?> reportUser({
    required String userId,
    required String reason,
    required String description,
  }) async {
    try {
      isLoading.value = true;
      final result = await api.reportUser(
        userId: userId,
        reason: reason,
        description: description,
      );
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Report user error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Map<String, dynamic> handleSuccessWithReturn(Map<String, dynamic> data) {
    final String message =
        data['message']?.toString() ?? 'User reported successfully.';
    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  Map<String, dynamic>? handleErrorWithReturn(dynamic error) {
    String message = 'Something went wrong. Please try again.';

    if (error is DioException) {
      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic apiMessage = responseData['message'];

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
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}
