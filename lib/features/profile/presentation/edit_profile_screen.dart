import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Alex Tass');
  final _usernameController = TextEditingController(text: '@alextass');
  final _genderController = TextEditingController(text: 'Select your gender');
  final _dobController = TextEditingController(text: 'Date of Birth');
  final _bioController = TextEditingController();

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _pickedImage = image;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _pickedImage = image;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectGender() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        final List<String> genders = ['Male', 'Female', 'Other'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: genders.map((gender) {
              return ListTile(
                title: Center(
                  child: Text(
                    gender,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _genderController.text = gender;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9F75FF),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E2C),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E2C),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  void _updateProfile() {
    // Show premium style Toast message using fluttertoast package
    Fluttertoast.showToast(
      msg: "Profile updated successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFF9F75FF),
      textColor: Colors.white,
      fontSize: 14.sp,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF252538), Color(0xFF151522)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Avatar Section with Dashed Outline
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 140.w,
                            height: 140.w,
                            padding: EdgeInsets.all(8.w),
                            child: CustomPaint(
                              painter: DashedCirclePainter(
                                color: Colors.white24,
                                strokeWidth: 1.5,
                                dashes: 35,
                                gapSize: 4,
                              ),
                              child: Container(
                                margin: EdgeInsets.all(6.w),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2D2D3F),
                                ),
                                child: ClipOval(
                                  child: _pickedImage != null
                                      ? Image.file(
                                          File(_pickedImage!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 60.sp,
                                            color: Colors.white30,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Camera overlay badge
                        Positioned(
                          bottom: 12.h,
                          right: 12.w,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // "Personal Information" Header
                  Text(
                    'Personal Information',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Full name Field
                  _buildLabelTextField(
                    controller: _nameController,
                    labelText: 'Full name',
                  ),
                  SizedBox(height: 20.h),
                  // Username Field
                  _buildLabelTextField(
                    controller: _usernameController,
                    labelText: 'username',
                  ),
                  SizedBox(height: 20.h),
                  // Select your gender Field
                  _buildSelectField(
                    controller: _genderController,
                    onTap: _selectGender,
                  ),
                  SizedBox(height: 20.h),
                  // Date of Birth Field
                  _buildSelectField(
                    controller: _dobController,
                    onTap: _selectDate,
                  ),
                  SizedBox(height: 20.h),
                  // Bio Field
                  _buildBioTextField(
                    controller: _bioController,
                    hintText: 'Bio',
                  ),
                  SizedBox(height: 32.h),
                  // Update button
                  Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9F75FF), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.inter(color: Colors.white54, fontSize: 14.sp),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF9F75FF), width: 1),
        ),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildSelectField({
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.text,
              style: GoogleFonts.inter(
                color:
                    (controller.text == 'Select your gender' ||
                        controller.text == 'Date of Birth')
                    ? Colors.white38
                    : Colors.white,
                fontSize: 15.sp,
                fontWeight:
                    (controller.text == 'Select your gender' ||
                        controller.text == 'Date of Birth')
                    ? FontWeight.w400
                    : FontWeight.w500,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white70,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 15.sp),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashes;
  final double gapSize;

  DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashes,
    required this.gapSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double circumference = 2 * math.pi * radius;
    final double dashLength = (circumference / dashes) - gapSize;
    final double dashAngle = (dashLength / radius);
    final double gapAngle = (gapSize / radius);

    double currentAngle = 0.0;
    while (currentAngle < 2 * math.pi) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        dashAngle,
        false,
        paint,
      );
      currentAngle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
