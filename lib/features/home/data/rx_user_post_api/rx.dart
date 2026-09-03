import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/user_post_model.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

import '../../../../helpers/toast.dart';
import 'api.dart';

final class UserPostRx extends RxResponseInt<UserPostModel> {
  final UserPostApi api = UserPostApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  UserPostRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<UserPostModel> get stream => dataFetcher.stream;

  Future<UserPostModel?> post({
    required String type,
    required String caption,
    required String locationName,
    required double locationLat,
    required double locationLng,
    required String privacySetting,
    required int allowComments,
    required int allowGifts,
    required List<int> taggedUserIds,
    File? video,
    File? photo,
    List<File>? photos,
    int? soundId,
  }) async {
    try {
      isLoading.value = true;

      final result = await api.post(
        type: type,
        caption: caption,
        locationName: locationName,
        locationLat: locationLat,
        locationLng: locationLng,
        privacySetting: privacySetting,
        allowComments: allowComments,
        allowGifts: allowGifts,
        taggedUserIds: taggedUserIds,
        video: video,
        photo: photo,
        photos: photos,
        soundId: soundId,
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'UserPostRx Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  UserPostModel handleSuccessWithReturn(
      UserPostModel data,
      ) {
    final String message =
        data.message ?? 'Post created successfully';

    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }

    dataFetcher.sink.add(data);

    return data;
  }

  @override
  UserPostModel? handleErrorWithReturn(
    dynamic error,
  ) {
    final String message = _extractAuthErrorMessage(error);

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }

  String _extractAuthErrorMessage(dynamic error) {
    String message = 'Failed to create post. Please try again.';

    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        if (responseData['errors'] != null && responseData['errors'] is Map) {
          final errorsMap = responseData['errors'] as Map;
          if (errorsMap.isNotEmpty) {
            final firstVal = errorsMap.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              message = firstVal.first.toString();
            } else if (firstVal is String && firstVal.isNotEmpty) {
              message = firstVal;
            }
          }
        }

        if (message == 'Failed to create post. Please try again.') {
          final apiMessage = responseData['message'] ??
              responseData['error'] ??
              responseData['detail'] ??
              responseData['vendor_message'];

          if (apiMessage is String && apiMessage.isNotEmpty) {
            message = apiMessage;
          }
        }
      } else if (error.message != null && error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      final msg = error.toString().replaceFirst('Exception: ', '');
      if (msg.isNotEmpty) message = msg;
    } else if (error is String) {
      message = error;
    }

    return message;
  }
}