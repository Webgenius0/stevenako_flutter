import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/start_convergatosn_model.dart';
import '../../../networks/dio/dio.dart';
import '../../../networks/endpoints.dart';

final class PostStartConversationApi {
  static final PostStartConversationApi _singleton =
      PostStartConversationApi._internal();

  PostStartConversationApi._internal();

  static PostStartConversationApi get instance => _singleton;

  Future<PostStartConversationModel> startConversation({
    required dynamic receiverId,
  }) async {
    final FormData data = FormData.fromMap({
      'receiver_id': receiverId,
    });

    final Response response = await postHttp(
      Endpoints.startConversation(),
      data,
    );

    final dynamic responseData = response.data;

    if (response.statusCode != 200 && response.statusCode != 201) {
      if (responseData is Map<String, dynamic>) {
        throw Exception(
          responseData['message']?.toString() ??
              'Failed to start conversation.',
        );
      }
      throw Exception('Failed to start conversation.');
    }

    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format.');
    }

    return PostStartConversationModel.fromJson(responseData);
  }
}
