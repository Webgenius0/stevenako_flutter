import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/user_profile_model.dart';
import 'api.dart';

final class GetUserProfileRx extends RxResponseInt<UserProfileModel> {
  final GetUserProfileApi api = GetUserProfileApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetUserProfileRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<UserProfileModel> get stream => dataFetcher.stream;

  Future<UserProfileModel?> getUserProfile() async {
    try {
      isLoading.value = true;
      final UserProfileModel data = await api.getUserProfile();
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get User Profile Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  UserProfileModel handleSuccessWithReturn(UserProfileModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  UserProfileModel? handleErrorWithReturn(dynamic error) {
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
