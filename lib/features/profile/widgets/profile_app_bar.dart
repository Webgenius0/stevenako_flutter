import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/profile/payment/model/get_walit_model.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class ProfileAppBar extends StatelessWidget {
  final String name;
  final String? balance;
  final bool isMe;

  const ProfileAppBar({
    super.key,
    required this.name,
    this.balance,
    this.isMe = true,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Navigator.canPop(context)) ...[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
              Text(
                name,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (isMe) ...[
                // Wallet Balance Pill with real API data
                StreamBuilder<GetWalletModel>(
                  stream: getWalletRxObj.stream,
                  builder: (context, snapshot) {
                    final wallet = snapshot.data?.data?.wallet ??
                        getWalletRxObj.dataFetcher.valueOrNull?.data?.wallet;
                    final currency = wallet?.currency ?? 'EUR';
                    final symbol = currency == 'EUR'
                        ? '€'
                        : (currency == 'USD' ? '\$' : '$currency ');
                    final available = wallet?.availableBalance;

                    final String displayBalance;
                    if (balance != null && balance!.isNotEmpty) {
                      displayBalance = balance!;
                    } else if (available != null) {
                      if (available is int ||
                          available == available.roundToDouble()) {
                        displayBalance = '$symbol${available.toInt()}';
                      } else {
                        displayBalance =
                            '$symbol${available.toStringAsFixed(2)}';
                      }
                    } else {
                      displayBalance = '${symbol}0';
                    }

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          Routes.myWalletScreen,
                        );
                        getWalletRxObj.getWallet();
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
                              displayBalance,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
            ],
          ),
        ],
      ),
    );
  }
}
