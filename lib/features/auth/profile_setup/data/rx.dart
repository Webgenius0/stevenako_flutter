import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/auth/profile_setup/model/sing_up_profiel_satep_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostSetProfileRx
    extends RxResponseInt<PostSingUpProfielSatipModel> {
  final PostSetProfileApi api = PostSetProfileApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PostSetProfileRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostSingUpProfielSatipModel> get stream =>
      dataFetcher.stream;

  Future<PostSingUpProfielSatipModel?> setProfile({
     String? name,
    String? username,
    required String bio,
    required String gender,
    required String dateOfBirth,
    File? avatar,
  }) async {
    try {
      isLoading.value = true;

      final result = await api.setProfile(
        name: name?.trim(),
        username: username?.trim(),
        bio: bio.trim(),
        gender: gender.trim(),
        dateOfBirth: dateOfBirth.trim(),
        avatar: avatar,
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Set profile error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostSingUpProfielSatipModel handleSuccessWithReturn(
      PostSingUpProfielSatipModel data,
      ) {
    final String message =
        data.message ?? 'Profile updated successfully';

    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }

    dataFetcher.sink.add(data);

    return data;
  }

  @override
  PostSingUpProfielSatipModel? handleErrorWithReturn(
      dynamic error,
      ) {
    String message = 'Something went wrong';

    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final apiMessage =
            responseData['message'] ??
                responseData['vendor_message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      if (message == 'Something went wrong' &&
          error.message != null &&
          error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error
          .toString()
          .replaceFirst('Exception: ', '');
    } else if (error is String) {
      message = error;
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}