import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/networks/stream_cleaner.dart';
import '/helpers/di.dart';
import '../../constants/app_constants.dart';
import '../endpoints.dart';
import 'log.dart';


final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static CancelToken cancelToken = CancelToken();
  DioSingleton._internal();

  static DioSingleton get instance => _singleton;

  late Dio dio;

  Dio _createDio(BaseOptions options) {
    final dio = Dio(options);
    dio.interceptors.addAll([
      Logger(),
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final requestPath = e.requestOptions.path;
            final isAuthRequest = requestPath.contains(Endpoints.login()) ||
                requestPath.contains(Endpoints.register()) ||
                requestPath.contains('login') ||
                requestPath.contains('register');

            if (!isAuthRequest) {
              // Clean dynamic/static data
              await totalDataClean();
              await appData.remove(kKeyAccessToken);

              // Redirect to welcome screen
              NavigationService.navigateToUntilReplacement(Routes.welcomeScreen);
            }
          }
          return handler.next(e);
        },
      ),
    ]);
    return dio;
  }

  void create() {
    final String? savedToken = appData.read(kKeyAccessToken);
    final Map<String, dynamic> headers = {
      NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
      NetworkConstants.ACCEPT_LANGUAGE: appData.read(kKeyCountryCode) ?? "pt",
      NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
    };

    if (savedToken != null && savedToken.toString().trim().isNotEmpty) {
      headers[NetworkConstants.AUTHORIZATION] = "Bearer ${savedToken.toString().trim()}";
    }

    BaseOptions options = BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(milliseconds: 100000), 
        receiveTimeout: const Duration(milliseconds: 100000),
        headers: headers);
    dio = _createDio(options);
  }

  void update(String auth) {
    if (kDebugMode) {
      print("Dio update");
    }
    BaseOptions options = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: appData.read(kKeyLanguage) ?? "pt",
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
        NetworkConstants.AUTHORIZATION: "Bearer $auth",
      },
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );
    dio = _createDio(options);
  }

  void updateLanguage(String countryCode) {
    if (kDebugMode) {
      print("Dio update $countryCode");
    }
    BaseOptions options = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: countryCode,
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
        NetworkConstants.AUTHORIZATION: "Bearer ${appData.read(kKeyAccessToken)} ",
      },
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );
    dio = _createDio(options);
  }
}

Future<Response> postHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.post(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> putHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.put(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> getHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.get(path, cancelToken: DioSingleton.cancelToken);

Future<Response> deleteHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.delete(path, data: data, cancelToken: DioSingleton.cancelToken);
