import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/get_commatns_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetCommentsApi {
  static final GetCommentsApi _instance = GetCommentsApi._internal();

  GetCommentsApi._internal();

  static GetCommentsApi get instance => _instance;

  Future<GetUserCommentsModel> getComments({required dynamic id}) async {
    try {
      final Response response = await getHttp(
        Endpoints.getAllCommants(id),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return GetUserCommentsModel.fromJson(responseData);
      }

      log(
        'GetCommentsApi: Invalid response '
            'status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'GetCommentsApi DioException: ${error.message}',
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
        'GetCommentsApi Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}