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
import 'package:video_player/video_player.dart';

enum UploadPostType { video, photo, post }

class UploadPostScreen extends StatefulWidget {
  final String? thumbnailPath; // path to the video or photo preview frame
  final File? videoFile; // video file passed from VideoUploadScreen
  final File? photoFile; // photo file passed from UploadPhotoScreen
  final List<File>? photoFiles; // list of photos for multi-image post
  final int? soundId; // selected sound track id
  final String? postType; // 'video' | 'photo' | 'post'

  const UploadPostScreen({
    super.key,
    this.thumbnailPath,
    this.videoFile,
    this.photoFile,
    this.photoFiles,
    this.soundId,
    this.postType,
  });

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  late List<File> _activePhotos;
  File? _activeVideo;
  late UploadPostType _selectedType;

  // Toggle flag: Set to true if you want to allow attaching media in Post mode in the future.
  static const bool _enableAttachMediaInPost = false;

  @override
  void initState() {
    super.initState();
    _activePhotos = [];
    if (widget.photoFiles != null && widget.photoFiles!.isNotEmpty) {
      _activePhotos.addAll(widget.photoFiles!);
    } else if (widget.photoFile != null) {
      _activePhotos.add(widget.photoFile!);
    }
    _activeVideo = widget.videoFile;

    if (widget.postType == 'video' || widget.videoFile != null) {
      _selectedType = UploadPostType.video;
    } else if (widget.postType == 'photo' ||
        (widget.photoFiles != null && widget.photoFiles!.isNotEmpty) ||
        widget.photoFile != null) {
      _selectedType = UploadPostType.photo;
    } else if (widget.postType == 'post' || widget.postType == 'text') {
      _selectedType = UploadPostType.post;
    } else {
      _selectedType = UploadPostType.post;
    }
  }

  void _removePhoto(int index) {
    if (index >= 0 && index < _activePhotos.length) {
      setState(() {
        _activePhotos.removeAt(index);
      });
    }
  }

