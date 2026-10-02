import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/profile/payment/model/get_walit_model.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/features/profile/payment/top_up_stripe/presentation/stripe_checkout_webview_screen.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  int _selectedAmount = 20;
  bool _isCustomAmount = false;
  final TextEditingController _customAmountController = TextEditingController();
  bool _isProcessingTopUp = false;

  final List<int> _topUpAmounts = const [10, 20, 30, 40, 60, 80, 100];

  @override
  void initState() {
    super.initState();
    getWalletRxObj.getWallet();
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  int get _effectiveAmount {
    if (_isCustomAmount) {
      final parsed = int.tryParse(_customAmountController.text.trim());
      return (parsed != null && parsed > 0) ? parsed : 0;
    }
    return _selectedAmount;
  }

  void _handleTopUp() async {
    final amount = _effectiveAmount;
    if (amount <= 0) {
      ToastUtil.showShortToast('Please select or enter a valid amount');
      return;
    }

    setState(() {
      _isProcessingTopUp = true;
    });

    try {
      final response = await topUpStripeRxObj.createDeposit(
        amount: amount,
        successUrl: 'https://dashboard.realmworldapp.live/payment/success',
        cancelUrl: 'https://dashboard.realmworldapp.live/payment/cancel',
      );
      if (!mounted) return;

      final checkoutUrl = response?.data?.checkoutUrl;
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => StripeCheckoutWebViewScreen(
              checkoutUrl: checkoutUrl,
              successUrl: 'https://dashboard.realmworldapp.live/payment/success',
              cancelUrl: 'https://dashboard.realmworldapp.live/payment/cancel',
            ),
          ),
        );

        if (!mounted) return;

        if (result == true) {
          getWalletRxObj.getWallet();
          // Stripe webhooks can take 1-2 seconds to hit the backend and update the DB balance
          Future.delayed(const Duration(milliseconds: 2500), () {
            if (mounted) {
              getWalletRxObj.getWallet();
            }
          });
        } else if (result == false) {
          ToastUtil.showShortToast('Payment was cancelled');
          getWalletRxObj.getWallet();
        } else {
          // Closed without redirect event, refresh wallet just in case
          getWalletRxObj.getWallet();
        }
      }
    } catch (_) {
      if (mounted) {
        ToastUtil.showShortToast('Failed to initiate checkout. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingTopUp = false;
        });
      }
    }
  }

  void _handleWithdrawTap(BuildContext context, WalletInfo? wallet) {
    final stripeConnectId = wallet?.stripeConnectId;
    final isEligible = wallet?.isEligibleForWithdrawal == true;

    if (stripeConnectId == null || stripeConnectId.trim().isEmpty) {
      _showConnectStripeSheet(context);
      return;
    }

    if (!isEligible) {
      _showStripeVerificationDialog(
        context,
        message:
            'You must connect and complete verification of your Stripe bank account before requesting a withdrawal.',
      );
      return;
    }

    _showWithdrawBottomSheet(context, wallet);
  }

  String get _currencySymbol {
    final currency =
        getWalletRxObj.dataFetcher.valueOrNull?.data?.wallet?.currency ?? 'EUR';
    return currency == 'EUR' ? '€' : (currency == 'USD' ? '\$' : '$currency ');
  }

  Future<void> _startStripeConnectFlow(BuildContext context) async {
    BuildContext? dialogCtx;
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) {
        dialogCtx = loadingContext;
        return CupertinoAlertDialog(
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(),
                SizedBox(width: 12.w),
                Text(
                  'Connecting to Stripe...',
                  style: GoogleFonts.inter(fontSize: 13.5.sp),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final response = await postStripeConnectRxObj.createConnectAccount();
      if (dialogCtx != null && dialogCtx!.mounted) {
        Navigator.pop(dialogCtx!);
      }

      final url = response?.data?.url;
      if (url != null && url.isNotEmpty && context.mounted) {
        await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => StripeCheckoutWebViewScreen(
              checkoutUrl: url,
              title: 'Stripe Connect',
            ),
          ),
        );
        getWalletRxObj.getWallet();
      }
    } catch (_) {
      if (dialogCtx != null && dialogCtx!.mounted) {
        Navigator.pop(dialogCtx!);
      }
    }
  }

  void _showStripeVerificationDialog(
    BuildContext context, {
    String? message,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_shield_fill,
                  color: const Color(0xFFF59E0B),
                  size: 22.sp,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    'Stripe Verification Required',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  message ??
                      'You must connect and complete verification of your Stripe bank account before requesting a withdrawal.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: CupertinoColors.label.resolveFrom(dialogContext),
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6.resolveFrom(dialogContext),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: CupertinoColors.separator.resolveFrom(dialogContext),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('⚠️ ', style: TextStyle(fontSize: 12.sp)),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 11.5.sp,
                                  color: CupertinoColors.secondaryLabel
                                      .resolveFrom(dialogContext),
                                  height: 1.3,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Issue: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        'Your Stripe payout account or bank details have not completed verification.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('💡 ', style: TextStyle(fontSize: 12.sp)),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 11.5.sp,
                                  color: CupertinoColors.secondaryLabel
                                      .resolveFrom(dialogContext),
                                  height: 1.3,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Solution: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        'Complete the Stripe onboarding process to verify your bank account and receive withdrawals.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Later',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  color: CupertinoColors.secondaryLabel.resolveFrom(dialogContext),
                ),
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _startStripeConnectFlow(context);
              },
              child: Text(
                'Verify Stripe',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7C3AED),
                ),
              ),
            ),
          ],
        );
      },
    );
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
                              color:
                                  const Color(0xFF7C3AED).withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(sheetContext);
                                  _startStripeConnectFlow(context);
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

  void _showWithdrawBottomSheet(BuildContext context, WalletInfo? wallet) {
    final available = wallet?.availableBalance ?? 0;
    final currency = wallet?.currency ?? 'EUR';
    final symbol = currency == 'EUR'
        ? '€'
        : (currency == 'USD' ? '\$' : '$currency ');
    final TextEditingController amountController =
        TextEditingController(text: '50');
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
                            color:
                                const Color(0xFF7C3AED).withValues(alpha: 0.2),
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
                          color:
                              const Color(0xFF7C3AED).withValues(alpha: 0.25),
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
                          if (wallet?.stripeConnectId != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Builder(builder: (badgeContext) {
                                  final isVerified =
                                      wallet?.isEligibleForWithdrawal == true;
                                  return InkWell(
                                    onTap: isVerified
                                        ? null
                                        : () => _showStripeVerificationDialog(
                                              badgeContext,
                                              message:
                                                  'Your Stripe bank account requires verification before you can request withdrawals.',
                                            ),
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isVerified
                                            ? const Color(0xFF7C3AED)
                                                .withValues(alpha: 0.15)
                                            : const Color(0xFFF59E0B)
                                                .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isVerified
                                                ? Icons.check_circle_rounded
                                                : Icons.error_outline_rounded,
                                            color: isVerified
                                                ? Colors.greenAccent
                                                : const Color(0xFFF59E0B),
                                            size: 14.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            isVerified
                                                ? 'Connected'
                                                : 'Verify Account',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(width: 6.w),
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      disconnectStripeRxObj.isLoading,
                                  builder: (context, isDisconnecting, _) {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(8.r),
                                      onTap: isDisconnecting
                                          ? null
                                          : () async {
                                              final bool? confirm =
                                                  await showCupertinoDialog<bool>(
                                                context: context,
                                                builder: (dialogCtx) =>
                                                    CupertinoAlertDialog(
                                                  title: Text(
                                                    'Disconnect Stripe?',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.h),
                                                    child: Text(
                                                      'Are you sure you want to disconnect your Stripe Connect account? You will need to reconnect before withdrawing funds.',
                                                      style:
                                                          GoogleFonts.inter(
                                                        fontSize: 13.sp,
                                                        color: CupertinoColors
                                                            .label
                                                            .resolveFrom(
                                                                dialogCtx),
                                                        height: 1.35,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                                  dialogCtx)
                                                              .pop(false),
                                                      child: Text(
                                                        'Cancel',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 15.sp,
                                                          color:
                                                              CupertinoColors
                                                                  .secondaryLabel
                                                                  .resolveFrom(
                                                                      dialogCtx),
                                                        ),
                                                      ),
                                                    ),
                                                    CupertinoDialogAction(
                                                      isDestructiveAction:
                                                          true,
                                                      onPressed: () =>
                                                          Navigator.of(
                                                                  dialogCtx)
                                                              .pop(true),
                                                      child: Text(
                                                        'Disconnect',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              CupertinoColors
                                                                  .destructiveRed,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                final res =
                                                    await disconnectStripeRxObj
                                                        .disconnect();
                                                if (res != null) {
                                                  await getWalletRxObj
                                                      .getWallet();
                                                  if (sheetContext.mounted) {
                                                    Navigator.of(sheetContext)
                                                        .pop();
                                                  }
                                                }
                                              }
                                            },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: Colors.redAccent
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: isDisconnecting
                                            ? SizedBox(
                                                width: 12.r,
                                                height: 12.r,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.redAccent,
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  Icon(
                                                    Icons.link_off_rounded,
                                                    color: Colors.redAccent,
                                                    size: 13.sp,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    'Disconnect',
                                                    style: GoogleFonts.inter(
                                                      color: Colors.redAccent,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
                                    : const Color(0xFF27273A)
                                        .withValues(alpha: 0.5),
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
                                  : const Color(0xFF27273A)
                                      .withValues(alpha: 0.5),
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
                            color:
                                const Color(0xFF7C3AED).withValues(alpha: 0.3),
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
                                  color: const Color(0xFF7C3AED)
                                      .withValues(alpha: 0.35),
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
                                        getWalletRxObj.getWallet();
                                      } else if (creatorWithdrawRxObj
                                          .lastErrorIsStripeVerification) {
                                        if (sheetContext.mounted) {
                                          Navigator.pop(sheetContext);
                                        }
                                        if (mounted) {
                                          _showStripeVerificationDialog(
                                            this.context,
                                            message: creatorWithdrawRxObj
                                                .lastErrorMessage,
                                          );
                                        }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_upward_rounded,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          enteredAmount > 0
                                              ? 'Withdraw $symbol$enteredAmount'
                                              : 'Withdraw',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 14.5.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
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

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String amount,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1B192A),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Stack(
            children: [
              // --------------- Background Image ---------------
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),

              // --------------- Screen Layout ---------------
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Reusable Custom App Bar
                      const CustomAppBar(title: 'My Wallet'),

                      // Scrollable content with Pull-to-Refresh
                      Expanded(
                        child: RefreshIndicator(
                          color: const Color(0xFF9F75FF),
                          backgroundColor: const Color(0xFF1B182B),
                          onRefresh: () async {
                            await getWalletRxObj.getWallet();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),

                              // --------------- Wallet Card ---------------
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  image: const DecorationImage(
                                    image: AssetImage(AppImages.card),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                padding: EdgeInsets.all(24.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StreamBuilder<GetWalletModel>(
                                          stream: getWalletRxObj.stream,
                                          builder: (context, snapshot) {
                                            final wallet = snapshot.data?.data?.wallet;
                                            final currency = wallet?.currency ?? 'EUR';
                                            final symbol = currency == 'EUR' ? '€' : (currency == 'USD' ? '\$' : '$currency ');
                                            final balanceStr = wallet?.availableBalance != null
                                                ? '$symbol${wallet!.availableBalance}'
                                                : '€0.00';

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Available Balance',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white.withValues(
                                                      alpha: 0.7,
                                                    ),
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 6.h),
                                                Text(
                                                  balanceStr,
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize: 26.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                          onTap: () {
                                            final wallet = getWalletRxObj
                                                .dataFetcher
                                                .valueOrNull
                                                ?.data
                                                ?.wallet;
                                            _handleWithdrawTap(context, wallet);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 18.w,
                                              vertical: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                16.r,
                                              ),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.15,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Withdraw',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.6),
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  'Balance',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // --------------- Top Up Wallet Section ---------------
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  'Top Up Wallet',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),

                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20.r),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B192A),
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.r),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Icon(
                                            Icons.add_card_rounded,
                                            color: const Color(0xFFA78BFA),
                                            size: 22.sp,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Select Top-Up Amount',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                'Add funds to tip your favorite creators on Reels',
                                                style: GoogleFonts.inter(
                                                  color: const Color(0xFF94A3B8),
                                                  fontSize: 11.5.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 18.h),

                                    // Amount Buttons (10, 20, 30, 40, 60, 80, 100, Custom)
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final double itemWidth = (constraints.maxWidth - (3 * 10.w)) / 4;
                                        return Wrap(
                                          spacing: 10.w,
                                          runSpacing: 10.h,
                                          children: [
                                            ..._topUpAmounts.map((amount) {
                                              final isSelected = !_isCustomAmount && _selectedAmount == amount;
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isCustomAmount = false;
                                                    _selectedAmount = amount;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(milliseconds: 200),
                                                  width: itemWidth,
                                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                                  decoration: BoxDecoration(
                                                    gradient: isSelected
                                                        ? const LinearGradient(
                                                            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                          )
                                                        : null,
                                                    color: isSelected ? null : const Color(0xFF27273A),
                                                    borderRadius: BorderRadius.circular(14.r),
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? const Color(0xFFA78BFA)
                                                          : Colors.white.withValues(alpha: 0.08),
                                                      width: isSelected ? 1.5 : 1,
                                                    ),
                                                    boxShadow: isSelected
                                                        ? [
                                                            BoxShadow(
                                                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                                                              blurRadius: 8,
                                                              offset: const Offset(0, 2),
                                                            ),
                                                          ]
                                                        : [],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '$_currencySymbol$amount',
                                                    style: GoogleFonts.inter(
                                                      color: isSelected ? Colors.white : Colors.white70,
                                                      fontSize: 14.sp,
                                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                            // Custom Amount button
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isCustomAmount = true;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                width: itemWidth,
                                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  gradient: _isCustomAmount
                                                      ? const LinearGradient(
                                                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        )
                                                      : null,
                                                  color: _isCustomAmount ? null : const Color(0xFF27273A),
                                                  borderRadius: BorderRadius.circular(14.r),
                                                  border: Border.all(
                                                    color: _isCustomAmount
                                                        ? const Color(0xFFA78BFA)
                                                        : Colors.white.withValues(alpha: 0.08),
                                                    width: _isCustomAmount ? 1.5 : 1,
                                                  ),
                                                  boxShadow: _isCustomAmount
                                                      ? [
                                                          BoxShadow(
                                                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                                                            blurRadius: 8,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Custom',
                                                  style: GoogleFonts.inter(
                                                    color: _isCustomAmount ? Colors.white : Colors.white70,
                                                    fontSize: 12.sp,
                                                    fontWeight: _isCustomAmount ? FontWeight.w700 : FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),

                                    if (_isCustomAmount) ...[
                                      SizedBox(height: 14.h),
                                      TextFormField(
                                        controller: _customAmountController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        onChanged: (_) => setState(() {}),
                                        decoration: InputDecoration(
                                          prefixText: '$_currencySymbol ',
                                          prefixStyle: GoogleFonts.inter(
                                            color: const Color(0xFFA78BFA),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          hintText: 'Enter amount (e.g. 150)',
                                          hintStyle: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 13.sp,
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFF27273A),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 12.h,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14.r),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14.r),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF8B5CF6),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],

                                    SizedBox(height: 16.h),

                                    // Stripe security badge
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.lock_outline_rounded,
                                          color: const Color(0xFF94A3B8),
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          'Guaranteed safe & secure checkout via Stripe',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF94A3B8),
                                            fontSize: 11.5.sp,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 14.h),

                                    // Top Up Action Button
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
                                          onPressed: _isProcessingTopUp ? null : _handleTopUp,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14.r),
                                            ),
                                          ),
                                          child: _isProcessingTopUp
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
                                                      Icons.payment_rounded,
                                                      color: Colors.white,
                                                      size: 18.sp,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      _effectiveAmount > 0
                                                          ? 'Top Up $_currencySymbol$_effectiveAmount with Stripe'
                                                          : 'Top Up with Stripe',
                                                      style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 14.5.sp,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // --------------- Wallet Overview Section ---------------
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: StreamBuilder<GetWalletModel>(
                                  stream: getWalletRxObj.stream,
                                  builder: (context, snapshot) {
                                    final wallet = snapshot.data?.data?.wallet ??
                                        getWalletRxObj.dataFetcher.valueOrNull?.data?.wallet;
                                    final currency = wallet?.currency ?? 'EUR';
                                    final symbol = currency == 'EUR'
                                        ? '€'
                                        : (currency == 'USD' ? '\$' : '$currency ');

                                    final totalEarnings = wallet?.totalEarnings ?? 0;
                                    final viewsEarnings = wallet?.viewsEarnings ?? 0;
                                    final tipsEarnings = wallet?.tipsEarnings ?? 0;
                                    final withdrawnAmount = wallet?.withdrawnAmount ?? 0;
                                    final pendingAmount = wallet?.pendingWithdrawalAmount ?? 0;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Wallet Overview',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 9.w,
                                                vertical: 3.5.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF7C3AED)
                                                    .withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: const Color(0xFF9F75FF)
                                                      .withValues(alpha: 0.25),
                                                ),
                                              ),
                                              child: Text(
                                                currency,
                                                style: GoogleFonts.inter(
                                                  color: const Color(0xFF9F75FF),
                                                  fontSize: 11.5.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),

                                        // 2x2 Grid of stats
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildStatCard(
                                                icon: Icons.trending_up_rounded,
                                                iconColor: const Color(0xFF10B981),
                                                title: 'Total Earnings',
                                                amount: '$symbol$totalEarnings',
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: _buildStatCard(
                                                icon: Icons.favorite_rounded,
                                                iconColor: const Color(0xFFEC4899),
                                                title: 'Tips Earnings',
                                                amount: '$symbol$tipsEarnings',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildStatCard(
                                                icon: Icons.visibility_rounded,
                                                iconColor: const Color(0xFF38BDF8),
                                                title: 'Views Earnings',
                                                amount: '$symbol$viewsEarnings',
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: _buildStatCard(
                                                icon: Icons.outbox_rounded,
                                                iconColor: const Color(0xFFF59E0B),
                                                title: 'Withdrawn',
                                                amount: '$symbol$withdrawnAmount',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),

                                        // Pending Withdrawal Banner
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 12.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: pendingAmount > 0
                                                ? const Color(0xFFF59E0B)
                                                    .withValues(alpha: 0.12)
                                                : const Color(0xFF1B192A),
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            border: Border.all(
                                              color: pendingAmount > 0
                                                  ? const Color(0xFFF59E0B)
                                                      .withValues(alpha: 0.35)
                                                  : Colors.white
                                                      .withValues(alpha: 0.08),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(7.r),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF59E0B)
                                                      .withValues(alpha: 0.15),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.hourglass_top_rounded,
                                                  color: const Color(0xFFFBBF24),
                                                  size: 16.sp,
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Pending Withdrawal',
                                                      style: GoogleFonts.inter(
                                                        color: const Color(
                                                            0xFF94A3B8),
                                                        fontSize: 11.5.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.h),
                                                    Text(
                                                      '$symbol$pendingAmount',
                                                      style: GoogleFonts.inter(
                                                        color: pendingAmount > 0
                                                            ? const Color(
                                                                0xFFFBBF24)
                                                            : Colors.white,
                                                        fontSize: 14.5.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (pendingAmount > 0)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 4.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                            0xFFF59E0B)
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                  ),
                                                  child: Text(
                                                    'Processing',
                                                    style: GoogleFonts.inter(
                                                      color: const Color(
                                                          0xFFFBBF24),
                                                      fontSize: 10.5.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
