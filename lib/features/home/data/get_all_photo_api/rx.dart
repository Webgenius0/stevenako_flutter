import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/get_all_photo_model.dart';
import 'api.dart';

final class GetAllPhotoRx extends RxResponseInt<GetAllPhotoModel> {
  final GetAllPhotoApi api = GetAllPhotoApi.instance;

  GetAllPhotoRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetAllPhotoModel> get stream => dataFetcher.stream;

  Future<GetAllPhotoModel?> getPhotos() async {
    try {
      final GetAllPhotoModel data = await api.getPhotos();

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get All Photos Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    }
  }

  @override
  GetAllPhotoModel handleSuccessWithReturn(
      GetAllPhotoModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetAllPhotoModel? handleErrorWithReturn(
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