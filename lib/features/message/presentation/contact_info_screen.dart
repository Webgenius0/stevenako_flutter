import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';

class ContactInfoScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;

  const ContactInfoScreen({
    super.key,
    this.name = 'Frances Swann',
    this.avatarUrl = '',
  });

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // Generate matches dynamically if it's the exact user from design
    final String displayUsername = widget.name == 'Frances Swann'
        ? '@Frances487'
        : '@${widget.name.replaceAll(' ', '').toLowerCase()}${widget.name.length * 7}';

    final String displayBio = widget.name == 'Frances Swann'
        ? 'I am a funny Video Maker'
        : 'Hey there! I am using Stevenako.';

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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // --------------- Custom App Bar ---------------
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back button
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 22.sp,
                                ),
                              ),

                              // Screen Title
                              Text(
                                'Contact Info',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              // Dummy sized box to keep title centered
                              SizedBox(width: 48.w),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // --------------- Profile Avatar ---------------
                        Container(
                          width: 120.r,
                          height: 120.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.r),
                            child: widget.avatarUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: widget.avatarUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[900],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: Colors.grey[800],
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white70,
                                            size: 48,
                                          ),
                                        ),
                                  )
                                : Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                      size: 48,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // --------------- Name ---------------
                        Text(
                          widget.name,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),

                        // --------------- Username ---------------
                        Text(
                          displayUsername,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF94A3B8), // slate-400
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // --------------- Bio ---------------
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            displayBio,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF64748B), // slate-500
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 48.h),

                        // --------------- Actions Container ---------------
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF27273A,
                              ).withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Action: Delete conversation
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.r),
                                      topRight: Radius.circular(16.r),
                                    ),
                                    onTap: () {
                                      // Implement delete conversation action
                                      debugPrint(
                                        'Delete conversation tapped for ${widget.name}',
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 18.h,
                                      ),
                                      child: Text(
                                        'Delete this conversation',
                                        style: GoogleFonts.inter(
                                          color: const Color(
                                            0xFFEE8E80,
                                          ), // warm coral text
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                                // Action: Block contact
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16.r),
                                      bottomRight: Radius.circular(16.r),
                                    ),
                                    onTap: () {
                                      // Implement block contact action
                                      debugPrint(
                                        'Block contact tapped for ${widget.name}',
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 18.h,
                                      ),
                                      child: Text(
                                        'Block this Contact',
                                        style: GoogleFonts.inter(
                                          color: const Color(
                                            0xFFEE8E80,
                                          ), // warm coral text
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
