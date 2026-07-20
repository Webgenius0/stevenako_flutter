// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:dio/dio.dart' as d;
// import 'package:url_launcher/url_launcher.dart';
// import '/helpers/di.dart';

// import '../networks/dio/log.dart';
// import '../provider/provides.dart';
// import 'navigation_service.dart';

// /* 
// required package:
// package_info_plus: ^1.0.6
// url_launcher: ^6.1.7  
// for ios:  
// add on info.plist
// <key>LSApplicationQueriesSchemes</key>
// <array>
//   <string>https</string>
// </array>
// for android:
// min app lvl build gradel:
// compileSdkVersion to 33
// targetSdkVersion to 33 
// */

// final class AutoAppUpdateUtil {
//   static final AutoAppUpdateUtil _autoAppUpdateUtil = AutoAppUpdateUtil._internal();
//   AutoAppUpdateUtil._internal();
//   static AutoAppUpdateUtil get instance => _autoAppUpdateUtil;

//   final String appName = const String.fromEnvironment("appName");
//   final String bearer = "3|SsmNks7qMYruzPyzsXNf48v4VEy1ChNNCye8MDGb";//const String.fromEnvironment("bearer");
//   final String appBundle = const String.fromEnvironment("appBundle");
//   final String environment = const String.fromEnvironment("environment");
//   final String baseURL = const String.fromEnvironment("baseURLUpdate");
//   final String endPoint = const String.fromEnvironment("endPointUpdate");

//   BuildContext context = NavigationService.context!;

//   checkAppUpdate() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String version = packageInfo.version;
//     String buildNo = packageInfo.buildNumber;
//     locator<GenericDi>().setAppVersion = version;
//     locator<GenericDi>().setBuildNo = buildNo;

//     var headers = {'Accept': 'application/json', 'Authorization': 'Bearer $bearer', 'Content-Type': 'application/json'};

//     Map<String, dynamic> body = {
//       "bundle_identifier": appBundle,
//       "app_version": version,
//       "platform": Platform.isAndroid ? "android" : "ios",
//       "environment": environment
//     };

//     d.Dio dio = d.Dio()..interceptors.add(Logger());

//     try {
//       d.Response response = await dio.get(
//         baseURL + endPoint,
//         queryParameters: body,
//         options: d.Options(headers: headers),
//       );
//       if (response.statusCode == 200) {
//         log(response.data.toString());
//         var decodedResponse = response.data;
//         if (decodedResponse['found'] == true) {
//           if (decodedResponse['upgrade'] == true) {
//             if (decodedResponse['forceUpgrade'] == true) {
//               showDialog(
//                   barrierDismissible: false,
//                   context: Get.context!,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text(
//                         "A new version of app is available".tr,
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xff999999),
//                         ),
//                       ),
//                       content: Text(
//                         decodedResponse['message'] ?? "",
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xff999999),
//                         ),
//                       ),
//                       actions: <Widget>[
//                         TextButton(
//                             child: Text('Update Now'.tr),
//                             onPressed: () {
//                               final Uri url = Uri.parse(decodedResponse['upgradeURL']);
//                               // ignore: use_build_context_synchronously
//                               launchUrl(url).then((value) => Navigator.of(context, rootNavigator: true).pop());
//                             })
//                       ],
//                     );
//                   });
//             } else {
//               showDialog(
//                   context: Get.context!,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text(
//                         "A new version of app is available".tr,
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xff999999),
//                         ),
//                       ),
//                       content: Text(
//                         decodedResponse['message'],
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xff999999),
//                         ),
//                       ),
//                       actions: <Widget>[
//                         TextButton(
//                             child: Text('Will Update Later'.tr),
//                             onPressed: () async {
//                               Navigator.of(context, rootNavigator: true).pop();
//                             }),
//                         TextButton(
//                             child: Text('Update Now'.tr),
//                             onPressed: () async {
//                               final Uri url = Uri.parse(decodedResponse['upgradeURL']);
//                               // ignore: use_build_context_synchronously
//                               launchUrl(url).then((value) => Navigator.of(context, rootNavigator: true).pop());
//                             })
//                       ],
//                     );
//                   });
//             }
//           }
//         }
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//   }
// }
