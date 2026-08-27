import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/get_my_vidoe_post_model.dart';

final class GetMyVideoPostApi {
  static final GetMyVideoPostApi _instance =
  GetMyVideoPostApi._internal();

  GetMyVideoPostApi._internal();

  static GetMyVideoPostApi get instance => _instance;

  Future<GetMyVodeoPostModel> getVideo() async {
    try {
      final Response response = await getHttp(
        Endpoints.myVideoPost(),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return GetMyVodeoPostModel.fromJson(responseData);
      }

      log(
        'GetMyVideoPost API: '
            'Invalid response status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'GetMyVideoPost API DioException: ${error.message}',
        stackTrace: stackTrace,
      );

      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic message = responseData['message'];

        if (message is String && message.trim().isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(
        error.message ?? 'Network error occurred.',
      );
    } catch (error, stackTrace) {
      log(
        'GetMyVideoPost API Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}