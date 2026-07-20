// import 'package:abojude_flutter/assets_helper/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CircularIconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   final int badgeCount;
//   final Color? iconColor;
//   final bool isFavorite;

//   const CircularIconBtn({
//     super.key,
//     required this.icon,
//     required this.onTap,
//     this.badgeCount = 0,
//     this.iconColor,
//     this.isFavorite = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 44.w,
//         height: 44.w,
//         decoration: BoxDecoration(
//           color: AppColor.bgColor,
//           borderRadius: BorderRadius.circular(100.r),
//           boxShadow: [
//             BoxShadow(
//               color: AppColor.blackColor.withOpacity(0.2),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Center(
//               child: Icon(
//                 icon,
//                 color: isFavorite
//                     ? Colors.red
//                     : iconColor ?? AppColor.textColor,
//                 size: 22.sp,
//               ),
//             ),
//             if (badgeCount > 0)
//               Positioned(
//                 top: -01.h,
//                 right: -01.w,
//                 child: Container(
//                   padding: EdgeInsets.all(4.w),
//                   decoration: const BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                   constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
//                   child: Center(
//                     child: Text(
//                       badgeCount.toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
