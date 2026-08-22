import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/message/model/get_all_messae_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetAllMessageListApi {
  static final GetAllMessageListApi _instance =
  GetAllMessageListApi._internal();

  GetAllMessageListApi._internal();

  static GetAllMessageListApi get instance => _instance;

  Future<GetAllMesageListModel> getMessages() async {
    try {
      final Response response = await getHttp(
        Endpoints.getMessageList(),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return GetAllMesageListModel.fromJson(responseData);
      }

      log(
        'Get All Messages API: Invalid response '
            'status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Get All Messages API DioException: ${error.message}',
        stackTrace: stackTrace,
      );

      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic message = responseData['message'];

        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(
        error.message ?? 'Network error occurred.',
      );
    } catch (error, stackTrace) {
      log(
        'Get All Messages API Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}