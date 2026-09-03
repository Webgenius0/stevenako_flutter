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

  Future<GetAllPostModel?> getAllPosts({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final GetAllPostModel data = await api.getAllPosts(
        page: page,
        perPage: perPage,
      );

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'GetAllPostRx Error: $error',
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
    String message = 'Failed to load posts. Please try again.';

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