import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/custom_login_text_field.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _fullNameController = TextEditingController(text: 'Alex Tass');
  final _usernameController = TextEditingController(text: '@alextass');
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();
  String? _selectedGender;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: Text(
                'Camera',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  setState(() {
                    _imageFile = image;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: Text(
                'Gallery',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() {
                    _imageFile = image;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _bioController.dispose();
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
      child: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox.expand(
            child: Stack(
              children: [
                // --------------- Background Image ---------------
                Positioned.fill(
                  child: Image.asset(AppImages.loginBg, fit: BoxFit.cover),
                ),

                // --------------- Top subtle glow overlay ---------------
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 300.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.0, -1.0),
                        radius: 1.2,
                        colors: [
                          const Color(0xFF8B5CF6).withOpacity(0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // --------------- UI Content ---------------
                Positioned.fill(
                  child: SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 48.h),

                                    // --------------- Title ---------------
                                    Text(
                                      'Set up your profile',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    // --------------- Subtitle ---------------
                                    Text(
                                      'This helps people discover and follow',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 28.h),

                                    // --------------- Avatar Selection ---------------
                                    Center(
                                      child: GestureDetector(
                                        onTap: _pickImage,
                                        child: SizedBox(
                                          width: 110.w,
                                          height: 110.w,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Positioned.fill(
                                                child: CustomPaint(
                                                  painter:
                                                      DashedCirclePainter(),
                                                ),
                                              ),
                                              Container(
                                                width: 90.w,
                                                height: 90.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: const Color(
                                                    0xFF1E293B,
                                                  ),
                                                  image: _imageFile != null
                                                      ? DecorationImage(
                                                          image: FileImage(
                                                            File(
                                                              _imageFile!.path,
                                                            ),
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : null,
                                                ),
                                                child: _imageFile == null
                                                    ? Icon(
                                                        Icons.person,
                                                        color: const Color(
                                                          0xFF94A3B8,
                                                        ),
                                                        size: 48.sp,
                                                      )
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 28.h),

                                    // --------------- Full Name Field ---------------
                                    CustomTextField(
                                      controller: _fullNameController,
                                      labelText: 'Full name',
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Username Field ---------------
                                    CustomTextField(
                                      controller: _usernameController,
                                      labelText: 'username',
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Gender Dropdown (Custom styled container) ---------------
                                    Container(
                                      width: double.infinity,
                                      height: 58.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFF334155),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedGender,
                                          hint: Text(
                                            'Select your gender',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF475569),
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.white,
                                            size: 24.sp,
                                          ),
                                          dropdownColor: const Color(
                                            0xFF0F172A,
                                          ),
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                          items:
                                              <String>[
                                                'Male',
                                                'Female',
                                                'Other',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedGender = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Date of Birth Field ---------------
                                    CustomTextField(
                                      controller: _dobController,
                                      labelText: 'Date of Birth',
                                      hintText: 'YYYY-MM-DD',
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Bio Field ---------------
                                    TextFormField(
                                      controller: _bioController,
                                      maxLines: 4,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Bio',
                                        alignLabelWithHint: true,
                                        labelStyle: GoogleFonts.inter(
                                          color: const Color(0xFF475569),
                                          fontSize: 16.sp,
                                        ),
                                        floatingLabelStyle: GoogleFonts.inter(
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 16.h,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF334155),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF8B5CF6),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const Spacer(flex: 3),
                                    SizedBox(height: 24.h),

                                    // --------------- Get Started Button ---------------
                                    CustomButton(
                                      text: 'Get Started',
                                      onTap: () {
                                        // Navigate to Home/Dashboard
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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

// --------------- Dashed Circle Painter ---------------
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  DashedCirclePainter({
    this.color = const Color(0xFF475569),
    this.strokeWidth = 1.5,
    this.dashPattern = const [6, 4],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double circumference = 2 * pi * radius;
    final double dashSpace = dashPattern.reduce((a, b) => a + b);
    final int dashCount = (circumference / dashSpace).round();
    final double angleStep = 2 * pi / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * angleStep;
      final double sweepAngle = angleStep * (dashPattern[0] / dashSpace);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
