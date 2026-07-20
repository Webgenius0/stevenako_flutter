
// import 'package:abojude_flutter/assets_helper/app_colors.dart';
// import 'package:abojude_flutter/assets_helper/app_fonts.dart';
// import 'package:abojude_flutter/helpers/toast.dart';
// import 'package:abojude_flutter/helpers/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class LanguageSelectionDialog extends StatelessWidget {
//   const LanguageSelectionDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final LanguageController languageController =
//     //     Get.find<LanguageController>();

//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       title: Text(
//         "Select Language",
//         textAlign: TextAlign.center,
//         style: TextFontStyle.textStyle13PoppinsW500.copyWith(
//           fontWeight: FontWeight.w600,
//           fontSize: 18.sp,
//           color: AppColor.c111827,
//         ),
//       ),
//       content: Obx(() => Container(
//             height: 45.h,
//             padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(100.r),
//               border: Border.all(
//                   color: AppColor.c266FEF.withOpacity(0.32), width: 2),
//             ),
//             child: Row(
//               children: [
//                 // English Button
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       // languageController.switchToEnglish();
//                       ToastUtil.showShortToast("English selected.");
//                     },
//                     child: Container(
//                       height: 35.h,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: AppColor.c2563EB,
//                         borderRadius: BorderRadius.circular(100.r),
//                       ),
//                       child: Text(
//                         "English",
//                         style: TextFontStyle.textStyle13PoppinsW500.copyWith(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12.sp,
//                           color: AppColor.cFFFFFF,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 UIHelper.horizontalSpace(4.w),

//                 // Bangla Button
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       // languageController.switchToBangla();
//                       ToastUtil.showShortToast("বাংলা নির্বাচন করা হয়েছে।");
//                     },
//                     child: Container(
//                       height: 35.h,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: AppColor.c2563EB,
//                         borderRadius: BorderRadius.circular(100.r),
//                       ),
//                       child: Text(
//                         "বাংলা",
//                         style: TextFontStyle.textStyle13PoppinsW500.copyWith(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12.sp,
//                           color: AppColor.cFFFFFF,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }
