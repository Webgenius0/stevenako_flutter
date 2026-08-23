import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/my_blocked_users_model.dart';

final class GetMyBlockedUsersApi {
  static final GetMyBlockedUsersApi _instance = GetMyBlockedUsersApi._internal();

  GetMyBlockedUsersApi._internal();

  static GetMyBlockedUsersApi get instance => _instance;

  Future<MyBlockedUsersModel> getMyBlockedUsers() async {
    try {
      final Response response = await getHttp(Endpoints.myBlockedUsers());
      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return MyBlockedUsersModel.fromJson(responseData);
      }

      log('Get My Blocked Users API: Invalid response status=${response.statusCode}, data=$responseData');
      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log('Get My Blocked Users API DioException: ${error.message}', stackTrace: stackTrace);

      final dynamic responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final dynamic message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(error.message ?? 'Network error occurred.');
    } catch (error, stackTrace) {
      log('Get My Blocked Users API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