  Future<void> _addMorePhotos() async {
    try {
      final picker = ImagePicker();
      final List<XFile> picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        setState(() {
          _activePhotos.addAll(picked.map((x) => File(x.path)));
        });
      }
    } catch (e) {
      debugPrint('Error picking additional photos: $e');
    }
  }

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

  Future<void> _pickVideo() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _activeVideo = File(picked.path);
          _selectedType = UploadPostType.video;
        });
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  String get _appBarTitle {
    switch (_selectedType) {
      case UploadPostType.video:
        return 'Upload Video';
      case UploadPostType.photo:
        return _activePhotos.length > 1 ? 'Upload Photos' : 'Upload Photo';
      case UploadPostType.post:
        return 'Create Post';
    }
  }

  IconData get _appBarIcon {
    switch (_selectedType) {
      case UploadPostType.video:
        return CupertinoIcons.videocam_fill;
      case UploadPostType.photo:
        return CupertinoIcons.photo_fill;
      case UploadPostType.post:
        return CupertinoIcons.square_pencil;
    }
  }

  String get _hintText {
    switch (_selectedType) {
      case UploadPostType.video:
        return 'Write a caption for your video... #reel #trending';
      case UploadPostType.photo:
        return 'Write a caption for your photo... #photography #moments';
      case UploadPostType.post:
        return 'What\'s happening? Share your thoughts, story, or ideas...';
    }
  }

  String get _submitButtonText {
    switch (_selectedType) {
      case UploadPostType.video:
        return 'Upload Video';
      case UploadPostType.photo:
        return _activePhotos.length > 1 ? 'Upload Photos' : 'Upload Photo';
      case UploadPostType.post:
        return 'Publish Post';
    }
  }

  IconData get _submitButtonIcon {
    switch (_selectedType) {
      case UploadPostType.video:
        return CupertinoIcons.arrow_up_circle_fill;
      case UploadPostType.photo:
        return CupertinoIcons.arrow_up_circle_fill;
      case UploadPostType.post:
        return CupertinoIcons.paperplane_fill;
    }
  }

  Future<void> _onPostNow() async {
    if (userPostRxObj.isLoading.value) return;

    final video = _activeVideo;
    final photos = _activePhotos;

    if (_selectedType == UploadPostType.video) {
      if (video == null || !await video.exists()) {
        ToastUtil.showShortToast('Please select a video first');
        return;
      }
    } else if (_selectedType == UploadPostType.photo) {
      if (photos.isEmpty || !await photos.first.exists()) {
        ToastUtil.showShortToast('Please select at least one photo');
        return;
      }
    } else {
      if (_captionController.text.trim().isEmpty &&
          (!_enableAttachMediaInPost ||
              ((video == null || !await video.exists()) &&
                  (photos.isEmpty || !await photos.first.exists())))) {
        ToastUtil.showShortToast('Please enter what\'s on your mind');
        return;
      }
    }

    final String postType;
    switch (_selectedType) {
      case UploadPostType.video:
        postType = 'video';
        break;
      case UploadPostType.photo:
        postType = 'photo';
        break;
      case UploadPostType.post:
        if (video != null && await video.exists()) {
          postType = 'video';
        } else if (photos.isNotEmpty && await photos.first.exists()) {
          postType = 'photo';
        } else {
          postType = 'text';
        }
        break;
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
      type: postType,
      caption: _captionController.text.trim(),
      locationName: _selectedLocationName ?? '',
      locationLat: _selectedLocationLat ?? 0.0,
      locationLng: _selectedLocationLng ?? 0.0,
      privacySetting: privacySetting,
      allowComments: _allowComments ? 1 : 0,
      allowGifts: _allowGifts ? 1 : 0,
      taggedUserIds: _taggedUserIds,
      video: (_selectedType == UploadPostType.video || (_selectedType == UploadPostType.post && video != null))
          ? video
          : null,
      photo: (_selectedType == UploadPostType.photo || (_selectedType == UploadPostType.post && photos.isNotEmpty))
          ? (photos.isNotEmpty ? photos.first : null)
          : null,
      photos: (_selectedType == UploadPostType.photo || (_selectedType == UploadPostType.post && photos.isNotEmpty))
          ? (photos.isNotEmpty ? photos : null)
          : null,
      soundId: widget.soundId,
    );

    if (!mounted) return;

    if (response != null &&
        (response.success == true || response.code == 200 || response.code == 201)) {
      Get.offAll(() => const NavigationMenu());
    } else if (response != null &&
        response.message != null &&
        response.message!.isNotEmpty &&
        response.success == false) {
      ToastUtil.showShortToast(response.message!);
    }
  }

  void _openVideoPreview() {
    if (_activeVideo == null) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (context) => _VideoFilePreviewDialog(
        videoFile: _activeVideo!,
        hasSoundtrack: widget.soundId != null,
      ),
    );
  }

  Widget _buildVideoCard() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF161524),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _purpleLight.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _openVideoPreview,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 72.w,
                  height: 86.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3B1E6D), Color(0xFF1E1B2E)],
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (widget.thumbnailPath != null &&
                          (widget.thumbnailPath!.endsWith('.jpg') ||
                              widget.thumbnailPath!.endsWith('.jpeg') ||
                              widget.thumbnailPath!.endsWith('.png') ||
                              widget.thumbnailPath!.endsWith('.webp')))
                      ? Image.file(File(widget.thumbnailPath!), fit: BoxFit.cover)
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _purple.withValues(alpha: 0.5),
                                const Color(0xFF1E1B2E),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.videocam_fill,
                              color: _purpleLight,
                              size: 28.sp,
                            ),
                          ),
                        ),
                ),
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 1),
                  ),
                  child: Icon(
                    CupertinoIcons.play_arrow_solid,
                    size: 15.sp,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 4.h,
                  left: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'VIDEO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Video ready to upload',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  _activeVideo!.path.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11.5.sp,
                  ),
                ),
                if (widget.soundId != null) ...[
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.music_note_2,
                        size: 11.sp,
                        color: _purpleLight,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Soundtrack attached',
                        style: TextStyle(
                          color: _purpleLight,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 8.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _openVideoPreview,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_purple, Color(0xFF9333EA)],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: _purple.withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.play_arrow_solid,
                              size: 11.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Preview Video',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: _pickVideo,
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: _purpleLight,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _activeVideo = null),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 14.sp, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddVideoBox() {
    return GestureDetector(
      onTap: _pickVideo,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _purpleLight.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.videocam_circle_fill,
              color: _purpleLight,
              size: 26.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'Select Video to Upload',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.photo_on_rectangle,
              size: 15.sp,
              color: _purpleLight,
            ),
            SizedBox(width: 6.w),
            Text(
              '${_activePhotos.length} ${_activePhotos.length == 1 ? 'photo' : 'photos'} attached',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (int index = 0; index < _activePhotos.length; index++)
              Stack(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: _purpleLight.withValues(alpha: 0.5),
                        width: 1.2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.file(
                      _activePhotos[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 3.r,
                    right: 3.r,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 11.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3.r,
                    left: 3.r,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (_activePhotos.length < 10)
              GestureDetector(
                onTap: _addMorePhotos,
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Colors.white24,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: _purpleLight,
                        size: 20.sp,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPhotosBox() {
    return GestureDetector(
      onTap: _addMorePhotos,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _purpleLight.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.photo_fill_on_rectangle_fill,
              color: _purpleLight,
              size: 24.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'Select Photos to Upload',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostAttachChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white24, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: _purpleLight),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
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
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _appBarIcon,
                            color: _purpleLight,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _appBarTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 44), // balances the back button
                  ],
                ),
              ),

              // ---- Scrollable content
              Expanded(

                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Single Unified Post Container
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1B2E).withValues(alpha: 0.7),
                          border: Border.all(color: _cardBorder, width: 1.2),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Big Text Area on top
                            TextField(
                              controller: _captionController,
                              maxLines: null,
                              minLines: 4,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                height: 1.4,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintText: _hintText,
                                hintStyle: TextStyle(
                                  color: _hintColor,
                                  fontSize: 15.sp,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            // Dynamic media section based on selected type
                            if (_selectedType == UploadPostType.video) ...[
                              SizedBox(height: 14.h),
                              Divider(color: Colors.white10, height: 1.h),
                              SizedBox(height: 12.h),
                              if (_activeVideo != null)
                                _buildVideoCard()
                              else
                                _buildAddVideoBox(),
                            ] else if (_selectedType == UploadPostType.photo) ...[
                              SizedBox(height: 14.h),
                              Divider(color: Colors.white10, height: 1.h),
                              SizedBox(height: 12.h),
                              if (_activePhotos.isNotEmpty)
                                _buildPhotosGrid()
                              else
                                _buildAddPhotosBox(),
                            ] else if (_enableAttachMediaInPost) ...[
                              // Post mode (hidden by default for text-only posts, can be enabled later via _enableAttachMediaInPost)
                              if (_activePhotos.isNotEmpty || _activeVideo != null) ...[
                                SizedBox(height: 14.h),
                                Divider(color: Colors.white10, height: 1.h),
                                SizedBox(height: 12.h),
                                if (_activeVideo != null) _buildVideoCard(),
                                if (_activePhotos.isNotEmpty) ...[
                                  if (_activeVideo != null) SizedBox(height: 10.h),
                                  _buildPhotosGrid(),
                                ],
                              ],
                              SizedBox(height: 14.h),
                              Divider(color: Colors.white10, height: 1.h),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    'Attach media:',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  _buildPostAttachChip(
                                    icon: CupertinoIcons.photo,
                                    label: 'Photo',
                                    onTap: _addMorePhotos,
                                  ),
                                  SizedBox(width: 8.w),
                                  _buildPostAttachChip(
                                    icon: CupertinoIcons.videocam,
                                    label: 'Video',
                                    onTap: _pickVideo,
                                  ),
                                ],
                              ),
                            ],
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
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _submitButtonIcon,
                                              color: Colors.white,
                                              size: 19.sp,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              _submitButtonText,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
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

// ============================================================
// Video & Music Preview Dialog
// ============================================================

class _VideoFilePreviewDialog extends StatefulWidget {
  final File videoFile;
  final bool hasSoundtrack;

  const _VideoFilePreviewDialog({
    required this.videoFile,
    required this.hasSoundtrack,
  });

  @override
  State<_VideoFilePreviewDialog> createState() =>
      _VideoFilePreviewDialogState();
}

class _VideoFilePreviewDialogState extends State<_VideoFilePreviewDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      _controller = VideoPlayerController.file(widget.videoFile);
      await _controller.initialize();
      _controller.setLooping(true);
      await _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = true;
        });
      }
      _controller.addListener(() {
        if (mounted) {
          final isPlaying = _controller.value.isPlaying;
          if (isPlaying != _isPlaying) {
            setState(() {
              _isPlaying = isPlaying;
            });
          }
        }
      });
    } catch (e) {
      debugPrint('Video preview init error: $e');
    }
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleMute() {
    if (!_isInitialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 24.h),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF100F17),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video & Music Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (widget.hasSoundtrack)
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.music_note_2,
                                color: const Color(0xFF9F75FF),
                                size: 11.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'With mixed soundtrack',
                                style: TextStyle(
                                  color: const Color(0xFF9F75FF),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleMute,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isMuted
                            ? CupertinoIcons.volume_off
                            : CupertinoIcons.volume_up,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.white12, height: 1.h),

            // Video Player Body
            Expanded(
              child: GestureDetector(
                onTap: _togglePlayPause,
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isInitialized)
                      Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    else
                      const Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                          radius: 16,
                        ),
                      ),

                    // Play/Pause Overlay indicator
                    if (_isInitialized && !_isPlaying)
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30, width: 1.5),
                        ),
                        child: Icon(
                          CupertinoIcons.play_fill,
                          size: 36.sp,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom controls & Done button
            if (_isInitialized)
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                decoration: const BoxDecoration(
                  color: Color(0xFF14121F),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Scrubber
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      colors: const VideoProgressColors(
                        playedColor: Color(0xFF9F75FF),
                        bufferedColor: Colors.white24,
                        backgroundColor: Colors.white10,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: _controller,
                      builder: (context, value, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(value.position),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11.sp,
                              ),
                            ),
                            Text(
                              _formatDuration(value.duration),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 44.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.checkmark_alt,
                              size: 17.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Looks Good, Ready to Upload',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

