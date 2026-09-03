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

  Future<GetReelsListModel?> getReels({
    int page = 1,
    int? perPage,
    String? mentorId,
  }) async {
    try {
      final GetReelsListModel data = await api.getReels(
        page: page,
        perPage: perPage,
        mentorId: mentorId,
      );

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'GetReelsRx Error: $error',
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
    String message = 'Failed to load reels. Please try again.';

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