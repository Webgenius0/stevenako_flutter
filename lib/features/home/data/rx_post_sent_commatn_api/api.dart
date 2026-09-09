import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/post_my_commants_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class PostCommantsApi {
  static final PostCommantsApi _singleton = PostCommantsApi._internal();

  PostCommantsApi._internal();

  static PostCommantsApi get instance => _singleton;

  Future<PostSentMyCommantsModel> sent({
    required int userId,
    required String content,
  }) async {
    final FormData data = FormData.fromMap({
      'content': content,
    });

    final Response response = await postHttp(
      Endpoints.pstSentCommants(userId),
      data,
    );

    final dynamic responseData = response.data;

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      if (responseData is Map<String, dynamic>) {
        throw Exception(
          responseData['message']?.toString() ??
              'Post comment failed.',
        );
      }

      throw Exception('Post comment failed.');
    }

    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format.');
    }

    return PostSentMyCommantsModel.fromJson(responseData);
  }
}