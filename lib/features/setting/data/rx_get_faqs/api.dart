import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/faqs_model.dart';

final class GetFaqsApi {
  static final GetFaqsApi _instance = GetFaqsApi._internal();

  GetFaqsApi._internal();

  static GetFaqsApi get instance => _instance;

  Future<FaqsModel> getFaqs() async {
    try {
      final Response response = await getHttp(Endpoints.userFaqs());
      final dynamic responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return FaqsModel.fromJson(responseData);
      }

      log('Get Faqs API: Invalid response status=${response.statusCode}, data=$responseData');
      throw Exception('Invalid response from server.');
    } on DioException catch (error, stackTrace) {
      log('Get Faqs API DioException: ${error.message}', stackTrace: stackTrace);

      final dynamic responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final dynamic message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(error.message ?? 'Network error occurred.');
    } catch (error, stackTrace) {
      log('Get Faqs API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
