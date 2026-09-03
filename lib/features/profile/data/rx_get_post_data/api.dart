import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/get_post_model.dart';

final class GetPostDataApi {
  static final GetPostDataApi _instance = GetPostDataApi._internal();

  GetPostDataApi._internal();

  static GetPostDataApi get instance => _instance;

  Future<GetPostModel> getPostData() async {
    try {
      final Response response = await getHttp(
        Endpoints.myTextPost(),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return GetPostModel.fromJson(responseData);
      }

      log(
        'GetPostData API: '
        'Invalid response status=${response.statusCode}, '
        'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'GetPostData API DioException: ${error.message}',
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
        'GetPostData API Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}
