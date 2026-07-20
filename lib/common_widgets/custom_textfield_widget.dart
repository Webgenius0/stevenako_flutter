
// import 'package:abojude_flutter/assets_helper/app_colors.dart';
// import 'package:abojude_flutter/assets_helper/app_fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomTextfieldWidget extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final void Function()? iconOnTap;
//   final bool? enabled;
//   final bool isIcon;
//   final String? prefixText;
//   final bool showError;
//   final int maxLines;
//   final bool isPassword;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;

//   CustomTextfieldWidget({
//     Key? key,
//     required this.hintText,
//     required this.controller,
//     this.keyboardType,
//     this.validator,
//     this.isIcon = false,
//     this.iconOnTap,
//     this.enabled = true,
//     this.prefixText,
//     this.showError = true,
//     this.maxLines = 1,
//     this.isPassword = false,
//     this.suffixIcon,
//     this.prefixIcon,
//   }) : super(key: key);

//   @override
//   State<CustomTextfieldWidget> createState() => _CustomTextfieldWidgetState();
// }

// class _CustomTextfieldWidgetState extends State<CustomTextfieldWidget> {
//   bool _obscureText = true;

//   @override
//   void initState() {
//     super.initState();
//     _obscureText = widget.isPassword;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       validator: widget.validator,
//       enabled: widget.enabled,
//       obscureText: widget.isPassword ? _obscureText : false,
//       maxLines: widget.maxLines,
//       keyboardType: widget.keyboardType ?? TextInputType.text,
//       cursorColor: AppColor.c434344,
//       cursorRadius: const Radius.circular(8),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       textAlignVertical: TextAlignVertical.center,
//       style: TextFontStyle.textStyle13PoppinsW500.copyWith(
//         fontSize: 14.sp,
//         color: AppColor.cFFFFFF,
//         fontWeight: FontWeight.w400,
//       ),
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(
//             width: 1.w,
//             color: AppColor.c797A7C.withOpacity(0.5),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(
//             width: 1.w,
//             color: AppColor.c797A7C.withOpacity(0.5),
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(width: 1.w, color: AppColor.cB91C1C),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(width: 1.w, color: AppColor.cB91C1C),
//         ),
//         hintStyle: TextFontStyle.textStyle13PoppinsW500.copyWith( 
//           fontSize: 14.sp,
//           color: AppColor.c797A7C,
//           fontWeight: FontWeight.w400,
//         ),
//         hintText: widget.hintText,
//         isDense: true,
//         contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         errorStyle: widget.showError
//             ? null
//             : const TextStyle(height: 0, fontSize: 0),
//         prefixText: widget.prefixText,
//         prefixStyle: TextFontStyle.textStyle13PoppinsW500.copyWith(
//           fontSize: 14.sp,
//           color: AppColor.c797A7C,
//           fontWeight: FontWeight.w400,
//         ),
//         prefixIcon: widget.prefixIcon,
//         suffixIcon: widget.isPassword
//             ? GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _obscureText = !_obscureText;
//                   });
//                 },
//                 child: Icon(
//                   _obscureText
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   color: AppColor.c797A7C,
//                   size: 20.sp,
//                 ),
//               )
//             : widget.suffixIcon,
//       ),
//     );
//   }
// }
