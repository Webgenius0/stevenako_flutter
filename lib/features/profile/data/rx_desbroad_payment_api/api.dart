import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/get_payment_dashboard_model.dart';

final class GetPaymentDashboardApi {
  static final GetPaymentDashboardApi _singleton =
      GetPaymentDashboardApi._internal();

  GetPaymentDashboardApi._internal();

  static GetPaymentDashboardApi get instance => _singleton;

  Future<GetPaymentDashboardModel> getDashboard({int? userId}) async {
    final String path = userId != null
        ? Endpoints.userPaymentDesbroad(userId)
        : "/user/creator/dashboard";

    final Response response = await getHttp(path);
    final dynamic responseData = response.data;

    if (response.statusCode != 200 && response.statusCode != 201) {
      if (responseData is Map<String, dynamic>) {
        throw Exception(
          responseData['message']?.toString() ??
              'Failed to fetch creator dashboard statistics.',
        );
      }
      throw Exception('Failed to fetch creator dashboard statistics.');
    }

    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format.');
    }

    return GetPaymentDashboardModel.fromJson(responseData);
  }
}
