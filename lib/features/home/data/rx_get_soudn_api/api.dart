import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/get_soudn_modle.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetSoundApi {
  static final GetSoundApi _singleton = GetSoundApi._internal();

  GetSoundApi._internal();

  static GetSoundApi get instance => _singleton;

  Future<GetuserModel> fetchSounds() async {
    try {
      final Response response = await getHttp(Endpoints.getSound());

      final res = response.data;

      if (res is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response.statusCode != 200) {
        throw Exception(res['message']?.toString() ?? 'Failed to fetch sounds');
      }

      return GetuserModel.fromJson(res);
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
