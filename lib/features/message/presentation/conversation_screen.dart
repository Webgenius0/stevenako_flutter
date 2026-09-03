import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';
import 'package:stevenako_flutter/features/message/model/conversation_details_model.dart';
import 'package:stevenako_flutter/features/message/widgets/chat_bubble.dart';
import 'package:stevenako_flutter/features/message/widgets/chat_input_bar.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/di.dart';
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

  PusherChannelsClient? _pusherClient;
  StreamSubscription? _pusherSubscription;
  StreamSubscription? _connectionSubscription;
  PrivateChannel? _myPrivateChannel;

  @override
  void initState() {
    super.initState();
    _sentMessages.clear();
    _checkBlockedStatus();
    if (widget.conversationId != null && widget.conversationId!.isNotEmpty) {
      getConversationMessagesRxObj.getConversationMessages(
        widget.conversationId!,
      );
      _initPusher();
    }
  }

  Future<void> _initPusher() async {
    if (widget.conversationId == null || widget.conversationId!.isEmpty) return;

    final String channelName = "private-chat.${widget.conversationId}";
    final String? token = appData.read(kKeyAccessToken);

    try {
      // 1. Define options
      final options = PusherChannelsOptions.fromHost(
        scheme: 'ws',
        host: 'stevenako.thesyndicates.team',
        key: 'stevenakoappkey12345',
        port: 8090,
        metadata: PusherChannelsOptionsMetadata.byDefault(),
      );

      // 2. Create client
      _pusherClient = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (exception, trace, refresh) {
          log("Pusher connection error: $exception");
          refresh(); // auto reconnect
        },
      );

      log('Conversation id: ${widget.conversationId}');

      // 3. Create a private channel
      _myPrivateChannel = _pusherClient?.privateChannel(
        channelName,
        authorizationDelegate:
            EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
              authorizationEndpoint: Uri.parse(
                "https://stevenako.thesyndicates.team/api/user/broadcasting/auth",
              ),
              headers: {
                "Authorization": "Bearer ${token ?? ''}",
                "Accept": "application/json",
              },
            ),
      );

      // 4. Bind to event
      _pusherSubscription = _myPrivateChannel?.bind('message.sent').listen((
        event,
      ) {
        log("Message received: ${event.data}");
        if (mounted &&
            widget.conversationId != null &&
            widget.conversationId!.isNotEmpty) {
          getConversationMessagesRxObj.getConversationMessages(
            widget.conversationId!,
          );
        }
      });

      // 5. Connect client
      _pusherClient?.connect();

      // 6. Auto-subscribe after connection established
      _connectionSubscription = _pusherClient?.onConnectionEstablished.listen((
        _,
      ) {
        log("Connection Established");
        _myPrivateChannel?.subscribeIfNotUnsubscribed();
        log("Successfully subscribed to private channel");
      });
    } catch (e, stack) {
      log("Pusher Initialization Error: $e", stackTrace: stack);
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


    // Generate a unique local ID for this message
    final int localId = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> tempMsg = {
      'localId': localId,
      'message': text,
      'time': DateFormat('HH:mm').format(DateTime.now()),
      'isMe': true,
      'type': type ?? 'text',
      'path': path,
      'fileName': fileName,
      'fileSize': fileSize,
      'isPending': true,
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
          final dynamic serverMsgData = res['data']?['message'];
          final dynamic serverId = serverMsgData?['id'];
          final String? mediaUrl = serverMsgData?['media_url']?.toString();

          setState(() {
            final idx = _sentMessages.indexWhere((m) => m['localId'] == localId);
            if (idx != -1) {
              _sentMessages[idx] = {
                ..._sentMessages[idx],
                'id': serverId ?? _sentMessages[idx]['id'],
                'path': (mediaUrl != null && mediaUrl.isNotEmpty)
                    ? mediaUrl
                    : _sentMessages[idx]['path'],
                'isPending': false,
              };
            }
          });
          // Silently refresh API data in background (will merge without jump)
          getConversationMessagesRxObj.getConversationMessages(
            widget.conversationId!,
          );
          getConversationListRxObj.getConversationList();
        }
      } else {
        // Mark as failed
        if (mounted) {
          setState(() {
            final idx = _sentMessages.indexWhere((m) => m['localId'] == localId);
            if (idx != -1) {
              _sentMessages[idx] = {
                ..._sentMessages[idx],
                'isPending': false,
                'isFailed': true,
              };
            }
          });
        }
      }
    }
  }

  void _showChatInfoDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E212D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: widget.avatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.avatarUrl,
                          width: 40.r,
                          height: 40.r,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF2A2A3C),
                            child: const Icon(Icons.person, color: Colors.white70),
                          ),
                        )
                      : Container(
                          color: const Color(0xFF2A2A3C),
                          child: const Icon(Icons.person, color: Colors.white70),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.isActive ? 'Active Now' : 'Offline',
                      style: GoogleFonts.inter(
                        color: widget.isActive
                            ? const Color(0xFF22C55E)
                            : const Color(0xFF9CA3AF),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Colors.white.withValues(alpha: 0.1)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person_outline_rounded,
                    color: Colors.white, size: 22.sp),
                title: Text(
                  'View Contact Info',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                  NavigationService.navigateTo(
                    Routes.contactInfoScreen,
                    arguments: {
                      'name': widget.name,
                      'avatarUrl': widget.avatarUrl,
                    },
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.flag_outlined,
                    color: const Color(0xFFEAB308), size: 22.sp),
                title: Text(
                  'Report User',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFEAB308),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                  NavigationService.navigateTo(
                    Routes.reportUserScreen,
                    arguments: {'name': widget.name},
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.block_rounded,
                    color: const Color(0xFFEF4444), size: 22.sp),
                title: Text(
                  'Block User',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFEF4444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _confirmBlockUser();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Colors.white60,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteMessage(String messageId, {bool isImage = false}) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(isImage ? 'Delete Image?' : 'Delete Message?'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              isImage
                  ? 'Are you sure you want to delete this image?'
                  : 'Are you sure you want to delete this message?',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(dialogContext);

                // Show Cupertino loading indicator dialog
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (loadingContext) {
                    return CupertinoAlertDialog(
                      content: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CupertinoActivityIndicator(),
                            SizedBox(width: 12.w),
                            Text(
                              isImage
                                  ? 'Deleting image...'
                                  : 'Deleting message...',
                              style: TextStyle(fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                try {
                  final res =
                      await deleteMessageRxObj.deleteMessage(messageId);
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
              child: const Text('Delete'),
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
    _disconnectPusher();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _disconnectPusher() async {
    try {
      await _pusherSubscription?.cancel();
      await _connectionSubscription?.cancel();
      _myPrivateChannel?.unsubscribe();
      await _pusherClient?.disconnect();
    } catch (e) {
      log("Pusher disconnect error: $e");
    }
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
                                width: 38.r,
                                height: 38.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: ClipOval(
                                  child: widget.avatarUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: widget.avatarUrl,
                                          width: 38.r,
                                          height: 38.r,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: const Color(0xFF2A2A3C),
                                            highlightColor:
                                                const Color(0xFF3F3F56),
                                            child: Container(
                                              width: 38.r,
                                              height: 38.r,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF2A2A3C),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                            width: 38.r,
                                            height: 38.r,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF2A2A3C),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.white70,
                                              size: 20,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 38.r,
                                          height: 38.r,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF2A2A3C),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white70,
                                            size: 20,
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
                              onPressed: _showChatInfoDialog,
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
                              return _buildChatShimmerLoading();
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
                                  ? DateFormat('HH:mm').format(msg.createdAt!.toLocal())
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

                             // Merge API messages with optimistic sent messages
                            final Set<dynamic> apiIds = {};
                            final Set<String> apiMediaUrls = {};
                            final Set<String> apiTexts = {};

                            for (var m in allMessages) {
                              if (m['id'] != null) apiIds.add(m['id']);
                              if (m['path'] != null) apiMediaUrls.add(m['path'].toString());
                              if (m['message'] != null &&
                                  m['message'].toString().trim().isNotEmpty) {
                                apiTexts.add(m['message'].toString().trim());
                              }
                            }

                            for (var sent in _sentMessages) {
                              // Always include pending (currently uploading) messages so shimmer is shown immediately
                              if (sent['isPending'] == true) {
                                allMessages.add(sent);
                                continue;
                              }

                              final sentId = sent['id'];
                              final sentPath = sent['path']?.toString();
                              final sentText = sent['message']?.toString().trim();

                              bool isAlreadyInApi = false;
                              if (sentId != null && apiIds.contains(sentId)) {
                                isAlreadyInApi = true;
                              } else if (sentPath != null && apiMediaUrls.contains(sentPath)) {
                                isAlreadyInApi = true;
                              } else if (sentText != null &&
                                  sentText.isNotEmpty &&
                                  apiTexts.contains(sentText)) {
                                isAlreadyInApi = true;
                              }

                              if (!isAlreadyInApi) {
                                allMessages.add(sent);
                              }
                            }

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
                                final msgType = msg['type'] ?? 'text';
                                final bool isImage = msgType == 'image';
                                return ChatBubble(
                                  message: msg['message'],
                                  time: msg['time'],
                                  isMe: isMe,
                                  avatarUrl: widget.avatarUrl,
                                  type: msgType,
                                  path: msg['path'],
                                  fileName: msg['fileName'],
                                  fileSize: msg['fileSize'],
                                  isPending: msg['isPending'] == true,
                                  isFailed: msg['isFailed'] == true,
                                  onDelete: isMe && messageId != null
                                      ? () => _confirmDeleteMessage(
                                          messageId.toString(),
                                          isImage: isImage,
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

  Widget _buildChatShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: 8,
      itemBuilder: (context, index) {
        final bool isMe = index % 3 != 0;
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFF222533),
            highlightColor: const Color(0xFF32364A),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe)
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                if (!isMe) SizedBox(width: 8.w),
                Container(
                  width: isMe ? 180.w : 200.w,
                  height: index % 2 == 0 ? 50.h : 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft:
                          isMe ? Radius.circular(16.r) : Radius.zero,
                      bottomRight:
                          isMe ? Radius.zero : Radius.circular(16.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
