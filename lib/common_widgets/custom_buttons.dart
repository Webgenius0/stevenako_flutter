// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomButtons extends StatelessWidget {
//   CustomButtons({
//     super.key,
//     required this.name,
//     required this.bgColor,
//     this.textColor,
//     required this.callback,
//     this.borderColor,
//     this.textStyle,
//     this.isLoading = false,
//   });
//   final String name;
//   final Color bgColor;
//   final Color? textColor;
//   final VoidCallback callback;
//   final Color? borderColor;
//   TextStyle? textStyle;
//   final bool isLoading;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : callback,
//       child: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(100.r),
//           color: bgColor,
//           border: Border.all(
//             width: 1,
//             color: borderColor ?? Colors.transparent,
//           ),
//         ),
//         child: Center(
//           child: isLoading
//               ? SizedBox(
//                   height: 20.h,
//                   width: 20.h,
//                   child: CircularProgressIndicator(
//                     color: textColor ?? Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 )
//               : Text(name, style: textStyle),
//         ),
//       ),
//     );
//   }
// }
