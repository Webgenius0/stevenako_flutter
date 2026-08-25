import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/get_tag_people_model.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class TagPeopleApi {
  static final TagPeopleApi _singleton = TagPeopleApi._internal();

  TagPeopleApi._internal();

  static TagPeopleApi get instance => _singleton;

  Future<GetTapPeopleModel> fetchTagPeople(String query) async {
    try {
      final Response response = await getHttp(Endpoints.tagPeople(query));

      final res = response.data;

      if (res is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response.statusCode != 200) {
        throw Exception(res['message']?.toString() ?? 'Failed to search people');
      }

      return GetTapPeopleModel.fromJson(res);
    } on DioException catch (e) {
      String message = 'Something went wrong';

      if (e.response?.data is Map<String, dynamic>) {
        message = e.response?.data['message']?.toString() ?? message;
      } else if (e.message != null) {
        message = e.message!;
      }

      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
