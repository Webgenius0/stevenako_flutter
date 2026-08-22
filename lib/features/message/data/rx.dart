import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/message/model/get_all_messae_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetAllMessageListRx
    extends RxResponseInt<GetAllMesageListModel> {
  final GetAllMessageListApi api = GetAllMessageListApi.instance;

  GetAllMessageListRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetAllMesageListModel> get stream => dataFetcher.stream;

  Future<GetAllMesageListModel?> getMessages() async {
    try {
      final GetAllMesageListModel data = await api.getMessages();

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get All Messages Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    }
  }

  @override
  GetAllMesageListModel handleSuccessWithReturn(
      GetAllMesageListModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetAllMesageListModel? handleErrorWithReturn(
      dynamic error,
      ) {
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
      message = error
          .toString()
          .replaceFirst('Exception: ', '');
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}