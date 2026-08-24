import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/conversation_list_model.dart';

final class GetConversationListApi {
  static final GetConversationListApi _instance =
      GetConversationListApi._internal();

  GetConversationListApi._internal();

  static GetConversationListApi get instance => _instance;

  Future<ConversationListModel> getConversationList() async {
    try {
      final Response response = await getHttp(Endpoints.conversationList());
      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return ConversationListModel.fromJson(responseData);
      }

      log(
        'Get Conversation List API: Invalid response '
        'status=${response.statusCode}, data=$responseData',
      );

      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log(
        'Get Conversation List API DioException: ${error.message}',
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
      log('Get Conversation List API Unexpected Error: $error',
          stackTrace: stackTrace);
      rethrow;
    }
  }
}
