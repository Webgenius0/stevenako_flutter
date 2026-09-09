import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final String avatarUrl;
  final String type; // 'text' | 'image' | 'document'
  final String? path;
  final String? fileName;
  final String? fileSize;
  final VoidCallback? onDelete;
  final bool isPending;
  final bool isFailed;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    required this.avatarUrl,
    this.type = 'text',
    this.path,
    this.fileName,
    this.fileSize,
    this.onDelete,
    this.isPending = false,
    this.isFailed = false,
  });

  void _showDeleteOption(BuildContext context) {
    if (!isMe || onDelete == null) return;

    final String deleteText = type == 'image' ? 'Delete Image' : 'Delete Message';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFEF4444),
                  ),
                  title: Text(
                    deleteText,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete!();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // If incoming, show receiver's avatar next to the bubble
          if (!isMe) ...[
            Container(
              width: 32.w,
              height: 32.h,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],

          // Bubble Container
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showDeleteOption(context),
              child: _buildBubbleContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleContent(BuildContext context) {
    switch (type) {
      case 'image':
        return _buildImageBubble(context);
      case 'document':
        return _buildDocumentBubble();
      case 'text':
      default:
        return _buildTextBubble();
    }
  }

  // --------------- Text Message Bubble ---------------
  Widget _buildTextBubble() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFF7C3AED) // Outgoing purple bubble
            : const Color(
                0xFF1E1E2E,
              ).withValues(alpha: 0.6), // Incoming dark bubble
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
          bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
        ),
        border: isMe
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: GoogleFonts.inter(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.6)
                      : const Color(0xFF6B7280),
                  fontSize: 10.sp,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                _buildDeliveryIcon(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // --------------- Image Attachment Bubble ---------------
  Widget _buildImageBubble(BuildContext context) {
    final bool isNetwork = path != null && path!.startsWith('http');

    // If message is still uploading (isPending == true), show pure Shimmer Skeleton Card
    if (isPending) {
      return Container(
        width: 220.w,
        height: 160.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
            bottomLeft: isMe ? Radius.circular(15.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(15.r),
          ),
          child: Stack(
            children: [
              // Full Card Pure Shimmer Wave Animation
              Positioned.fill(
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFF1F2232),
                  highlightColor: const Color(0xFF383D59),
                  child: Container(
                    width: 220.w,
                    height: 160.h,
                    color: Colors.white,
                  ),
                ),
              ),

              // Center Uploading Pill Badge
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload_rounded,
                        color: const Color(0xFF9D65FF),
                        size: 18.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Uploading image...',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Right Time & Clock Indicator
              Positioned(
                bottom: 8.r,
                right: 8.r,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 9.5.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      _buildDeliveryIcon(size: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Confirmed Loaded Image View
    return GestureDetector(
      onTap: () => _openFullScreenImage(context, path),
      child: Container(
        width: 220.w,
        height: 160.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
            bottomLeft: isMe ? Radius.circular(15.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(15.r),
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              // The Image
              Positioned.fill(
                child: isNetwork
                    ? CachedNetworkImage(
                        imageUrl: path!,
                        width: 220.w,
                        height: 160.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: const Color(0xFF222533),
                          highlightColor: const Color(0xFF32364A),
                          child: Container(
                            width: 220.w,
                            height: 160.h,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 220.w,
                          height: 160.h,
                          color: const Color(0xFF222533),
                          child: const Icon(
                            Icons.broken_image_rounded,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    : (path != null && File(path!).existsSync()
                        ? Image.file(
                            File(path!),
                            width: 220.w,
                            height: 160.h,
                            fit: BoxFit.cover,
                          )
                        : Shimmer.fromColors(
                            baseColor: const Color(0xFF222533),
                            highlightColor: const Color(0xFF32364A),
                            child: Container(
                              width: 220.w,
                              height: 160.h,
                              color: Colors.white,
                            ),
                          )),
              ),

              // Semi-transparent Overlay for Time & Checkmark
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 9.5.sp,
                      ),
                    ),
                    if (isMe) ...[
                      SizedBox(width: 4.w),
                      _buildDeliveryIcon(size: 12),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullScreenImage(BuildContext context, String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, secondaryAnimation) {
          final bool isNetwork = imagePath.startsWith('http');
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Edge-to-Edge Interactive Full Screen Image Container
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: Center(
                      child: isNetwork
                          ? CachedNetworkImage(
                              imageUrl: imagePath,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => Center(
                                child: Shimmer.fromColors(
                                  baseColor: const Color(0xFF222533),
                                  highlightColor: const Color(0xFF32364A),
                                  child: Container(
                                    width: double.infinity,
                                    height: 300.h,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.broken_image_rounded,
                                color: Colors.white54,
                                size: 64,
                              ),
                            )
                          : (File(imagePath).existsSync()
                              ? Image.file(
                                  File(imagePath),
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : const Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.white54,
                                  size: 64,
                                )),
                    ),
                  ),
                ),

                // Top Floating AppBar with Back & Close Button
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      color: Colors.black.withValues(alpha: 0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                          Text(
                            'Photo',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --------------- Document Attachment Bubble ---------------
  Widget _buildDocumentBubble() {
    final String displayName = fileName ?? 'Document';
    final String displaySize = fileSize ?? 'Unknown size';
    final bool isPdf = displayName.toLowerCase().endsWith('.pdf');

    return Container(
      width: 230.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFF7C3AED) // Outgoing purple bubble
            : const Color(
                0xFF1E1E2E,
              ).withValues(alpha: 0.6), // Incoming dark bubble
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
          bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
        ),
        border: isMe
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // File Icon Background
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.15)
                      : const Color(0xFF7C3AED).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  isPdf
                      ? Icons.picture_as_pdf_rounded
                      : Icons.description_rounded,
                  color: isMe ? Colors.white : const Color(0xFF8B5CF6),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),

              // File Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      displaySize,
                      style: GoogleFonts.inter(
                        color: isMe
                            ? Colors.white.withValues(alpha: 0.6)
                            : const Color(0xFF9CA3AF),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),

              // Open / Action Icon
              Icon(
                Icons.open_in_new_rounded,
                color: Colors.white.withValues(alpha: 0.7),
                size: 16.sp,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                time,
                style: GoogleFonts.inter(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.6)
                      : const Color(0xFF6B7280),
                  fontSize: 9.sp,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                _buildDeliveryIcon(size: 13),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// WhatsApp-style delivery status icon
  Widget _buildDeliveryIcon({double size = 14}) {
    if (isPending) {
      return Icon(
        Icons.access_time_rounded,
        color: Colors.white.withValues(alpha: 0.5),
        size: size.sp,
      );
    }
    if (isFailed) {
      return Icon(
        Icons.error_outline_rounded,
        color: const Color(0xFFEF4444),
        size: size.sp,
      );
    }
    return Icon(
      Icons.done_all_rounded,
      color: Colors.white.withValues(alpha: 0.8),
      size: size.sp,
    );
  }
}
