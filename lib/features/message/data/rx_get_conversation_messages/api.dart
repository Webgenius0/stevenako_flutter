import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/conversation_details_model.dart';

final class GetConversationMessagesApi {
  static final GetConversationMessagesApi _instance =
      GetConversationMessagesApi._internal();

  GetConversationMessagesApi._internal();

  static GetConversationMessagesApi get instance => _instance;

  Future<ConversationDetailsModel> getConversationMessages(String cId) async {
    try {
      final Response response =
          await getHttp(Endpoints.conversationMessages(cId));
      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return ConversationDetailsModel.fromJson(responseData);
      }

      log(
        'Get Conversation Messages API: Invalid response '
        'status=${response.statusCode}, data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Get Conversation Messages API DioException: ${error.message}',
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
      log('Get Conversation Messages API Unexpected Error: $error',
          stackTrace: stackTrace);
      rethrow;
    }
  }
}
