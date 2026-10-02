import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeCheckoutWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final String? successUrl;
  final String? cancelUrl;
  final String? title;

  const StripeCheckoutWebViewScreen({
    super.key,
    required this.checkoutUrl,
    this.successUrl,
    this.cancelUrl,
    this.title,
  });

  @override
  State<StripeCheckoutWebViewScreen> createState() =>
      _StripeCheckoutWebViewScreenState();
}

class _StripeCheckoutWebViewScreenState
    extends State<StripeCheckoutWebViewScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _isLoading = true;
  bool _hasHandledResult = false;

  String get _targetSuccessUrl =>
      widget.successUrl ??
      'https://dashboard.realmworldapp.live/payment/success';

  String get _targetCancelUrl =>
      widget.cancelUrl ?? 'https://dashboard.realmworldapp.live/payment/cancel';

  bool _isSuccess(String url) {
    if (url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.contains('payment/success') ||
        lower.contains('return') ||
        lower.contains('setup_complete') ||
        lower.startsWith(_targetSuccessUrl.toLowerCase());
  }

  bool _isCancel(String url) {
    if (url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.contains('payment/cancel') ||
        lower.startsWith(_targetCancelUrl.toLowerCase());
  }

  void _onSuccessRedirect() {
    if (_hasHandledResult) return;
    _hasHandledResult = true;
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _onCancelRedirect() {
    if (_hasHandledResult) return;
    _hasHandledResult = true;
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _progress = progress;
                if (progress >= 100) {
                  _isLoading = false;
                }
              });
            }
          },
          onPageStarted: (String url) {
            if (_isSuccess(url)) {
              _onSuccessRedirect();
            } else if (_isCancel(url)) {
              _onCancelRedirect();
            } else if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (_isSuccess(url)) {
              _onSuccessRedirect();
            } else if (_isCancel(url)) {
              _onCancelRedirect();
            } else if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onUrlChange: (UrlChange change) {
            final url = change.url ?? '';
            if (_isSuccess(url)) {
              _onSuccessRedirect();
            } else if (_isCancel(url)) {
              _onCancelRedirect();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_isSuccess(request.url)) {
              _onSuccessRedirect();
              return NavigationDecision.prevent;
            }
            if (_isCancel(request.url)) {
              _onCancelRedirect();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  Future<bool> _showExitConfirmation() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1B182B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Cancel Payment?',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to leave the checkout? Your top up transaction will not be completed.',
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Continue Payment',
              style: GoogleFonts.inter(
                color: const Color(0xFF9F75FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Leave',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldLeave = await _showExitConfirmation();
        if (shouldLeave && mounted) {
          navigator.pop(false);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          body: SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(AppImages.bg, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Column(
                    children: [
                      // Top header with top SafeArea
                      SafeArea(
                        bottom: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              scrolledUnderElevation: 0,
                              centerTitle: true,
                              leading: IconButton(
                                onPressed: () async {
                                  final navigator = Navigator.of(context);
                                  final shouldLeave =
                                      await _showExitConfirmation();
                                  if (shouldLeave && mounted) {
                                    navigator.pop(false);
                                  }
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(6.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.lock_rounded,
                                        color: const Color(0xFF9F75FF),
                                        size: 15.sp,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        widget.title ?? 'Stripe Checkout',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '256-bit SSL Encrypted Payment',
                                    style: GoogleFonts.inter(
                                      color: Colors.white54,
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                      _progress = 0;
                                    });
                                    _controller.reload();
                                  },
                                  icon: Container(
                                    padding: EdgeInsets.all(6.r),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                  ),
                                  tooltip: 'Refresh page',
                                ),
                                SizedBox(width: 8.w),
                              ],
                            ),
                            // Loading progress bar
                            if (_isLoading || _progress < 100)
                              LinearProgressIndicator(
                                value: _progress > 0 ? _progress / 100 : null,
                                minHeight: 3.h,
                                backgroundColor: const Color(0xFF7C3AED)
                                    .withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF9F75FF),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // WebView container with bottom SafeArea to prevent bottom cutting
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: SafeArea(
                            top: false,
                            bottom: true,
                            child: Stack(
                              children: [
                                WebViewWidget(controller: _controller),
                                if (_isLoading)
                                  Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 36.r,
                                            height: 36.r,
                                            child:
                                                const CircularProgressIndicator(
                                              color: Color(0xFF7C3AED),
                                              strokeWidth: 3,
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Text(
                                            'Loading secure checkout...',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF1B182B),
                                              fontSize: 13.5.sp,
                                              fontWeight: FontWeight.w500,
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
                      ),
                    ],
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
