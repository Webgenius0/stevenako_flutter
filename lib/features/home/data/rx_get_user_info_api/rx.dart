import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:stevenako_flutter/features/home/model/get_user_info_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetUserInfoRx extends RxResponseInt<GetUserInfoModel> {
  final GetUserInfoApi api = GetUserInfoApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetUserInfoRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetUserInfoModel> get stream => dataFetcher.stream;

  Future<GetUserInfoModel?> getUserInfo({required dynamic id}) async {
    try {
      isLoading.value = true;
      final GetUserInfoModel data = await api.getUserInfo(id: id);

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'GetUserInfoRx Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetUserInfoModel handleSuccessWithReturn(
      GetUserInfoModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetUserInfoModel? handleErrorWithReturn(
      dynamic error,
      ) {
    String message = 'Failed to load user profile. Please try again.';

    if (error is DioException) {
      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic apiMessage =
            responseData['message'] ?? responseData['status_message'];

        if (apiMessage is String && apiMessage.trim().isNotEmpty) {
          message = apiMessage.trim();
        }
      } else if (error.message != null && error.message!.trim().isNotEmpty) {
        message = error.message!.trim();
      }
    } else if (error is Exception) {
      final parsed = error.toString().replaceFirst('Exception: ', '').trim();
      if (parsed.isNotEmpty) {
        message = parsed;
      }
    } else if (error is String && error.trim().isNotEmpty) {
      message = error.trim();
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}