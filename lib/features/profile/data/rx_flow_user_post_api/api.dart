import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/model/post_flow_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class PostFlowApi {
  static final PostFlowApi _singleton = PostFlowApi._internal();

  PostFlowApi._internal();

  static PostFlowApi get instance => _singleton;

  Future<PostFlowModel> flow({
    required int userId,
  }) async {
    final FormData data = FormData.fromMap({});

    final Response response = await postHttp(
      Endpoints.postFlow(userId),
      data,
    );

    final dynamic responseData = response.data;

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      if (responseData is Map<String, dynamic>) {
        throw Exception(
          responseData['message']?.toString() ??
              'Post flow failed.',
        );
      }

      throw Exception('Post flow failed.');
    }

    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format.');
    }

    return PostFlowModel.fromJson(responseData);
  }
}