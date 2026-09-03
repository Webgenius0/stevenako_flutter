import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/message/presentation/conversation_screen.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class ProfileActionsRow extends StatelessWidget {
  final String? name;
  final String? avatarUrl;
  final int? targetUserId;
  final bool isMe;
  final VoidCallback? onSendMessage;

  const ProfileActionsRow({
    super.key,
    this.name,
    this.avatarUrl,
    this.targetUserId,
    this.isMe = true,
    this.onSendMessage,
  });

  void _handleStartConversation(BuildContext context) async {
    if (onSendMessage != null) {
      onSendMessage!();
      return;
    }

    if (targetUserId == null) return;

    final res = await postStartConversationRxObj.startConversation(
      receiverId: targetUserId!,
    );

    if (res != null && res.success == true && context.mounted) {
      final String? conversationId =
          res.data?.conversation?.id?.toString();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            name: name ?? 'User',
            avatarUrl: avatarUrl ?? '',
            conversationId: conversationId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          if (isMe) ...[
            // Dashboard Button
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
                    vertical: 12.h,
                    horizontal: 4.w,
                  ),
                  backgroundColor: Colors.transparent,
                ),
                icon: Image.asset(
                  'assets/images/dashboard.png',
                  height: 18.h,
                  width: 18.w,
                  fit: BoxFit.cover,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Edit Profile Button
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9F75FF),
                      Color(0xFF7C3AED),
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
                      vertical: 12.h,
                      horizontal: 4.w,
                    ),
                  ),
                  icon: Image.asset(
                    'assets/images/edit.png',
                    height: 18.h,
                    width: 18.w,
                    fit: BoxFit.cover,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            // Message Button for other users
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: postStartConversationRxObj.isLoading,
                builder: (context, isLoading, child) {
                  return OutlinedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => _handleStartConversation(context),
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
                        vertical: 12.h,
                        horizontal: 4.w,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    icon: isLoading
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Image.asset(
                            'assets/images/mesagenva.png',
                            height: 18.h,
                            width: 18.w,
                            color: Colors.white,
                            fit: BoxFit.contain,
                          ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Message',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
