// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostSendMessageRx extends RxResponseInt<Map<String, dynamic>> {
  final PostSendMessageApi api = PostSendMessageApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PostSendMessageRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<Map<String, dynamic>> get stream => dataFetcher.stream;

  Future<Map<String, dynamic>?> sendMessage({
    required String conversationId,
    required String message,
    File? file,
  }) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> res = await api.sendMessage(
        conversationId: conversationId,
        message: message,
        file: file,
      );
      return handleSuccessWithReturn(res);
    } catch (error, stackTrace) {
      log('Post Send Message Error: $error', stackTrace: stackTrace);
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
    return null;
  }
}
