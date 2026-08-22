// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/notification_settings_model.dart';
import 'api.dart';

final class PostNotificationSettingsRx
    extends RxResponseInt<NotificationSettingsModel> {
  final PostNotificationSettingsApi api = PostNotificationSettingsApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PostNotificationSettingsRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<NotificationSettingsModel> get stream => dataFetcher.stream;

  Future<NotificationSettingsModel?> postNotificationSettings({
    required bool chatManage,
    required bool photoVideoUpdate,
    required bool settingsUpdate,
  }) async {
    try {
      isLoading.value = true;
      final NotificationSettingsModel data =
          await api.postNotificationSettings(
        chatManage: chatManage,
        photoVideoUpdate: photoVideoUpdate,
        settingsUpdate: settingsUpdate,
      );
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Post Notification Settings Error: $error',
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
