import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDangerous;

  const SettingsActionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isDangerous
        ? const Color(0xFF7F1D1D).withValues(alpha: 0.2)
        : const Color(0xFF27273A).withValues(alpha: 0.4);

    final Color borderColor = isDangerous
        ? const Color(0xFF7F1D1D).withValues(alpha: 0.4)
        : Colors.white.withValues(alpha: 0.05);

    final Color contentColor = isDangerous
        ? const Color(0xFFEE8E80)
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 18.h,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: contentColor,
                  size: 22.sp,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: contentColor,
                      fontSize: 15.sp,
                      fontWeight:
                          isDangerous ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
