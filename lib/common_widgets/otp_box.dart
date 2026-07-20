
// import 'package:abojude_flutter/assets_helper/app_colors.dart';
// import 'package:abojude_flutter/assets_helper/app_fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';


// class OTPBox extends StatelessWidget {
//   final TextEditingController controller;

//   const OTPBox({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56.h,
//       width: 71.8,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: AppColor.cEDEEF0,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: TextField(
//         controller: controller,
//         cursorColor: AppColor.c282828,
//         cursorRadius: Radius.circular(8.r),
//         cursorHeight: 20.h,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: TextFontStyle.textStyle24RobotoW600.copyWith(
//             fontWeight: FontWeight.w500,
//             fontSize: 18.sp,
//             letterSpacing: 0,
//             height: 1.5.h),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             FocusScope.of(context).nextFocus();
//           }
//         },
//       ),
//     );
//   }
// }
