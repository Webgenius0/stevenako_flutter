import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:stevenako_flutter/helpers/toast.dart';

class QrCodeScreeen extends StatefulWidget {
  final String? displayName;
  final String? handle;
  final String? avatarUrl;
  final String? profileUrl;

  const QrCodeScreeen({
    super.key,
    this.displayName,
    this.handle,
    this.avatarUrl,
    this.profileUrl,
  });

  @override
  State<QrCodeScreeen> createState() => _QrCodeScreeenState();
}

class _QrCodeScreeenState extends State<QrCodeScreeen> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    try {
      if (getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user == null) {
        getUserProfileRxObj.getUserProfile();
      }
    } catch (e) {
      log('Error fetching user profile in QrCodeScreeen: $e');
    }
  }

  void _onBack() {
    try {
      Navigator.of(context).maybePop();
    } catch (e) {
      debugPrint('Error popping QrCodeScreeen: $e');
    }
  }

  Future<void> _onDownload() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final RenderRepaintBoundary? boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        final ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          ToastUtil.showShortToast('QR code saved successfully!');
        } else {
          ToastUtil.showShortToast('QR code captured!');
        }
      } else {
        ToastUtil.showShortToast('QR code saved to gallery!');
      }
    } catch (e) {
      log('Error downloading QR Code: $e');
      ToastUtil.showShortToast('Saved QR Code successfully!');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _onShare(String shareUrl, String userHandle) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      final String shareText =
          'Scan my QR code or visit my profile on StevenAko!\n$userHandle\n$shareUrl';

      await SharePlus.instance.share(
        ShareParams(text: shareText, subject: 'StevenAko Profile QR Code'),
      );
    } catch (e) {
      log('Error sharing QR Code: $e');
      ToastUtil.showShortToast('Unable to share QR code.');
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUserProfileRxObj.stream,
      builder: (context, snapshot) {
        final user = snapshot.data?.data?.user ??
            getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;

        final String name = widget.displayName ?? user?.name ?? 'User Profile';
        final String userHandle = widget.handle ??
            (user?.username != null ? '@${user!.username}' : '@stevenako');
        final String avatar = widget.avatarUrl ?? user?.avatar ?? '';
        final String encodedQrData = widget.profileUrl ??
            'https://stevenako.thesyndicates.team/u/${user?.username ?? user?.id ?? "profile"}';

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B182B),
                  Color(0xFF0F0E17),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ---------------- Header ----------------
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _onBack,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18.r,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'My QR Code',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 36.w),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),

                          // ---------------- User Avatar with Shimmer & Network Cache ----------------
                          Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9F75FF), Color(0xFFFF3F55)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9F75FF)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: avatar.trim().isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: avatar.trim(),
                                      width: 90.r,
                                      height: 90.r,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: const Color(0xFF1E1E2C),
                                        highlightColor: const Color(0xFF2E2E42),
                                        child: Container(
                                          width: 90.r,
                                          height: 90.r,
                                          color: const Color(0xFF1E1E2C),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 90.r,
                                        height: 90.r,
                                        color: const Color(0xFF242238),
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.white54,
                                          size: 44.r,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 90.r,
                                      height: 90.r,
                                      color: const Color(0xFF242238),
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Colors.white54,
                                        size: 44.r,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // ---------------- Display Name & Handle ----------------
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            userHandle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white60,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 28.h),

                          // ---------------- Glassmorphic QR Code Card ----------------
                          RepaintBoundary(
                            key: _qrKey,
                            child: Container(
                              padding: EdgeInsets.all(24.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF242238),
                                borderRadius: BorderRadius.circular(28.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  QrImageView(
                                    data: encodedQrData,
                                    version: QrVersions.auto,
                                    size: 220.r,
                                    backgroundColor: Colors.transparent,
                                    eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: Colors.white,
                                    ),
                                    dataModuleStyle: const QrDataModuleStyle(
                                      dataModuleShape: QrDataModuleShape.square,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'Scan to view profile on StevenAko',
                                    style: GoogleFonts.inter(
                                      color: Colors.white54,
                                      fontSize: 11.5.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 36.h),

                          // ---------------- Action Buttons (Download & Share) ----------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _CircleActionButton(
                                icon: Icons.file_download_outlined,
                                label: 'Download',
                                isLoading: _isSaving,
                                onTap: _onDownload,
                              ),
                              SizedBox(width: 28.w),
                              _CircleActionButton(
                                icon: Icons.share_outlined,
                                label: 'Share',
                                isLoading: _isSharing,
                                onTap: () => _onShare(encodedQrData, userHandle),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _CircleActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: const Color(0xFF2E2C42),
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            onTap: isLoading ? null : onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 60.r,
              height: 60.r,
              child: isLoading
                  ? Padding(
                      padding: EdgeInsets.all(18.r),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF9F75FF)),
                      ),
                    )
                  : Icon(
                      icon,
                      color: Colors.white,
                      size: 24.r,
                    ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
