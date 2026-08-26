import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/model/conversation_details_model.dart';
import 'package:stevenako_flutter/features/message/widgets/chat_bubble.dart';
import 'package:stevenako_flutter/features/message/widgets/chat_input_bar.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class ConversationScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final bool isActive;
  final String? conversationId;
  final String? userId;

  const ConversationScreen({
    super.key,
    required this.name,
    required this.avatarUrl,
    this.isActive = false,
    this.conversationId,
    this.userId,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final List<Map<String, dynamic>> _sentMessages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _sentMessages.clear();
    _checkBlockedStatus();
    if (widget.conversationId != null && widget.conversationId!.isNotEmpty) {
      getConversationMessagesRxObj.getConversationMessages(
        widget.conversationId!,
      );
    }
  }

  void _checkBlockedStatus() {
    if (getMyBlockedUsersRxObj.dataFetcher.hasValue) {
      final users = getMyBlockedUsersRxObj.dataFetcher.value.data?.users ?? [];
      final targetIdStr = widget.userId;
      if (targetIdStr != null && targetIdStr.isNotEmpty) {
        final targetId = int.tryParse(targetIdStr);
        if (targetId != null && users.any((u) => u.id == targetId)) {
          setState(() {
            _isBlocked = true;
          });
        }
      }
    }
  }

  void _sendMessage(
    String text, {
    String? type,
    String? path,
    String? fileName,
    String? fileSize,
  }) async {
    if (_isBlocked) {
      ToastUtil.showShortToast(
        'You have blocked this user. Unblock to send messages.',
      );
      return;
    }

    final Map<String, dynamic> tempMsg = {
      'message': text,
      'time': DateFormat('HH:mm').format(DateTime.now()),
      'isMe': true,
      'type': type ?? 'text',
      'path': path,
      'fileName': fileName,
      'fileSize': fileSize,
    };

    setState(() {
      _sentMessages.add(tempMsg);
    });

    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    if (widget.conversationId != null && widget.conversationId!.isNotEmpty) {
      File? file;
      if (path != null && path.isNotEmpty) {
        file = File(path);
      }

      final res = await postSendMessageRxObj.sendMessage(
        conversationId: widget.conversationId!,
        message: text,
        file: file,
      );

      if (res != null && res['success'] == true) {
        if (mounted) {
          setState(() {
            _sentMessages.remove(tempMsg);
          });
        }
        getConversationMessagesRxObj.getConversationMessages(
          widget.conversationId!,
        );
        getConversationListRxObj.getConversationList();
      }
    }
  }

  void _confirmDeleteMessage(String messageId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Delete Message?',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this message?',
            style: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontSize: 13.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                // Show loading indicator dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (loadingContext) {
                    return Dialog(
                      backgroundColor: const Color(0xFF1E1E2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                color: Color(0xFF7C3AED),
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              'Deleting message...',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                try {
                  final res = await deleteMessageRxObj.deleteMessage(messageId);
                  if (res != null && widget.conversationId != null) {
                    await getConversationMessagesRxObj.getConversationMessages(
                      widget.conversationId!,
                    );
                    getConversationListRxObj.getConversationList();
                  }
                } finally {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(
                'Delete',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmBlockUser() {
    String? targetUserId = widget.userId;

    if (targetUserId == null || targetUserId.isEmpty) {
      if (getConversationMessagesRxObj.dataFetcher.hasValue) {
        final messages =
            getConversationMessagesRxObj.dataFetcher.value.data?.messages ?? [];
        final currentUserId = getUserProfileRxObj.dataFetcher.hasValue
            ? getUserProfileRxObj.dataFetcher.value.data?.user?.id
            : null;
        for (var msg in messages) {
          if (msg.senderId != null && msg.senderId != currentUserId) {
            targetUserId = msg.senderId.toString();
            break;
          } else if (msg.sender?.id != null &&
              msg.sender?.name == widget.name) {
            targetUserId = msg.sender!.id.toString();
            break;
          }
        }
      }
    }

    if (targetUserId == null || targetUserId.isEmpty) {
      ToastUtil.showShortToast('Unable to identify user to block.');
      return;
    }

    final finalUserId = targetUserId;
    final bool willBlock = !_isBlocked;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            willBlock ? 'Block User?' : 'Unblock User?',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          content: Text(
            willBlock
                ? 'Are you sure you want to block ${widget.name}? You will no longer receive messages or notifications from this user.'
                : 'Are you sure you want to unblock ${widget.name}?',
            style: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontSize: 13.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: willBlock
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (loadingContext) {
                    return Dialog(
                      backgroundColor: const Color(0xFF1E1E2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                color: Color(0xFF7C3AED),
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              willBlock
                                  ? 'Blocking user...'
                                  : 'Unblocking user...',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                try {
                  final res = await postBlockUserRxObj.blockUser(finalUserId);
                  if (res != null) {
                    if (mounted) {
                      setState(() {
                        _isBlocked = willBlock;
                      });
                    }
                    getConversationListRxObj.getConversationList();
                    getMyBlockedUsersRxObj.getMyBlockedUsers();
                  }
                } finally {
                  if (mounted && Navigator.canPop(context)) {
                    Navigator.pop(context); // close loading dialog
                  }
                }
              },
              child: Text(
                willBlock ? 'Block' : 'Unblock',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),

              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            // Back Arrow Button
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 22.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),

                            // User Profile Avatar
                            GestureDetector(
                              onTap: () {
                                NavigationService.navigateTo(
                                  Routes.contactInfoScreen,
                                  arguments: {
                                    'name': widget.name,
                                    'avatarUrl': widget.avatarUrl,
                                  },
                                );
                              },
                              child: Container(
                                width: 38.w,
                                height: 38.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(19.r),
                                  child: Image.network(
                                    widget.avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[800],
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white70,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // User Info (Name & Active status)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      if (widget.isActive) ...[
                                        Text(
                                          'Active',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF22C55E),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          'Offline',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Info / Details Button
                            IconButton(
                              onPressed: _confirmBlockUser,
                              icon: Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --------------- Header Divider ---------------
                      Divider(
                        color: Colors.white.withValues(alpha: 0.08),
                        height: 1,
                      ),

                      // --------------- Message Bubbles List ---------------
                      Expanded(
                        child: StreamBuilder<ConversationDetailsModel>(
                          stream: getConversationMessagesRxObj.stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                !snapshot.hasData &&
                                widget.conversationId != null) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF7C3AED),
                                ),
                              );
                            }

                            final model = snapshot.data;
                            final apiMessages = model?.data?.messages ?? [];

                            final List<Map<String, dynamic>> allMessages = [];

                            final int? currentUserId =
                                getUserProfileRxObj.dataFetcher.hasValue
                                ? getUserProfileRxObj
                                      .dataFetcher
                                      .value
                                      .data
                                      ?.user
                                      ?.id
                                : null;

                            final Set<int> seenIds = {};
                            for (var msg in apiMessages) {
                              if (msg.id != null) {
                                if (seenIds.contains(msg.id)) continue;
                                seenIds.add(msg.id!);
                              }
                              final timeStr = msg.createdAt != null
                                  ? DateFormat('HH:mm').format(msg.createdAt!)
                                  : '';
                              bool isMe = false;
                              if (currentUserId != null &&
                                  msg.senderId != null) {
                                isMe = msg.senderId == currentUserId;
                              } else if (msg.sender?.name != null) {
                                isMe = msg.sender!.name != widget.name;
                              }

                              allMessages.add({
                                'id': msg.id,
                                'message': msg.message ?? '',
                                'time': timeStr,
                                'isMe': isMe,
                                'type': msg.type ?? 'text',
                                'path': msg.mediaUrl is String
                                    ? msg.mediaUrl
                                    : null,
                              });
                            }

                            allMessages.addAll(_sentMessages);

                            if (allMessages.isEmpty) {
                              return Center(
                                child: Text(
                                  'No messages yet',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF9CA3AF),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                );
                              }
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              itemCount: allMessages.length,
                              itemBuilder: (context, index) {
                                final msg = allMessages[index];
                                final bool isMe = msg['isMe'] == true;
                                final messageId = msg['id'];
                                return ChatBubble(
                                  message: msg['message'],
                                  time: msg['time'],
                                  isMe: isMe,
                                  avatarUrl: widget.avatarUrl,
                                  type: msg['type'] ?? 'text',
                                  path: msg['path'],
                                  fileName: msg['fileName'],
                                  fileSize: msg['fileSize'],
                                  onDelete: isMe && messageId != null
                                      ? () => _confirmDeleteMessage(
                                          messageId.toString(),
                                        )
                                      : null,
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // --------------- Bottom Input Field ---------------
                      if (_isBlocked)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 20.w,
                          ),
                          margin: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1E1E2E,
                            ).withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(
                                0xFFEF4444,
                              ).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'You have blocked this user.',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: _confirmBlockUser,
                                child: Text(
                                  'Unblock',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF7C3AED),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ChatInputBar(onSend: _sendMessage),
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
