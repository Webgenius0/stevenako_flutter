// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/notification_settings_model.dart';
import 'api.dart';

final class PostAllNotificationRx
    extends RxResponseInt<NotificationSettingsModel> {
  final PostAllNotificationApi api = PostAllNotificationApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PostAllNotificationRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<NotificationSettingsModel> get stream => dataFetcher.stream;

  Future<NotificationSettingsModel?> postAllNotification({
    required bool allNotification,
  }) async {
    try {
      isLoading.value = true;
      final NotificationSettingsModel data = await api.postAllNotification(
        allNotification: allNotification,
      );
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Post All Notification Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  NotificationSettingsModel handleSuccessWithReturn(
    NotificationSettingsModel data,
  ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  NotificationSettingsModel? handleErrorWithReturn(dynamic error) {
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
