// // ignore_for_file: deprecated_member_use
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:stevenako_flutter/helpers/all_routes.dart';
// import 'package:stevenako_flutter/helpers/navigation_service.dart';
// import 'package:stevenako_flutter/networks/api_acess.dart';

// class CustomLogoutWidget extends StatefulWidget {
//   const CustomLogoutWidget({super.key});

//   @override
//   State<CustomLogoutWidget> createState() => _CustomLogoutWidgetState();
// }

// class _CustomLogoutWidgetState extends State<CustomLogoutWidget> {

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
//         decoration: BoxDecoration(
//           color: const Color(0xFF101B20), // Premium dark teal/gray dialog bg
//           borderRadius: BorderRadius.circular(24.r),
//           border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.w),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // ── Dialog Title ──
//             Text(
//               'Log Out',
//               style: GoogleFonts.inter(
//                 color: Colors.white,
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             SizedBox(height: 12.h),

//             // ── Subtitle ──
//             Text(
//               'Are you sure want to Log Out',
//               style: GoogleFonts.inter(
//                 color: Colors.white.withOpacity(0.55),
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             SizedBox(height: 28.h),

//             // ── Action Buttons ──
//             Row(
//               children: [
//                 // No Button
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context, false),
//                     child: Container(
//                       height: 48.h,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1E2830), // Dark action bg
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                       child: Text(
//                         "No",
//                         style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 14.w),

//                 // Yes Button
//                 Expanded(
//                   child: ValueListenableBuilder<bool>(
//                     valueListenable: logoutRxObj.isLoading,
//                     builder: (context, isLoading, child) {
//                       return GestureDetector(
//                         onTap: isLoading
//                             ? null
//                             : () async {
//                                 final success = await logoutRxObj.logOut();
//                                 if (success && context.mounted) {
//                                   Navigator.pop(context);
//                                   NavigationService.navigateToUntilReplacement(
//                                     Routes.welcomeScreen,
//                                   );
//                                 }
//                               },
//                         child: Container(
//                           height: 48.h,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFF4949), // Solid red color matching design mockup
//                             borderRadius: BorderRadius.circular(30.r),
//                           ),
//                           child: isLoading
//                               ? SizedBox(
//                                   width: 20.w,
//                                   height: 20.w,
//                                   child: const CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : Text(
//                                   "Yes",
//                                   style: GoogleFonts.inter(
//                                     color: Colors.white,
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
