
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stevenako_flutter/assets_helper/app_colors.dart';

Widget customButton({
  required String name,
  required VoidCallback onCallBack,
  required double height,
  required double minWidth,
  required double borderRadius,
  required Color color,
  required TextStyle textStyle,
  required BuildContext context,
  double ? width,
  Color? borderColor,
  double ? borderWidth,
  bool isSelected = false,
}) {
  return MaterialButton(
    onPressed: onCallBack,
    height: height,
    minWidth: minWidth,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: borderColor ?? AppColor.c182A24,  width: borderWidth ?? 1.5.sp),
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    color: isSelected ?  color : Colors.white,
    splashColor: Colors.white.withOpacity(0.4),
    child: Text(
      name,
      style: textStyle,
    ),
  );
}
