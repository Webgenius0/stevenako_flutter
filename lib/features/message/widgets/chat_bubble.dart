import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
  });

  void _showDeleteOption(BuildContext context) {
    if (!isMe || onDelete == null) return;

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
                    'Delete Message',
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
        return _buildImageBubble();
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
                Icon(
                  Icons.done_all_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 14.sp,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // --------------- Image Attachment Bubble ---------------
  Widget _buildImageBubble() {
    final bool isNetwork = path != null && path!.startsWith('http');
    return Container(
      decoration: BoxDecoration(
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
            Container(
              constraints: BoxConstraints(maxWidth: 220.w, maxHeight: 180.h),
              child: isNetwork
                  ? CachedNetworkImage(
                      imageUrl: path!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 220.w,
                        height: 180.h,
                        color: Colors.grey[900],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 220.w,
                        height: 180.h,
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : (path != null
                        ? Image.file(File(path!), fit: BoxFit.cover)
                        : Container(
                            width: 220.w,
                            height: 180.h,
                            color: Colors.grey[900],
                            child: const Icon(
                              Icons.image,
                              color: Colors.white54,
                            ),
                          )),
            ),

            // Semi-transparent Overlay for Time & Checkmark
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              margin: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 9.sp,
                    ),
                  ),
                  if (isMe) ...[
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.done_all_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 12.sp,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
                Icon(
                  Icons.done_all_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 13.sp,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
