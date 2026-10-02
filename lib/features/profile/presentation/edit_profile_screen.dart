import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../helpers/di.dart';
import '../../../../helpers/keyboard.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/api_acess.dart';
import '../../../../networks/endpoints.dart';
import '../../setting/model/user_profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _genderController = TextEditingController(text: 'Select your gender');
  final _dobController = TextEditingController(text: 'Date of Birth');
  final _bioController = TextEditingController();

  DateTime? _selectedDob;
  String? _networkAvatarUrl;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isInitialLoading = false;

  @override
  void initState() {
    super.initState();
    _populateExistingData();
    _fetchProfile();
  }

  void _populateExistingData() {
    final user = getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;
    if (user != null) {
      _applyUserData(user);
    }
  }

  Future<void> _fetchProfile() async {
    final hasCachedUser =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user != null;
    if (!hasCachedUser) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      final profile = await getUserProfileRxObj.getUserProfile();
      if (mounted && profile?.data?.user != null) {
        _applyUserData(profile!.data!.user!);
      }
    } catch (_) {
      // Handled in rx
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  void _applyUserData(User user) {
    if (user.name != null && user.name!.trim().isNotEmpty) {
      _nameController.text = user.name!.trim();
    }
    if (user.username != null && user.username!.trim().isNotEmpty) {
      final cleanUsername = user.username!.trim().replaceAll('@', '');
      _usernameController.text = '@$cleanUsername';
    }
    if (user.gender != null) {
      _genderController.text = _formatGender(user.gender.toString());
    }
    if (user.dateOfBirth != null) {
      final parsedDate = _parseDate(user.dateOfBirth);
      if (parsedDate != null) {
        _selectedDob = parsedDate;
        _dobController.text = DateFormat('dd-MM-yyyy').format(parsedDate);
      } else {
        final dobStr = user.dateOfBirth.toString().trim();
        if (dobStr.isNotEmpty && dobStr != 'null') {
          _dobController.text = dobStr;
        }
      }
    }
    if (user.bio != null && user.bio.toString().trim().isNotEmpty) {
      _bioController.text = user.bio.toString().trim();
    }
    if (user.avatar != null && user.avatar.toString().trim().isNotEmpty) {
      _networkAvatarUrl = user.avatar.toString().trim();
    }
    if (mounted) {
      setState(() {});
    }
  }

  String _formatGender(String? gender) {
    if (gender == null || gender.trim().isEmpty || gender == 'null') {
      return 'Select your gender';
    }
    final g = gender.trim().toLowerCase();
    if (g == 'male') return 'Male';
    if (g == 'female') return 'Female';
    if (g == 'other') return 'Other';
    return g[0].toUpperCase() + g.substring(1);
  }

  DateTime? _parseDate(dynamic rawDate) {
    if (rawDate == null) return null;
    final str = rawDate.toString().trim();
    if (str.isEmpty || str == 'null') return null;

    final parsedIso = DateTime.tryParse(str);
    if (parsedIso != null) return parsedIso;

    try {
      return DateFormat('dd-MM-yyyy').parseStrict(str);
    } catch (_) {}

    try {
      return DateFormat('yyyy-MM-dd').parseStrict(str);
    } catch (_) {}

    try {
      return DateFormat('dd/MM/yyyy').parseStrict(str);
    } catch (_) {}

    return null;
  }

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
    KeyboardUtil.hideKeyboard(context);
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
    KeyboardUtil.hideKeyboard(context);
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
    KeyboardUtil.hideKeyboard(context);
    final DateTime now = DateTime.now();
    final DateTime initial = _selectedDob ?? DateTime(2000, 9, 28);
    final DateTime effectiveInitial = initial.isAfter(now) ? now : initial;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: effectiveInitial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9F75FF),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E2C),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1E2C),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    KeyboardUtil.hideKeyboard(context);

    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ToastUtil.showShortToast('Please enter your name');
      return;
    }

    final String gender = _genderController.text.trim();
    if (gender.isEmpty || gender == 'Select your gender') {
      ToastUtil.showShortToast('Please select your gender');
      return;
    }

    String dob = '';
    if (_selectedDob != null) {
      dob = DateFormat('dd-MM-yyyy').format(_selectedDob!);
    } else if (_dobController.text.trim().isNotEmpty &&
        _dobController.text.trim() != 'Date of Birth') {
      final parsed = _parseDate(_dobController.text.trim());
      if (parsed != null) {
        dob = DateFormat('dd-MM-yyyy').format(parsed);
      } else {
        dob = _dobController.text.trim();
      }
    }

    if (dob.isEmpty) {
      ToastUtil.showShortToast('Please select your date of birth');
      return;
    }

    final String bio = _bioController.text.trim();
    final String username =
        _usernameController.text.trim().replaceAll('@', '');
    final File? avatarFile =
        _pickedImage != null ? File(_pickedImage!.path) : null;

    final result = await postSetProfileRxObj.setProfile(
      name: name,
      username: username.isNotEmpty ? username : null,
      bio: bio,
      gender: gender.toLowerCase(),
      dateOfBirth: dob,
      avatar: avatarFile,
    );

    if (result != null &&
        (result.success == true ||
            result.code == 200 ||
            result.code == 201)) {
      // Refresh current user profile stream across the app
      await getUserProfileRxObj.getUserProfile();
      final dynamic mySavedId = appData.read('user_id');
      if (mySavedId != null) {
        getUserInfoRxObj.getUserInfo(id: mySavedId);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Widget _buildAvatarWidget() {
    if (_pickedImage != null) {
      return Image.file(
        File(_pickedImage!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    final avatarUrl = (_networkAvatarUrl ?? '').trim();
    if (avatarUrl.isNotEmpty) {
      final fullUrl = avatarUrl.startsWith('http://') ||
              avatarUrl.startsWith('https://')
          ? avatarUrl
          : '$url/${avatarUrl.startsWith('/') ? avatarUrl.substring(1) : avatarUrl}';

      return CachedNetworkImage(
        imageUrl: fullUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: const Color(0xFF1E1E2C),
          highlightColor: const Color(0xFF2E2E42),
          child: Container(
            color: const Color(0xFF1E1E2C),
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Icon(
            Icons.person_rounded,
            size: 60.sp,
            color: Colors.white30,
          ),
        ),
      );
    }

    return Center(
      child: Icon(
        Icons.person,
        size: 60.sp,
        color: Colors.white30,
      ),
    );
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
            child: _isInitialLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF9F75FF),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      children: [
                        // Top Navigation Header
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 38.r,
                                height: 38.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Edit Profile',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 38.r),
                          ],
                        ),
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
                                        child: _buildAvatarWidget(),
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
                        ValueListenableBuilder<bool>(
                          valueListenable: postSetProfileRxObj.isLoading,
                          builder: (context, isLoading, child) {
                            return Container(
                              width: double.infinity,
                              height: 52.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isLoading
                                      ? [
                                          const Color(0xFF9F75FF)
                                              .withValues(alpha: 0.5),
                                          const Color(0xFF7C3AED)
                                              .withValues(alpha: 0.5),
                                        ]
                                      : const [
                                          Color(0xFF9F75FF),
                                          Color(0xFF7C3AED),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(26.r),
                              ),
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26.r),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 22.h,
                                        height: 22.h,
                                        child:
                                            const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        'Update',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
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
                color: (controller.text == 'Select your gender' ||
                        controller.text == 'Date of Birth')
                    ? Colors.white38
                    : Colors.white,
                fontSize: 15.sp,
                fontWeight: (controller.text == 'Select your gender' ||
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
