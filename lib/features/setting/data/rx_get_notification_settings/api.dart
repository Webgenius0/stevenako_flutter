import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/notification_settings_model.dart';

final class GetNotificationSettingsApi {
  static final GetNotificationSettingsApi _instance =
      GetNotificationSettingsApi._internal();

  GetNotificationSettingsApi._internal();

  static GetNotificationSettingsApi get instance => _instance;

  Future<NotificationSettingsModel> getNotificationSettings() async {
    try {
      final Response response = await getHttp(Endpoints.notificationSettings());
      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return NotificationSettingsModel.fromJson(responseData);
      }

      log(
        'Get Notification Settings API: Invalid response '
        'status=${response.statusCode}, data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Get Notification Settings API DioException: ${error.message}',
        stackTrace: stackTrace,
      );

      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic message = responseData['message'];

        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(error.message ?? 'Network error occurred.');
    } catch (error, stackTrace) {
      log(
        'Get Notification Settings API Unexpected Error: $error',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

