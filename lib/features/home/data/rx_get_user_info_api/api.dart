import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/get_user_info_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetUserInfoApi {
  static final GetUserInfoApi _instance = GetUserInfoApi._internal();

  GetUserInfoApi._internal();

  static GetUserInfoApi get instance => _instance;

  Future<GetUserInfoModel> getUserInfo({required dynamic id}) async {
    try {
      final Response response = await getHttp(
        Endpoints.userData(id),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return GetUserInfoModel.fromJson(responseData);
      }

      log(
        'GetUserInfoApi: Invalid response '
            'status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'GetUserInfoApi DioException: ${error.message}',
        stackTrace: stackTrace,
      );

      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic message =
            responseData['message'] ?? responseData['status_message'];

        if (message is String && message.trim().isNotEmpty) {
          throw Exception(message.trim());
        }
      }

      throw Exception(
        error.message ?? 'Network error occurred.',
      );
    } catch (error, stackTrace) {
      log(
        'GetUserInfoApi Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}