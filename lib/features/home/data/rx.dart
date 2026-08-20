import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helpers/toast.dart';
import '../../../networks/rx_base.dart';
import '../model/hom_screen_reals_model.dart';
import 'api.dart';

final class GetReelsRx extends RxResponseInt<GetReelsListModel> {
  final GetReelsApi api = GetReelsApi.instance;

  GetReelsRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetReelsListModel> get stream => dataFetcher.stream;

  Future<GetReelsListModel?> getReels([String? mentorId]) async {
    try {
      final GetReelsListModel data = await api.getReels(mentorId);

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get Reels Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    }
  }

  @override
  GetReelsListModel handleSuccessWithReturn(
      GetReelsListModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetReelsListModel? handleErrorWithReturn(
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