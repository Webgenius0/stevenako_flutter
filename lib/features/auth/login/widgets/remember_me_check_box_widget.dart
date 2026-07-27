import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: value ? const Color(0xFF8B5CF6) : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: value
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF475569),
                width: 1.5.w,
              ),
            ),
            child: value
                ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            'Remember me',
            style: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}