

// import 'package:abojude_flutter/assets_helper/app_colors.dart';
// import 'package:abojude_flutter/assets_helper/app_fonts.dart';
// import 'package:abojude_flutter/helpers/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class CustomSaveButton extends StatelessWidget {
//   final String btnText;
//   final String? icon;
//   final Color? btnColor;
//   final Color? txtColor;
//   final Color? borderColor;
//   final VoidCallback? onCall;

//   const CustomSaveButton({
//     super.key,
//     required this.btnText,
//     this.onCall,
//     this.btnColor,
//     this.borderColor,
//     this.txtColor,

//     this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onCall,
//       child: Container(
//         // height: 48.h,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           border: Border.all(color: borderColor ?? Colors.transparent),
//           borderRadius: BorderRadius.circular(100.r),
//           color: btnColor ?? AppColor.c2196F3,
//         ),

//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,

//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 if (icon != null) ...[
//                   SvgPicture.asset(icon!),
//                   UIHelper.horizontalSpace(12.w),
//                 ],
//                 Text(
//                   btnText,
//                   textAlign: TextAlign.center,
//                   style: TextFontStyle.textStyle16InterW600, 
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
