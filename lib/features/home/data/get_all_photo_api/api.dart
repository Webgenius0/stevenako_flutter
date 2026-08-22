import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/get_all_photo_model.dart';

final class GetAllPhotoApi {
  static final GetAllPhotoApi _instance = GetAllPhotoApi._internal();

  GetAllPhotoApi._internal();

  static GetAllPhotoApi get instance => _instance;

  Future<GetAllPhotoModel> getPhotos() async {
    try {
      final Response response = await getHttp(
        Endpoints.getPhotoList(),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return GetAllPhotoModel.fromJson(responseData);
      }

      log(
        'Get All Photos API: Invalid response '
            'status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Get All Photos API DioException: ${error.message}',
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
        'Get All Photos API Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}