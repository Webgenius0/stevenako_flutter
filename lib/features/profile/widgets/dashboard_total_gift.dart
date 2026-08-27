import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/get_payment_dashboard_model.dart';

class DashboardTotalGift extends StatelessWidget {
  final TotalGift? totalGift;
  final StripeStatus? stripeStatus;

  const DashboardTotalGift({
    super.key,
    this.totalGift,
    this.stripeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final String amountStr = totalGift?.formatted ??
        (totalGift?.amount != null ? '\$${totalGift!.amount}' : '\$0');

    final bool isEligible = stripeStatus?.isEligibleForWithdrawal ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF27273A).withValues(alpha: 0.6),
        image: const DecorationImage(
          image: AssetImage('assets/images/card_bg.png'),
          fit: BoxFit.cover,
          onError: _onBgImageError,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/gift.png',
                width: 18.w,
                height: 18.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.card_giftcard_rounded,
                  color: Colors.white70,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Total Gift',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amountStr,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 35.h,
                decoration: BoxDecoration(
                  gradient: isEligible
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white24,
                            Colors.white.withValues(alpha: 0.1),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ElevatedButton(
                  onPressed: isEligible
                      ? () {
                          // Trigger withdrawal
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 0.h,
                    ),
                  ),
                  child: Text(
                    'Withdraw',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isEligible ? Colors.white : Colors.white38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _onBgImageError(Object exception, StackTrace? stackTrace) {}
}
