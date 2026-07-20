
// import 'package:abojude_flutter/assets_helper/app_colors.dart';
// import 'package:abojude_flutter/common_widgets/custom_back_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomAppbar extends StatefulWidget {
//   final String title;
//   final Widget? trailing; 
//   final void Function()? onTap;

//   CustomAppbar({super.key, this.onTap, required this.title, this.trailing});

//   @override
//   State<CustomAppbar> createState() => _CustomAppbarState();
// }

// class _CustomAppbarState extends State<CustomAppbar> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 0.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               CustomBackButton(onTap: widget.onTap),

//               SizedBox(width: 12.w),
//               Text(
//                 widget.title,
//                 style: TextStyle(
//                   color: AppColor.textColor,
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           widget.trailing ?? const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }
