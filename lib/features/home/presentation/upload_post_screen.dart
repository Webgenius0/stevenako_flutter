
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:stevenako_flutter/features/home/presentation/add_location_screen.dart';
import 'package:stevenako_flutter/features/home/presentation/tag_people_screeen.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class UploadPostScreen extends StatefulWidget {
  final String? thumbnailPath; // path to the video's preview frame

  const UploadPostScreen({super.key, this.thumbnailPath});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _captionController = TextEditingController();

  bool _allowComments = true;
  bool _allowGifts = true;
  PrivacyOption _privacy = PrivacyOption.everyone;

  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);
  static const Color _hintColor = Color(0xFF8B8A99);

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  void _onTagPeople() {
    // TODO: open tag-people picker
    Get.to(TagPeopleScreeen());
  }

  void _onLocation() {
    // TODO: open location picker
    Get.to(AddLocationScreen());
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

  IconData get _privacyIcon {
    switch (_privacy) {
      case PrivacyOption.everyone:
        return Icons.lock_open_outlined;
      case PrivacyOption.friends:
        return Icons.people_alt_outlined;
      case PrivacyOption.followersOnly:
        return Icons.person_outline;
      case PrivacyOption.onlyMe:
        return Icons.lock_outline;
    }
  }

  void _onSaveDraft() {
    // TODO: persist draft locally / to backend
  }

  void _onPostNow() {
    // TODO: upload video + caption + settings to backend
     NavigationService.goBack;
     NavigationService.goBack;
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
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 30),
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

                        label: 'Tag people',
                        onTap: _onTagPeople,
                        imagePath: 'assets/images/gift.png',
                      ),
                        SizedBox(height: 12.h),
                      _NavRow(

                        label: 'Location',
                        onTap: _onLocation, imagePath: 'assets/images/location.png',
                      ),
                        SizedBox(height: 12.h),
                      _NavRow(

                        label: _privacyLabel,
                        onTap: _onPrivacy, imagePath: 'assets/images/anyone.png',
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
                          side: const BorderSide(color: _purpleLight, width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Save as Draft',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [_purpleLight, _purple],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _purple.withOpacity(0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: _onPostNow,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
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
                color: Colors.white, // Remove this if your PNG is already colored
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
                    child: Icon(Icons.image_not_supported_outlined,
                        color: Colors.white38, size: 20),
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
                child: _RadioDot(isSelected: isSelected, activeColor: selectedBorder),
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