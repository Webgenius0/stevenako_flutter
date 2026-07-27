import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1E293B).withOpacity(0.4),
          border: Border.all(
            color: const Color(0xFF334155).withOpacity(0.5),
            width: 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(iconPath, width: 24.w, height: 24.w),
      ),
    );
  }
}
