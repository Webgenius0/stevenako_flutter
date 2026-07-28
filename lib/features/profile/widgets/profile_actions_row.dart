import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';

class ProfileActionsRow extends StatelessWidget {
  const ProfileActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.dashboardScreen,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.15,
                  ),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30.r,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 14.h,
                ),
                backgroundColor: Colors.transparent,
              ),
              icon: Image.asset(
                'assets/images/dashboard.png',
                height: 20.h,
                width: 20.w,
                fit: BoxFit.cover,
              ),
              label: Text(
                'Dashboard',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(
                      0xFF9F75FF,
                    ), // Lighter purple
                    Color(0xFF7C3AED), // Rich purple
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  30.r,
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editProfileScreen,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                  ),
                ),
                icon: Image.asset(
                  'assets/images/edit.png',
                  height: 20.h,
                  width: 20.w,
                  fit: BoxFit.cover,
                ),
                label: Text(
                  'Edit Profile',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
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
