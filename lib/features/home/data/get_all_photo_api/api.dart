import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/get_all_photo_model.dart';

final class GetAllPhotoApi {
  static final GetAllPhotoApi _instance = GetAllPhotoApi._internal();

  GetAllPhotoApi._internal();

  static GetAllPhotoApi get instance => _instance;

  Future<GetAllPhotoModel> getPhotos({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final Response response = await getHttp(
        Endpoints.getPhotoList(
          page: page,
          perPage: perPage,
        ),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return GetAllPhotoModel.fromJson(responseData);
      }

      log(
        'GetAllPhotoApi: Invalid response '
            'status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'GetAllPhotoApi DioException: ${error.message}',
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
        'GetAllPhotoApi Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}