import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/data/rx_user_post_api/rx.dart';
import 'package:stevenako_flutter/features/home/model/location_option_model.dart';
import 'package:stevenako_flutter/features/home/model/user_post_model.dart';
import 'package:stevenako_flutter/features/home/presentation/add_location_screen.dart';
import 'package:stevenako_flutter/features/home/presentation/tag_people_screeen.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/navigation_menu.dart';

class CreatAPostScreeen extends StatefulWidget {
  final String? thumbnailPath; // Optional path to an initial image / thumbnail
  final List<String>? initialImages; // Optional initial list of image paths

  const CreatAPostScreeen({
    super.key,
    this.thumbnailPath,
    this.initialImages,
  });

  @override
  State<CreatAPostScreeen> createState() => _CreatAPostScreeenState();
}

class _CreatAPostScreeenState extends State<CreatAPostScreeen> {
  final TextEditingController _captionController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  bool _allowComments = true;
  bool _allowGifts = true;
  PrivacyOption _privacy = PrivacyOption.everyone;

  final UserPostRx userPostRxObj = UserPostRx(
    empty: UserPostModel(
      success: false,
      code: 0,
      message: "",
      data: null,
    ),
    dataFetcher: BehaviorSubject<UserPostModel>(),
  );

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
  void initState() {
    super.initState();
    if (widget.initialImages != null && widget.initialImages!.isNotEmpty) {
      for (final path in widget.initialImages!) {
        final f = File(path);
        if (f.existsSync()) {
          _selectedImages.add(f);
        }
      }
    } else if (widget.thumbnailPath != null && widget.thumbnailPath!.isNotEmpty) {
      final f = File(widget.thumbnailPath!);
      if (f.existsSync()) {
        _selectedImages.add(f);
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    userPostRxObj.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  // Pick multiple images from gallery
  Future<void> _pickMultiImages() async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 88,
      );
      if (pickedFiles.isNotEmpty) {
        setState(() {
          for (final xfile in pickedFiles) {
            _selectedImages.add(File(xfile.path));
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select images: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  // Snap photo with camera
  Future<void> _takePhotoWithCamera() async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 88,
      );
      if (photo != null) {
        setState(() {
          _selectedImages.add(File(photo.path));
        });
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture photo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  // Show bottom sheet to choose between Gallery (multi-select) or Camera
  void _showAddImageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B2E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            border: Border.all(color: _cardBorder),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Add Photos to Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.photo_library_rounded, color: _purpleLight, size: 24.sp),
                  ),
                  title: Text(
                    'Select Multiple Photos (Gallery)',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Choose multiple photos at once',
                    style: TextStyle(color: _hintColor, fontSize: 12.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickMultiImages();
                  },
                ),
                Divider(color: Colors.white10, height: 1.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt_rounded, color: _purpleLight, size: 24.sp),
                  ),
                  title: Text(
                    'Take Photo (Camera)',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhotoWithCamera();
                  },
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // Lightbox fullscreen image viewer
  void _openFullscreenViewer(int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (dialogContext) {
        int currentIndex = initialIndex;
        final PageController pageController = PageController(initialPage: initialIndex);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                title: Text(
                  '${currentIndex + 1} of ${_selectedImages.length}',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFFFF3F55)),
                    onPressed: () {
                      _removeImage(currentIndex);
                      if (_selectedImages.isEmpty) {
                        Navigator.pop(dialogContext);
                      } else {
                        setDialogState(() {
                          if (currentIndex >= _selectedImages.length) {
                            currentIndex = _selectedImages.length - 1;
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
              body: PageView.builder(
                controller: pageController,
                itemCount: _selectedImages.length,
                onPageChanged: (idx) {
                  setDialogState(() => currentIndex = idx);
                },
                itemBuilder: (context, idx) {
                  return InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 3.5,
                    child: Center(
                      child: Image.file(_selectedImages[idx], fit: BoxFit.contain),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
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
        return 'Anyone can see this';
      case PrivacyOption.friends:
        return 'Only friends can see this';
      case PrivacyOption.followersOnly:
        return 'Only followers can see this';
      case PrivacyOption.onlyMe:
        return 'Only me can see this';
    }
  }

  void _onSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully!'),
        backgroundColor: _purple,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onPostNow() async {
    if (userPostRxObj.isLoading.value) return;

    final String caption = _captionController.text.trim();
    final File? photoFile = _selectedImages.isNotEmpty ? _selectedImages.first : null;

    if (caption.isEmpty && photoFile == null) {
      ToastUtil.showShortToast('Please enter text or select a photo first');
      return;
    }

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
      type: 'text', // strictly text type for text post screen (photo is optional)
      caption: caption,
      locationName: _selectedLocationName ?? '',
      locationLat: _selectedLocationLat ?? 0.0,
      locationLng: _selectedLocationLng ?? 0.0,
      privacySetting: privacySetting,
      allowComments: _allowComments ? 1 : 0,
      allowGifts: _allowGifts ? 1 : 0,
      taggedUserIds: _taggedUserIds,
      photo: photoFile,
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
              // ---- Top App Bar / Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                    ),
                    const Expanded(
                      child: Text(
                        'Create Post',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _onPostNow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_purpleLight, _purple],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // User Info Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22.r,
                            backgroundColor: _purple.withValues(alpha: 0.4),
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Steven Ako',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              GestureDetector(
                                onTap: _onPrivacy,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        _privacy.imagePath,
                                        width: 12.w,
                                        height: 12.h,
                                        color: Colors.white70,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Icon(Icons.public, color: Colors.white70, size: 12.sp),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        _privacy.title,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(Icons.arrow_drop_down, color: Colors.white70, size: 16.sp),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Caption TextField
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161423),
                          border: Border.all(color: _cardBorder),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _captionController,
                          maxLines: null,
                          minLines: 4,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: "What's on your mind? Add caption, hashtags, or mention friends...",
                            hintStyle: TextStyle(
                              color: _hintColor,
                              fontSize: 15.5,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Multi-Image Display Section (Facebook / Instagram Style)
                      if (_selectedImages.isEmpty)
                        GestureDetector(
                          onTap: _showAddImageSheet,
                          child: Container(
                            height: 130.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF161423),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: _purpleLight.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: _purple.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add_photo_alternate_rounded,
                                    color: _purpleLight,
                                    size: 32.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Add Photos to your Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Select multiple images from Gallery or Camera',
                                  style: TextStyle(
                                    color: _hintColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        // Dynamic Facebook / Instagram Multi-Photo Grid Preview
                        _buildMultiImageGrid(),

                        SizedBox(height: 12.h),

                        // Horizontal Thumbnail Reel with "+ Add" tile
                        _buildThumbnailStrip(),
                      ],

                      SizedBox(height: 24.h),

                      // Nav Rows for extras (Tag, Location, Privacy, Toggles)
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
                      SizedBox(height: 12.h),
                      _ToggleRow(
                        imagePath: 'assets/images/message.png',
                        label: 'Allow comments',
                        value: _allowComments,
                        onChanged: (v) => setState(() => _allowComments = v),
                      ),
                      SizedBox(height: 12.h),
                      _ToggleRow(
                        imagePath: 'assets/images/gift.png',
                        label: 'Allow Gifts',
                        value: _allowGifts,
                        onChanged: (v) => setState(() => _allowGifts = v),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // ---- Bottom Action Bar (Draft & Post Now)
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

  // ============================================================
  // Facebook / Instagram Style Collage Grid Builder
  // ============================================================
  Widget _buildMultiImageGrid() {
    final int count = _selectedImages.length;
    if (count == 0) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          border: Border.all(color: _cardBorder),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: AspectRatio(
          aspectRatio: count == 1 ? 1.33 : 1.25,
          child: _buildGridContent(count),
        ),
      ),
    );
  }

  Widget _buildGridContent(int count) {
    if (count == 1) {
      return _buildGridTile(_selectedImages[0], 0);
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(child: _buildGridTile(_selectedImages[0], 0)),
          const SizedBox(width: 3),
          Expanded(child: _buildGridTile(_selectedImages[1], 1)),
        ],
      );
    } else if (count == 3) {
      return Row(
        children: [
          Expanded(flex: 2, child: _buildGridTile(_selectedImages[0], 0)),
          const SizedBox(width: 3),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(child: _buildGridTile(_selectedImages[1], 1)),
                const SizedBox(height: 3),
                Expanded(child: _buildGridTile(_selectedImages[2], 2)),
              ],
            ),
          ),
        ],
      );
    } else {
      // 4 or more photos (2x2 grid layout with count overlay badge on 4th)
      final int extraCount = count - 4;
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildGridTile(_selectedImages[0], 0)),
                const SizedBox(width: 3),
                Expanded(child: _buildGridTile(_selectedImages[1], 1)),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildGridTile(_selectedImages[2], 2)),
                const SizedBox(width: 3),
                Expanded(
                  child: extraCount > 0
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildGridTile(_selectedImages[3], 3, enableDelete: false),
                            GestureDetector(
                              onTap: () => _openFullscreenViewer(3),
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.65),
                                alignment: Alignment.center,
                                child: Text(
                                  '+$extraCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _buildGridTile(_selectedImages[3], 3),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildGridTile(File file, int index, {bool enableDelete = true}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () => _openFullscreenViewer(index),
          child: Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[900],
              child: const Icon(Icons.broken_image, color: Colors.white38),
            ),
          ),
        ),
        if (enableDelete)
          Positioned(
            top: 6.r,
            right: 6.r,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // Horizontal Thumbnail Reel with "+ Add" tile
  // ============================================================
  Widget _buildThumbnailStrip() {
    return SizedBox(
      height: 72.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length + 1,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          if (index == _selectedImages.length) {
            // "+ Add" photo button tile at end of horizontal list
            return GestureDetector(
              onTap: _showAddImageSheet,
              child: Container(
                width: 72.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF161423),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: _purpleLight.withValues(alpha: 0.5)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, color: _purpleLight, size: 22.sp),
                    SizedBox(height: 4.h),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final file = _selectedImages[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () => _openFullscreenViewer(index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    file,
                    width: 72.w,
                    height: 72.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4.r,
                right: 4.r,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 12.sp),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// Reusable UI components
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
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.star, color: Colors.white, size: 22),
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
            color: Colors.white,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.toggle_on, color: Colors.white, size: 22.sp),
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
        return 'Anyone on the platform can view your post';
      case PrivacyOption.friends:
        return 'Only people you follow and follow back';
      case PrivacyOption.followersOnly:
        return 'Anyone who follows your account';
      case PrivacyOption.onlyMe:
        return 'Your post will be completely private';
    }
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                option.imagePath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(Icons.lock_outline, color: Colors.white38, size: 20),
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