import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/get_all_post_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetAllPostRx extends RxResponseInt<GetAllPostModel> {
  final GetAllPostApi api = GetAllPostApi.instance;

  GetAllPostRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetAllPostModel> get stream => dataFetcher.stream;

  Future<GetAllPostModel?> getAllPosts() async {
    try {
      final GetAllPostModel data = await api.getAllPosts();

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get All Posts Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    }
  }

  @override
  GetAllPostModel handleSuccessWithReturn(
      GetAllPostModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetAllPostModel? handleErrorWithReturn(
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