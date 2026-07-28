import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTabButton extends StatelessWidget {
  final int index;
  final int activeTab;
  final String assetPath;
  final ValueChanged<int> onTap;

  const ProfileTabButton({
    super.key,
    required this.index,
    required this.activeTab,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeTab == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          children: [
            Image.asset(
              assetPath,
              color: isActive ? const Color(0xFF9F75FF) : Colors.white60,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2.h,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF9F75FF),
                          Color.fromARGB(255, 62, 63, 121),
                        ],
                      )
                    : null,
                color: isActive ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
