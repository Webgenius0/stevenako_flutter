import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/notification_settings_model.dart';

final class PostNotificationSettingsApi {
  static final PostNotificationSettingsApi _instance =
      PostNotificationSettingsApi._internal();

  PostNotificationSettingsApi._internal();

  static PostNotificationSettingsApi get instance => _instance;

  Future<NotificationSettingsModel> postNotificationSettings({
    required bool chatManage,
    required bool photoVideoUpdate,
    required bool settingsUpdate,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        'chat_manage': chatManage,
        'photo_video_update': photoVideoUpdate,
        'settings_update': settingsUpdate,
      };

      log('Posting Notification Settings: $bodyData');

      final Response response = await DioSingleton.instance.dio.post(
        Endpoints.notificationSettings(),
        data: bodyData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final dynamic responseData = response.data;

      log(
        'Post Notification Settings Response: status=${response.statusCode}, data=$responseData',
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData is Map<String, dynamic>) {
        return NotificationSettingsModel.fromJson(responseData);
      }

      log(
        'Post Notification Settings API: Invalid response '
        'status=${response.statusCode}, data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Post Notification Settings API DioException: ${error.message}, response=${error.response?.data}',
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
        'Post Notification Settings API Unexpected Error: $error',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
