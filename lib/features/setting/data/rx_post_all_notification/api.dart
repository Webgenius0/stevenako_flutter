import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/notification_settings_model.dart';

final class PostAllNotificationApi {
  static final PostAllNotificationApi _instance =
      PostAllNotificationApi._internal();

  PostAllNotificationApi._internal();

  static PostAllNotificationApi get instance => _instance;

  Future<NotificationSettingsModel> postAllNotification({
    required bool allNotification,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        'all_notification': allNotification,
      };

      log('Posting All Notification Setting: $bodyData');

      final Response response = await DioSingleton.instance.dio.post(
        Endpoints.notificationSettings(),
        data: bodyData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final dynamic responseData = response.data;

      log(
        'Post All Notification Setting Response: status=${response.statusCode}, data=$responseData',
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData is Map<String, dynamic>) {
        return NotificationSettingsModel.fromJson(responseData);
      }

      log(
        'Post All Notification API: Invalid response '
        'status=${response.statusCode}, data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Post All Notification API DioException: ${error.message}, response=${error.response?.data}',
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
        'Post All Notification API Unexpected Error: $error',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
