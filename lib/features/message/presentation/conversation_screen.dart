import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/chat_bubble.dart';
import 'package:stevenako_flutter/features/message/widgets/chat_input_bar.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class ConversationScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final bool isActive;

  const ConversationScreen({
    super.key,
    required this.name,
    required this.avatarUrl,
    this.isActive = false,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // Chat History state containing initial messages shown in the mockup
  final List<Map<String, dynamic>> _messages = [
    {
      'message':
          'Good, I\'ll see you tonight. Don\'t forget, now, 1:15 a.m., Twin Pines Mall.',
      'time': '08:23',
      'isMe': false,
      'type': 'text',
    },
    {'message': 'Right.', 'time': '08:24', 'isMe': true, 'type': 'text'},
  ];

  final ScrollController _scrollController = ScrollController();

  void _sendMessage(
    String text, {
    String? type,
    String? path,
    String? fileName,
    String? fileSize,
  }) {
    setState(() {
      _messages.add({
        'message': text,
        'time': DateFormat('HH:mm').format(DateTime.now()),
        'isMe': true,
        'type': type ?? 'text',
        'path': path,
        'fileName': fileName,
        'fileSize': fileSize,
      });
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
                              onPressed: () {
                                // Action handler for chat detail/info
                              },
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
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return ChatBubble(
                              message: msg['message'],
                              time: msg['time'],
                              isMe: msg['isMe'],
                              avatarUrl: widget.avatarUrl,
                              type: msg['type'] ?? 'text',
                              path: msg['path'],
                              fileName: msg['fileName'],
                              fileSize: msg['fileSize'],
                            );
                          },
                        ),
                      ),

                      // --------------- Bottom Input Field ---------------
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
