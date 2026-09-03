// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

String get url =>
    dotenv.env['BASE_URL'] ?? "https://stevenako.thesyndicates.team/api";
String get imageUrl => url;

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();

  // -------------------Register start-------------------
  static String register() => "/user/register";
  // -------------------Register end-------------------

  // -------------------Register Verify email start-----------------
  static String registerVerifyOtp() => "/user/verify-otp";
  // -------------------Register Verify email end-------------------

  // -------------------Get Province List start-----------------
  static String getProvinceList() => "/v1/locations/provinces";
  // -------------------Get Province List end-------------------

  // -------------------Get Cities List start-----------------
  static String getCitiesList(String province) =>
      "/v1/locations/provinces/$province/cities";
  // -------------------Get Cities List end-------------------

  // -------------------Select Location auth user start-----------------
  static String selectLocationForAuthUser() => "/v1/locations/select";
  // -------------------Select Location auth user end-------------------

  // -------------------Guest user location start-----------------
  static String guestUserLocation() => "/v1/guest/location";
  // -------------------Guest user location end-------------------

  // -------------------Login start-------------------
  static String login() => "/user/login";
  // -------------------Login end-------------------

  // -------------------Logout start-------------------
  static String logout() => "/user/logout";
  // -------------------Logout end-------------------

  // -------------------Delete Account start-------------------
  static String deleteAccount() => "/v1/auth/delete-account";
  // -------------------Delete Account end-------------------

  // -------------------Forget Password start-------------------
  static String forgetPassword() => "/user/forget-password";
  // -------------------Forget Password end-------------------

  // -------------------Set New Password start-------------------
  static String setNewPassword() => "/user/reset-password";
  // -------------------Set New Password end-------------------

  // -------------------Forget Password verify otp start-------------------
  static String forgetPasswordVerifyOtp() => "/user/verify-otp";
  // -------------------Forget Password verify otp end-------------------

  // -------------------Resend Otp start-------------------
  static String resendOtp() => "/v1/resend-otp";
  // -------------------Resend Otp end-------------------

  // ------------------- GetCategoryList start-------------------
  static String getCategoryList() => "/v1/categories";
  // -------------------GetCategoryList end-------------------

  // ------------------- GetRecentPostList start-------------------
  static String getRecentPostList() => "/v1/posts/recent";
  // -------------------GetRecentPostList end-------------------

  // ------------------- GetProfile start-------------------
  static String getProfile() => "/v1/auth/profile";
  static String userData(dynamic id) => "/user/$id";

  static String setProfile() => "/user/account/update";
  // -------------------GetProfile end-------------------
  static String getPostList({
    required int page ,
    required int perPage ,
  }) => "/user/posts-text?page=$page&per_page=$perPage";

  static String getAllCommants(dynamic id) => "/user/posts/$id";
  static String pstSentCommants(dynamic id) => "/user/posts/$id/comment";
  // static String getPhotoList() => "/user/posts-photos";
  static String getPhotoList({
    required int page ,
    required int perPage ,
  }) => "/user/posts-photos?page=$page&per_page=$perPage";

  static String getMessageList() => "/user/conversations";
  static String changePassword() => "/user/change-password";
  static String userFaqs() => "/user/faqs";
  static String msgNotification() => "/my-notifications";
  static String notificationSettings() => "/notification-settings";
  static String deleteUser() => "/user/delete/user";
  static String startConversation() => "/user/conversations";
  static String userProfile() => "/user/me";
  static String userinfo(int id) => "/user/$id";
  static String userPostLike(dynamic id) => "/user/posts/$id/like";
  static String userCommentLike(dynamic id) => "/user/comments/$id/like";
  static String userComment(dynamic id) => "/user/comments/$id";
  static String tagPeople(String query) =>
      "/user/search?query=${Uri.encodeQueryComponent(query)}";
  static String userPost() => "/user/posts";
  static String myPhotoPost() => "/user/my-posts-photos";
  static String myVideoPost() => "/user/my-posts-videos";
  static String myTextPost() => "/user/my-posts-text";
  static String postFlow(int userId) => "/user/follow/$userId";
  static String userPaymentDesbroad(int userId) => "/user/creator/dashboard";
  static String getSound() => "/user/sounds";
  static String myBlockedUsers() => "/user/my-blocked";
  static String blockOrUnblockUser(String userId) => "/user/block/$userId";
  static String reportUser(String userId) => "/user/report/$userId";
  static String conversationList() => "/user/conversations";
  static String conversationMessages(String cId) =>
      "/user/conversations/$cId/messages";
  static String deleteMessage(String messageId) =>
      "/user/conversations/messages/$messageId";
  static String blockUser(String userId) => "/user/block/$userId";

  // ------------------- Mentors details start-------------------
  // static String getRealsVideoAll([String? mentorId]) {
  //   if (mentorId != null && mentorId.isNotEmpty) {
  //     return "/user/posts-videos?mentor_id=$mentorId";
  //   }
  //   return "/user/posts-videos";
  // }

  static String getRealsVideoAll({
    int page = 1,
    int? perPage,
    String? mentorId,
  }) {
    final List<String> queryParams = ['page=$page'];

    if (perPage != null) {
      queryParams.add('per_page=$perPage');
    }

    if (mentorId != null && mentorId.trim().isNotEmpty) {
      queryParams.add('mentor_id=${mentorId.trim()}');
    }

    return "/user/posts-videos?${queryParams.join('&')}";
  }
  //   // -------------------delete farmer end-------------------
}
