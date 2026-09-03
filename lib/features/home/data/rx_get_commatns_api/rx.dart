import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/get_commatns_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetCommentsRx extends RxResponseInt<GetUserCommentsModel> {
  final GetCommentsApi api = GetCommentsApi.instance;

  GetCommentsRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetUserCommentsModel> get stream => dataFetcher.stream;

  Future<GetUserCommentsModel?> getComments({required dynamic id}) async {
    try {
      final GetUserCommentsModel data = await api.getComments(id: id);

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'GetCommentsRx Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    }
  }

  @override
  GetUserCommentsModel handleSuccessWithReturn(
      GetUserCommentsModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetUserCommentsModel? handleErrorWithReturn(
      dynamic error,
      ) {
    String message = 'Failed to load comments. Please try again.';

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