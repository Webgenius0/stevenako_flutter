import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';

class ProfileAppBar extends StatelessWidget {
  final String name;
  final String balance;

  const ProfileAppBar({
    super.key,
    required this.name,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              // Wallet Balance Pill
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.myWalletScreen,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27273A).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/card_icon.png',
                        height: 16.h,
                        width: 16.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 1,
                        height: 12.h,
                        color: Colors.white24,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        balance,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Settings Gear Icon
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.settingScreen,
                  );
                },
                child: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
