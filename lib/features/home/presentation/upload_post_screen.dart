import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import 'package:stevenako_flutter/features/home/data/rx_user_post_api/rx.dart';
import 'package:stevenako_flutter/features/home/model/location_option_model.dart';
import 'package:stevenako_flutter/features/home/model/user_post_model.dart';
import 'package:stevenako_flutter/features/home/presentation/add_location_screen.dart';
import 'package:stevenako_flutter/features/home/presentation/tag_people_screeen.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/navigation_menu.dart';

class UploadPostScreen extends StatefulWidget {
  final String? thumbnailPath; // path to the video or photo preview frame
  final File? videoFile; // video file passed from VideoUploadScreen
  final File? photoFile; // photo file passed from UploadPhotoScreen
  final int? soundId; // selected sound track id

  const UploadPostScreen({
    super.key,
    this.thumbnailPath,
    this.videoFile,
    this.photoFile,
    this.soundId,
  });

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _captionController = TextEditingController();

  final UserPostRx userPostRxObj = UserPostRx(
    empty: UserPostModel(
      success: false,
      code: 0,
      message: "",
      data: null,
    ),
    dataFetcher: BehaviorSubject<UserPostModel>(),
  );

  bool _allowComments = true;
  bool _allowGifts = true;
  PrivacyOption _privacy = PrivacyOption.everyone;

