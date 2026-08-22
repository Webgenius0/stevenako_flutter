import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/user_profile_model.dart';

final class GetUserProfileApi {
  static final GetUserProfileApi _instance = GetUserProfileApi._internal();

  GetUserProfileApi._internal();

  static GetUserProfileApi get instance => _instance;

  Future<UserProfileModel> getUserProfile() async {
    try {
      final Response response = await getHttp(Endpoints.userProfile());
      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return UserProfileModel.fromJson(responseData);
      }

      log('Get User Profile API: Invalid response status=${response.statusCode}, data=$responseData');
      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log('Get User Profile API DioException: ${error.message}', stackTrace: stackTrace);

      final dynamic responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final dynamic message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(error.message ?? 'Network error occurred.');
    } catch (error, stackTrace) {
      log('Get User Profile API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
