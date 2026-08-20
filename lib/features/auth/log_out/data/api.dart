

import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';


class LogoutApi {
  static final LogoutApi _singleton = LogoutApi._internal();
  LogoutApi._internal();
  static LogoutApi get instance => _singleton;

  Future<Map<String, dynamic>> logoutFun() async {
    try {
      Response response = await postHttp(Endpoints.logout());
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(json.encode(response.data)));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}