  String? _selectedLocationName;
  double? _selectedLocationLat;
  double? _selectedLocationLng;
  List<int> _taggedUserIds = [];

  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);
  static const Color _hintColor = Color(0xFF8B8A99);

  @override
  void dispose() {
    _captionController.dispose();
    userPostRxObj.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  Future<void> _onTagPeople() async {
    final result = await Get.to(
      () => TagPeopleScreeen(initiallyTaggedIds: _taggedUserIds.toSet()),
    );
    if (result != null && mounted && result is List<int>) {
      setState(() => _taggedUserIds = result);
    }
  }

  Future<void> _onLocation() async {
    final result = await Get.to(() => const AddLocationScreen());
    if (result != null && mounted) {
      if (result is LocationOptionModel) {
        setState(() {
          _selectedLocationName = result.title;
          _selectedLocationLat = result.latitude;
          _selectedLocationLng = result.longitude;
        });
      } else if (result is String) {
        setState(() => _selectedLocationName = result);
      }
    }
  }

  Future<void> _onPrivacy() async {
    final result = await showPrivacySettingSheet(context, current: _privacy);
    if (result != null && mounted) {
      setState(() => _privacy = result);
    }
  }

  String get _privacyLabel {
    switch (_privacy) {
      case PrivacyOption.everyone:
        return 'Anyone can watch this';
      case PrivacyOption.friends:
        return 'Only friends can watch this';
      case PrivacyOption.followersOnly:
        return 'Only followers can watch this';
      case PrivacyOption.onlyMe:
        return 'Only me can watch this';
    }
  }

  void _onSaveDraft() {
    Navigator.of(context).maybePop();
  }

  Future<void> _onPostNow() async {
    if (userPostRxObj.isLoading.value) return;

    final video = widget.videoFile;
    final photo = widget.photoFile;

    if ((video == null || !await video.exists()) &&
        (photo == null || !await photo.exists())) {
      ToastUtil.showShortToast('Please select a photo or video first');
      return;
    }

    final String postType = photo != null ? 'photo' : 'video';

    final String privacySetting;
    switch (_privacy) {
      case PrivacyOption.everyone:
        privacySetting = 'everyone';
        break;
      case PrivacyOption.friends:
        privacySetting = 'friends';
        break;
      case PrivacyOption.followersOnly:
        privacySetting = 'followersOnly';
        break;
      case PrivacyOption.onlyMe:
        privacySetting = 'onlyMe';
        break;
    }

    final response = await userPostRxObj.post(
      type: postType,
      caption: _captionController.text.trim(),
      locationName: _selectedLocationName ?? '',
      locationLat: _selectedLocationLat ?? 0.0,
      locationLng: _selectedLocationLng ?? 0.0,
      privacySetting: privacySetting,
      allowComments: _allowComments ? 1 : 0,
      allowGifts: _allowGifts ? 1 : 0,
      taggedUserIds: _taggedUserIds,
      video: video,
      photo: photo,
      soundId: widget.soundId,
    );

    if (!mounted) return;

    if (response != null &&
        (response.success == true || response.code == 200 || response.code == 201)) {
      Get.offAll(() => const NavigationMenu());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Post',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44), // balances the back button
                  ],
                ),
              ),

              // ---- Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Caption box + thumbnail
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: _cardBorder),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TextField(
                                  controller: _captionController,
                                  maxLines: null,
                                  minLines: 5,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.5,
                                    height: 1.35,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText:
                                        'Describe your video, add hashtags, or mention your friends',
                                    hintStyle: TextStyle(
                                      color: _hintColor,
                                      fontSize: 16.5,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      _NavRow(
                        label: _taggedUserIds.isEmpty
                            ? 'Tag people'
                            : 'Tag people (${_taggedUserIds.length})',
                        onTap: _onTagPeople,
                        imagePath: 'assets/images/gift.png',
                      ),
                      SizedBox(height: 12.h),
                      _NavRow(
                        label: _selectedLocationName ?? 'Location',
                        onTap: _onLocation,
                        imagePath: 'assets/images/location.png',
                      ),
                      SizedBox(height: 12.h),
                      _NavRow(
                        label: _privacyLabel,
                        onTap: _onPrivacy,
                        imagePath: 'assets/images/anyone.png',
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        imagePath: 'assets/images/message.png',
                        label: 'Allow comments',
                        value: _allowComments,
                        onChanged: (v) => setState(() => _allowComments = v),
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        imagePath: 'assets/images/gift.png',
                        label: 'Allow Gifts',
                        value: _allowGifts,
                        onChanged: (v) => setState(() => _allowGifts = v),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ---- Bottom action bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onSaveDraft,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: _purpleLight,
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child:   Text(
                          'cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: userPostRxObj.isLoading,
                        builder: (context, isLoading, child) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: isLoading
                                    ? [
                                        _purpleLight.withValues(alpha: 0.5),
                                        _purple.withValues(alpha: 0.5),
                                      ]
                                    : [_purpleLight, _purple],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _purple.withValues(
                                    alpha: isLoading ? 0.15 : 0.4,
                                  ),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: isLoading ? null : _onPostNow,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: isLoading
                                      ? const Center(
                                          child: CupertinoActivityIndicator(
                                            color: Colors.white,
                                            radius: 11,
                                          ),
                                        )
                                      : const Text(
                                          'Post Now',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Reusable rows
// ============================================================

class _NavRow extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _NavRow({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1926),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2E2C3E)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 22,
                height: 22,
                color:
                    Colors.white, // Remove this if your PNG is already colored
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8B8A99),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.imagePath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E2C3E)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 22.w,
            height: 22.h,
            color: Colors.white, // Remove if image already has colors
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF7C3AED),
            thumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum PrivacyOption { everyone, friends, followersOnly, onlyMe }

extension PrivacyOptionLabel on PrivacyOption {
  String get title {
    switch (this) {
      case PrivacyOption.everyone:
        return 'Everyone';
      case PrivacyOption.friends:
        return 'Friends';
      case PrivacyOption.followersOnly:
        return 'Followers only';
      case PrivacyOption.onlyMe:
        return 'Only me';
    }
  }

  String get subtitle {
    switch (this) {
      case PrivacyOption.everyone:
        return 'Anyone on the platform can watch your video';
      case PrivacyOption.friends:
        return 'Only people you follow and follow back';
      case PrivacyOption.followersOnly:
        return 'Anyone who follows your account';
      case PrivacyOption.onlyMe:
        return 'Your video will be completely private';
    }
  }

  // TODO: point these at your actual asset paths.
  String get imagePath {
    switch (this) {
      case PrivacyOption.everyone:
        return 'assets/images/Icon.png';
      case PrivacyOption.friends:
        return 'assets/images/frneds.png';
      case PrivacyOption.followersOnly:
        return 'assets/images/follower.png';
      case PrivacyOption.onlyMe:
        return 'assets/images/loock.png';
    }
  }
}

/// Shows the privacy setting bottom sheet and returns the selected
/// [PrivacyOption], or null if dismissed without a change.
Future<PrivacyOption?> showPrivacySettingSheet(
  BuildContext context, {
  required PrivacyOption current,
}) {
  return showModalBottomSheet<PrivacyOption>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _PrivacySettingSheet(current: current),
  );
}

class _PrivacySettingSheet extends StatefulWidget {
  final PrivacyOption current;
  const _PrivacySettingSheet({required this.current});

  @override
  State<_PrivacySettingSheet> createState() => _PrivacySettingSheetState();
}

class _PrivacySettingSheetState extends State<_PrivacySettingSheet> {
  late PrivacyOption _selected = widget.current;

  static const Color _sheetBg = Color(0xFF17151F);
  static const Color _cardBg = Color(0xFF1E1B2A);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _selectedBorder = Color(0xFF7C3AED);
  static const Color _subtitleColor = Color(0xFF8B8A99);

  void _select(PrivacyOption option) {
    setState(() => _selected = option);
    // Small delay so the user sees the radio fill before the sheet closes.
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) Navigator.of(context).pop(option);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        decoration: BoxDecoration(
          color: _sheetBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Privacy Setting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            ...PrivacyOption.values.map((option) {
              final isSelected = option == _selected;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PrivacyOptionCard(
                  option: option,
                  isSelected: isSelected,
                  cardBg: _cardBg,
                  cardBorder: _cardBorder,
                  selectedBorder: _selectedBorder,
                  subtitleColor: _subtitleColor,
                  onTap: () => _select(option),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PrivacyOptionCard extends StatelessWidget {
  final PrivacyOption option;
  final bool isSelected;
  final Color cardBg;
  final Color cardBorder;
  final Color selectedBorder;
  final Color subtitleColor;
  final VoidCallback onTap;

  const _PrivacyOptionCard({
    required this.option,
    required this.isSelected,
    required this.cardBg,
    required this.cardBorder,
    required this.selectedBorder,
    required this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? selectedBorder : cardBorder,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            // Center everything (image, text block, radio) on the same line.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                option.imagePath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback so the sheet still renders if the asset is missing.
                  return const SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                  );
                },
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Wrapped so the radio dot always sits vertically centered
              // against the (variable-height) text block beside it.
              Align(
                alignment: Alignment.center,
                child: _RadioDot(
                  isSelected: isSelected,
                  activeColor: selectedBorder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;
  final Color activeColor;

  const _RadioDot({required this.isSelected, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? activeColor : const Color(0xFF4A4858),
          width: 2,
        ),
        color: Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor,
                ),
              ),
            )
          : null,
    );
  }
}
