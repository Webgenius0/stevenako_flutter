import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/profile/payment/top_up_stripe/presentation/stripe_checkout_webview_screen.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import '../model/get_payment_dashboard_model.dart';

class DashboardTotalGift extends StatelessWidget {
  final TotalGift? totalGift;
  final StripeStatus? stripeStatus;
  final VoidCallback? onWithdrawSuccess;

  const DashboardTotalGift({
    super.key,
    this.totalGift,
    this.stripeStatus,
    this.onWithdrawSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final String amountStr = totalGift?.formatted ??
        (totalGift?.amount != null ? '€${totalGift!.amount}' : '€0');

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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ElevatedButton(
                  onPressed: () => _handleWithdrawTap(context),
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
                      color: Colors.white,
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

  void _handleWithdrawTap(BuildContext context) {
    final stripeConnectId = stripeStatus?.stripeConnectId;
    final isOnboarded = stripeStatus?.stripeOnboardingCompleted ?? false;

    if (stripeConnectId == null || stripeConnectId.trim().isEmpty || !isOnboarded) {
      _showConnectStripeSheet(context);
    } else {
      _showWithdrawBottomSheet(context);
    }
  }

  void _showConnectStripeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF1B182B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          bottom: true,
          child: ValueListenableBuilder<bool>(
            valueListenable: postStripeConnectRxObj.isLoading,
            builder: (context, isLoading, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance_rounded,
                        color: const Color(0xFF9F75FF),
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Connect Stripe Account',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'To withdraw your earnings directly to your bank account, please set up your Stripe Connect account.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF402380)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final response = await postStripeConnectRxObj
                                      .createConnectAccount();
                                  if (!sheetContext.mounted) return;

                                  final url = response?.data?.url;
                                  if (url != null && url.isNotEmpty) {
                                    Navigator.pop(sheetContext);
                                    await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            StripeCheckoutWebViewScreen(
                                          checkoutUrl: url,
                                          title: 'Stripe Connect',
                                        ),
                                      ),
                                    );
                                    onWithdrawSuccess?.call();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.open_in_new_rounded,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Set Up Stripe Connect',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showWithdrawBottomSheet(BuildContext context) {
    final num available = totalGift?.amount ?? 0;
    final String symbol = totalGift?.formattedEur != null
        ? '€'
        : (totalGift?.formatted?.startsWith('\$') == true ? '\$' : '€');
    final TextEditingController amountController = TextEditingController(
      text: available > 0
          ? (available >= 50 ? '50' : available.toString())
          : '10',
    );
    final List<num> presetWithdrawAmounts = [10, 20, 50, 100];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF1B182B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle Indicator
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Sheet Header
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.payments_rounded,
                              color: const Color(0xFF9F75FF),
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Withdraw Balance',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Transfer earnings to Stripe Connect',
                                style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Available Balance Banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27273A).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available Balance',
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '$symbol$available',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (stripeStatus?.stripeConnectId != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.greenAccent,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Connected',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Preset Amount Chips
                      Text(
                        'Select Amount',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ...presetWithdrawAmounts.map((amt) {
                            final isSelected =
                                amountController.text.trim() == amt.toString();
                            return InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () {
                                setSheetState(() {
                                  amountController.text = amt.toString();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF7C3AED)
                                      : const Color(0xFF27273A).withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF9F75FF)
                                        : Colors.white12,
                                  ),
                                ),
                                child: Text(
                                  '$symbol$amt',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                          InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              setSheetState(() {
                                amountController.text = available.toString();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: amountController.text.trim() ==
                                        available.toString()
                                    ? const Color(0xFF7C3AED)
                                    : const Color(0xFF27273A).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: amountController.text.trim() ==
                                          available.toString()
                                      ? const Color(0xFF9F75FF)
                                      : Colors.white12,
                                ),
                              ),
                              child: Text(
                                'All ($symbol$available)',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Custom Amount Text Field
                      Text(
                        'Or Enter Custom Amount',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (_) => setSheetState(() {}),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              const Color(0xFF27273A).withValues(alpha: 0.5),
                          prefixText: '$symbol ',
                          prefixStyle: GoogleFonts.inter(
                            color: const Color(0xFF9F75FF),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: '0.00',
                          hintStyle: GoogleFonts.inter(color: Colors.white24),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF9F75FF),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Submit Button
                      ValueListenableBuilder<bool>(
                        valueListenable: creatorWithdrawRxObj.isLoading,
                        builder: (context, isLoading, child) {
                          final enteredAmount =
                              num.tryParse(amountController.text.trim()) ?? 0;
                          return SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7C3AED), Color(0xFF402380)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (enteredAmount <= 0) {
                                          ToastUtil.showShortToast(
                                              'Please enter a valid amount');
                                          return;
                                        }
                                        if (enteredAmount > available) {
                                          ToastUtil.showShortToast(
                                              'Amount exceeds available balance ($symbol$available)');
                                          return;
                                        }

                                        final response =
                                            await creatorWithdrawRxObj
                                                .requestWithdrawal(
                                          amount: enteredAmount,
                                        );

                                        if (response?.success == true) {
                                          if (sheetContext.mounted) {
                                            Navigator.pop(sheetContext);
                                          }
                                          onWithdrawSuccess?.call();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.2,
                                        ),
                                      )
                                    : Text(
                                        enteredAmount > 0
                                            ? 'Withdraw $symbol$enteredAmount'
                                            : 'Withdraw',
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void _onBgImageError(Object exception, StackTrace? stackTrace) {}
}
