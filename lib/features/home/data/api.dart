import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../networks/dio/dio.dart';
import '../../../networks/endpoints.dart';
import '../model/hom_screen_reals_model.dart';

final class GetReelsApi {
  static final GetReelsApi _instance = GetReelsApi._internal();

  GetReelsApi._internal();

  static GetReelsApi get instance => _instance;

  Future<GetReelsListModel> getReels([String? mentorId]) async {
    try {
      final Response response = await getHttp(
        Endpoints.getRealsVideoAll(mentorId),
      );

      final dynamic responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return GetReelsListModel.fromJson(responseData);
      }

      log(
        'Get Reels API: Invalid response '
            'status=${response.statusCode}, '
            'data=$responseData',
      );

      throw Exception(
        'Invalid response from server.',
      );
    } on DioException catch (error, stackTrace) {
      log(
        'Get Reels API DioException: ${error.message}',
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
        'Get Reels API Unexpected Error: $error',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}