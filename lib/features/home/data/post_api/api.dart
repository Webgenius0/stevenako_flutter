import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/get_all_post_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetAllPostApi {
  static final GetAllPostApi _instance = GetAllPostApi._internal();

  GetAllPostApi._internal();

  static GetAllPostApi get instance => _instance;

  Future<GetAllPostModel> getAllPosts() async {
    try {
      final Response response = await getHttp(
        Endpoints.getPostList(),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return GetAllPostModel.fromJson(responseData);
      }

      log(
        'Get All Posts API: Invalid response '
            'status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Get All Posts API DioException: ${error.message}',
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
        'Get All Posts API Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}