import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';

import 'package:stevenako_flutter/features/home/model/get_soudn_modle.dart';
import 'package:stevenako_flutter/features/home/presentation/sound_track_screeen.dart';
import 'package:stevenako_flutter/features/home/presentation/upload_post_screen.dart';

enum PhotoAspectRatio { original, square, ratio4x3, ratio16x9, ratio3x2 }

class UploadPhotoScreen extends StatefulWidget {
  final String tap;
  const UploadPhotoScreen({super.key, required this.tap});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> with SingleTickerProviderStateMixin {
  File? _croppedImage;
  File? _selectedRawImage;
  List<File> _selectedImages = [];
  int _currentImageIndex = 0;
  bool _isPicking = false;
  bool _isCropping = false;
  PhotoAspectRatio _selectedAspectRatio = PhotoAspectRatio.original;
  bool _showAspectRatioBar = false;


  int? _selectedSoundId;
  Sound? _selectedSound;

  final TransformationController _transformationController = TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformationController.value = _zoomAnimation!.value;
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_croppedImage == null && _selectedRawImage == null) {
        _showImageSourcePicker();
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward(from: 0);
  }

  void _handleDoubleTap(TapDownDetails details) {
    final position = details.localPosition;
    if (_transformationController.value != Matrix4.identity()) {
      _resetZoom();
    } else {
      final double x = -position.dx * 1.5;
      final double y = -position.dy * 1.5;
      final Matrix4 zoomed = Matrix4.identity()
        ..setTranslationRaw(x, y, 0.0)
        ..setEntry(0, 0, 2.5)
        ..setEntry(1, 1, 2.5);

      _zoomAnimation = Matrix4Tween(
        begin: _transformationController.value,
        end: zoomed,
      ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
      _animationController.forward(from: 0);
    }
  }

  void _showImageSourcePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return CupertinoActionSheet(
          title: const Text(
            'Select Photos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          message: const Text('Choose how you want to add photos to your post'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                _pickMultiImages();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.photo_on_rectangle, size: 22, color: CupertinoColors.activeBlue),
                  SizedBox(width: 10),
                  Text('Select Multiple Photos (Gallery)'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                _pickAndCropImage(ImageSource.gallery);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.photo, size: 22, color: CupertinoColors.activeBlue),
                  SizedBox(width: 10),
                  Text('Choose Single Photo (Gallery)'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                _pickAndCropImage(ImageSource.camera);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.camera, size: 22, color: CupertinoColors.activeBlue),
                  SizedBox(width: 10),
                  Text('Take Photo (Camera)'),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(sheetContext),
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  Future<void> _pickMultiImages() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final List<File> files = pickedFiles.map((x) => File(x.path)).toList();
        setState(() {
          _selectedImages = files;
          _currentImageIndex = 0;
          _selectedRawImage = files.first;
          _croppedImage = files.first;
        });
      }
    } catch (e) {
      debugPrint('Multi-image pick error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick images: $e')),
        );
      }
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _pickMoreImages() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final List<File> newFiles = pickedFiles.map((x) => File(x.path)).toList();
        setState(() {
          _selectedImages.addAll(newFiles);
        });
      }
    } catch (e) {
      debugPrint('Pick more images error: $e');
    } finally {
      _isPicking = false;
    }
  }

  void _selectImageAtIndex(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      setState(() {
        _currentImageIndex = index;
        _selectedRawImage = _selectedImages[index];
        _croppedImage = _selectedImages[index];
      });
      _resetZoom();
    }
  }

  void _removeImageAtIndex(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      setState(() {
        _selectedImages.removeAt(index);
        if (_selectedImages.isEmpty) {
          _selectedRawImage = null;
          _croppedImage = null;
          _currentImageIndex = 0;
        } else {
          if (_currentImageIndex >= _selectedImages.length) {
            _currentImageIndex = _selectedImages.length - 1;
          }
          _selectedRawImage = _selectedImages[_currentImageIndex];
          _croppedImage = _selectedImages[_currentImageIndex];
        }
      });
      _resetZoom();
    }
  }

  Future<void> _pickAndCropImage(ImageSource source) async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _selectedRawImage = file;
          _croppedImage = file;
          _selectedImages = [file];
          _currentImageIndex = 0;
        });
        await _cropImage(file);
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _cropImage(File imageFile) async {
    setState(() => _isCropping = true);
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 92,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop & Rotate Photo',
            toolbarColor: const Color(0xFF1E1B2E),
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: const Color(0xFF7C3AED),
            dimmedLayerColor: Colors.black.withValues(alpha: 0.8),
            cropFrameColor: const Color(0xFF9F75FF),
            cropGridColor: Colors.white38,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
            ],
          ),
          IOSUiSettings(
            title: 'Crop & Rotate Photo',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
            ],
            aspectRatioPickerButtonHidden: false,
            resetButtonHidden: false,
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if (croppedFile != null) {
        final cropped = File(croppedFile.path);
        setState(() {
          _croppedImage = cropped;
          if (_selectedImages.isNotEmpty && _currentImageIndex < _selectedImages.length) {
            _selectedImages[_currentImageIndex] = cropped;
          }
        });
        _resetZoom();
      }
    } catch (e) {
      debugPrint('Crop error: $e');
      if (mounted) {
        // Fallback: Enable inline Aspect Ratio selector bar if plugin is unavailable
        setState(() {
          _showAspectRatioBar = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Select Crop Ratio below to crop photo format'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCropping = false);
      }
    }
  }

  void _onClose() {
    Navigator.of(context).maybePop();
  }

  Future<void> _onMusicTap() async {
    final result = await Get.to(() => const SoundTrackScreeen());
    if (result != null && mounted) {
      if (result is Sound) {
        setState(() {
          _selectedSound = result;
          _selectedSoundId = result.id;
        });
      } else if (result is int) {
        setState(() {
          _selectedSoundId = result;
        });
      }
    }
  }

  void _onCropTap() {
    final imageToCrop = _croppedImage ?? _selectedRawImage;
    if (imageToCrop != null) {
      setState(() {
        _showAspectRatioBar = !_showAspectRatioBar;
      });
      _cropImage(imageToCrop);
    } else {
      _showImageSourcePicker();
    }
  }

  void _onContinue() {
    final List<File> imagesToPass = _selectedImages.isNotEmpty
        ? _selectedImages
        : (_croppedImage != null
            ? [_croppedImage!]
            : (_selectedRawImage != null ? [_selectedRawImage!] : []));

    if (imagesToPass.isEmpty) {
      _showImageSourcePicker();
      return;
    }

    Get.to(() => UploadPostScreen(
          photoFile: imagesToPass.first,
          photoFiles: imagesToPass,
          thumbnailPath: imagesToPass.first.path,
          soundId: _selectedSoundId,
          postType: 'photo',
        ));
  }

  double? _getAspectRatioValue() {
    switch (_selectedAspectRatio) {
      case PhotoAspectRatio.square:
        return 1.0;
      case PhotoAspectRatio.ratio4x3:
        return 4.0 / 3.0;
      case PhotoAspectRatio.ratio16x9:
        return 16.0 / 9.0;
      case PhotoAspectRatio.ratio3x2:
        return 3.0 / 2.0;
      case PhotoAspectRatio.original:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeImage = _croppedImage ?? _selectedRawImage;
    final double? aspectRatio = _getAspectRatioValue();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Professional Interactive Zoom & Pan Photo Preview Container
          Positioned.fill(
            child: activeImage != null
                ? GestureDetector(
                    onDoubleTapDown: _handleDoubleTap,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 1.0,
                      maxScale: 4.5,
                      clipBehavior: Clip.none,
                      child: Center(
                        child: aspectRatio != null
                            ? AspectRatio(
                                aspectRatio: aspectRatio,
                                child: Image.file(
                                  activeImage,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.file(
                                activeImage,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _showImageSourcePicker,
                    child: Container(
                      color: const Color(0xFF191826),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white54,
                            size: 64.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Tap to Select Photo',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Camera or Gallery',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          // Top gradient shadow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180.h,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.black.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom gradient shadow
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 220.h,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.75),
                      Colors.black.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Loading overlay when cropping
          if (_isCropping)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: const Color(0xFF9F75FF)),
                      SizedBox(height: 14.h),
                      Text(
                        'Opening Crop Editor...',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // UI Layer
          SafeArea(
            child: Column(
              children: [
                // Header Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _CircleIconButton(
                        icon: Icons.close,
                        onTap: _onClose,
                      ),
                      Expanded(
                        child: Text(
                          _selectedImages.length > 1
                              ? 'Upload Photos (${_currentImageIndex + 1}/${_selectedImages.length})'
                              : 'Upload Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _CircleIconButton(
                        icon: Icons.photo_library_outlined,
                        onTap: _showImageSourcePicker,
                      ),
                    ],
                  ),
                ),

                if (_selectedSound != null) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0xFF9F75FF).withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: Color(0xFF9F75FF),
                          size: 16,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            '${_selectedSound?.title ?? ''} • ${_selectedSound?.artist ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSound = null;
                              _selectedSoundId = null;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 16.h),

                // Side Actions (Music, Crop, Reset Zoom)
                Padding(
                  padding: EdgeInsets.only(right: 16.0.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _PillButton(
                          label: _selectedSound != null ? 'Music ✓' : 'Music',
                          iconData: Icons.music_note_rounded,
                          onTap: _onMusicTap,
                        ),
                        SizedBox(height: 14.h),
                        _PillButton(
                          label: 'Crop',
                          iconData: Icons.crop_rotate_rounded,
                          onTap: _onCropTap,
                        ),
                        if (activeImage != null) ...[
                          SizedBox(height: 14.h),
                          _PillButton(
                            label: 'Reset Zoom',
                            iconData: Icons.zoom_out_map_rounded,
                            onTap: _resetZoom,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Multi-Image Preview Strip (if user selected multiple images)
                if (_selectedImages.length > 1)
                  Container(
                    height: 74.h,
                    margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length + 1,
                      separatorBuilder: (context, index) => SizedBox(width: 8.w),
                      itemBuilder: (context, idx) {
                        if (idx == _selectedImages.length) {
                          return GestureDetector(
                            onTap: _pickMoreImages,
                            child: Container(
                              width: 58.w,
                              height: 74.h,
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.white70,
                                size: 24.sp,
                              ),
                            ),
                          );
                        }
                        final file = _selectedImages[idx];
                        final isCurrent = idx == _currentImageIndex;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => _selectImageAtIndex(idx),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 58.w,
                                height: 74.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isCurrent ? const Color(0xFF9F75FF) : Colors.transparent,
                                    width: 2.2,
                                  ),
                                  image: DecorationImage(
                                    image: FileImage(file),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () => _removeImageAtIndex(idx),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF3F55),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                            if (isCurrent)
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    '${idx + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                // Aspect Ratio Selector Bar (Shows on Crop tap or when tweaking ratio format)
                if (activeImage != null && _showAspectRatioBar)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B2E).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: const Color(0xFF2E2C3E)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _AspectRatioChip(
                              label: 'Original',
                              isSelected: _selectedAspectRatio == PhotoAspectRatio.original,
                              onTap: () => setState(() => _selectedAspectRatio = PhotoAspectRatio.original),
                            ),
                            SizedBox(width: 8.w),
                            _AspectRatioChip(
                              label: '1:1 Square',
                              isSelected: _selectedAspectRatio == PhotoAspectRatio.square,
                              onTap: () => setState(() => _selectedAspectRatio = PhotoAspectRatio.square),
                            ),
                            SizedBox(width: 8.w),
                            _AspectRatioChip(
                              label: '4:3',
                              isSelected: _selectedAspectRatio == PhotoAspectRatio.ratio4x3,
                              onTap: () => setState(() => _selectedAspectRatio = PhotoAspectRatio.ratio4x3),
                            ),
                            SizedBox(width: 8.w),
                            _AspectRatioChip(
                              label: '16:9',
                              isSelected: _selectedAspectRatio == PhotoAspectRatio.ratio16x9,
                              onTap: () => setState(() => _selectedAspectRatio = PhotoAspectRatio.ratio16x9),
                            ),
                            SizedBox(width: 8.w),
                            _AspectRatioChip(
                              label: '3:2',
                              isSelected: _selectedAspectRatio == PhotoAspectRatio.ratio3x2,
                              onTap: () => setState(() => _selectedAspectRatio = PhotoAspectRatio.ratio3x2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Bottom Hint & Continue Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    children: [
                      if (activeImage != null && !_showAspectRatioBar)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.touch_app_outlined, color: Colors.white70, size: 14.sp),
                                SizedBox(width: 6.w),
                                Text(
                                  'Pinch to Zoom & Pan • Double-Tap to Toggle Zoom',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      _ContinueButton(
                        label: activeImage == null
                            ? 'Select Photo'
                            : (_selectedImages.length > 1
                                ? 'Continue (${_selectedImages.length} Photos)'
                                : 'Continue'),
                        onTap: _onContinue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Reusable UI components
// ============================================================

class _AspectRatioChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AspectRatioChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C3AED) : Colors.white10,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF9F75FF) : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12.5.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.4),
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              iconData,
              color: Colors.white,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ContinueButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF7C3AED),
              Color(0xFF6D28D9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}