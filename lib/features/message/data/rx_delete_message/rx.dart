// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class DeleteMessageRx extends RxResponseInt<Map<String, dynamic>> {
  final DeleteMessageApi api = DeleteMessageApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  DeleteMessageRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<Map<String, dynamic>> get stream => dataFetcher.stream;

  Future<Map<String, dynamic>?> deleteMessage(String messageId) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> data = await api.deleteMessage(messageId);
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log('Delete Message Rx Error: $error', stackTrace: stackTrace);
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Map<String, dynamic> handleSuccessWithReturn(Map<String, dynamic> data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  Map<String, dynamic>? handleErrorWithReturn(dynamic error) {
    String message = 'Failed to delete message.';

    if (error is DioException) {
      final dynamic responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final dynamic apiMessage = responseData['message'];
        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }
      if (message == 'Failed to delete message.' &&
          error.message != null &&
          error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    }

    ToastUtil.showShortToast(message);
    return null;
  }
}
