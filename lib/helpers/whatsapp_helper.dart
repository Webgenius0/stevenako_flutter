// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<void> launchWhatsApp({
//   required BuildContext context,
//   String phoneNumber = "+8801789398972",
//   String message = "Hello, I'm interested in the opportunity.",
// }) async {
//   final whatsappUrl = Uri.parse(
//     "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}",
//   );
//   final webUrl = Uri.parse(
//     "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
//   );

//   try {
//     // Try WhatsApp app first
//     if (await canLaunchUrl(whatsappUrl)) {
//       await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
//     }
//     // Fallback to Web URL (wa.me)
//     else if (await canLaunchUrl(webUrl)) {
//       await launchUrl(webUrl, mode: LaunchMode.externalApplication);
//     }
//     // If canLaunchUrl still returns false, try launching webUrl anyway
//     else {
//       try {
//         await launchUrl(webUrl, mode: LaunchMode.externalApplication);
//       } catch (e) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Could not launch WhatsApp or Browser'),
//             ),
//           );
//         }
//       }
//     }
//   } catch (e) {
//     debugPrint("Error launching WhatsApp: $e");
//     if (context.mounted) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
//     }
//   }
// }
