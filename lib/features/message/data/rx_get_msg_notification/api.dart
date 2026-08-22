import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/msg_notification_model.dart';

final class GetMsgNotificationApi {
  static final GetMsgNotificationApi _instance = GetMsgNotificationApi._internal();

  GetMsgNotificationApi._internal();

  static GetMsgNotificationApi get instance => _instance;

  Future<MsgNotificationModel> getMsgNotification() async {
    try {
      final Response response = await getHttp(Endpoints.msgNotification());
      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return MsgNotificationModel.fromJson(responseData);
      }

      log(
        'Get Msg Notification API: Invalid response '
        'status=${response.statusCode}, data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Get Msg Notification API DioException: ${error.message}',
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
      log('Get Msg Notification API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
