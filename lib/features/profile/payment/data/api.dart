import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/payment/model/get_walit_model.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class GetWalletApi {
  static final GetWalletApi _instance = GetWalletApi._internal();

  GetWalletApi._internal();

  static GetWalletApi get instance => _instance;

  Future<GetWalletModel> getWallet() async {
    try {
      final Response response = await getHttp(Endpoints.myWallet());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          response.data is String
              ? json.decode(response.data as String)
              : response.data as Map,
        );
        return GetWalletModel.fromJson(data);
      } else {
        throw Exception('Failed to load wallet details.');
      }
    } catch (error, stackTrace) {
      log('Get Wallet API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
