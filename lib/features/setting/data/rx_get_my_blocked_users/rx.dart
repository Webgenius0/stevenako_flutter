import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/my_blocked_users_model.dart';
import 'api.dart';

final class GetMyBlockedUsersRx extends RxResponseInt<MyBlockedUsersModel> {
  final GetMyBlockedUsersApi api = GetMyBlockedUsersApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetMyBlockedUsersRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<MyBlockedUsersModel> get stream => dataFetcher.stream;

  Future<MyBlockedUsersModel?> getMyBlockedUsers() async {
    try {
      isLoading.value = true;
      final MyBlockedUsersModel data = await api.getMyBlockedUsers();
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get My Blocked Users Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  MyBlockedUsersModel handleSuccessWithReturn(MyBlockedUsersModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  MyBlockedUsersModel? handleErrorWithReturn(dynamic error) {
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
