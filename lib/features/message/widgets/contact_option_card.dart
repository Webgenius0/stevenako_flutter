import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactOptionCard extends StatelessWidget {
  final String name;
  final VoidCallback onDeleteTap;
  final VoidCallback onBlockTap;

  const ContactOptionCard({
    super.key,
    required this.name,
    required this.onDeleteTap,
    required this.onBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF27273A).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Action: Delete conversation
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              onTap: onDeleteTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
                child: Text(
                  'Delete this conversation',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFEE8E80), // warm coral text
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.white.withValues(alpha: 0.05),
          ),
          // Action: Block contact
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              onTap: onBlockTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
                child: Text(
                  'Block this Contact',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFEE8E80), // warm coral text
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
