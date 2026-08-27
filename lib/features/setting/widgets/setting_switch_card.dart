import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingSwitchCard extends StatefulWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingSwitchCard({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SettingSwitchCard> createState() => _SettingSwitchCardState();
}

class _SettingSwitchCardState extends State<SettingSwitchCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: widget.value
                ? const Color(0xFF7C3AED).withValues(alpha: 0.12)
                : const Color(0xFF27273A).withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: widget.value
                  ? const Color(0xFF7C3AED).withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1.2,
            ),
            boxShadow: widget.value
                ? [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: CupertinoSwitch(
                      value: widget.value,
                      onChanged: widget.onChanged,
                      activeTrackColor: const Color(0xFF7C3AED),
                      inactiveTrackColor: const Color(0xFF3F3F56),
                      thumbColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                widget.description,
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
