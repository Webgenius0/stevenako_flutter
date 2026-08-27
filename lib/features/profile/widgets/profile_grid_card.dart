import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class ProfileGridCard extends StatefulWidget {
  final String imageUrl;
  final String? thumbnailUrl;
  final String viewCount;
  final String likesCount;
  final String commentsCount;
  final bool showStatsUnder;
  final String overlayIconPath;
  final VoidCallback? onTap;
  final String? caption;
  final int index;

  const ProfileGridCard({
    super.key,
    required this.imageUrl,
    this.thumbnailUrl,
    required this.viewCount,
    this.likesCount = '0',
    this.commentsCount = '0',
    this.showStatsUnder = false,
    this.overlayIconPath = 'assets/images/play_icon.png',
    this.onTap,
    this.caption,
    this.index = 0,
  });

  @override
  State<ProfileGridCard> createState() => _ProfileGridCardState();
}

class _ProfileGridCardState extends State<ProfileGridCard> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoError = false;

  bool _isVideoUrl(String url) {
    if (url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.contains('.mp4') ||
        lower.contains('.mov') ||
        lower.contains('.m4v') ||
        lower.contains('.webm') ||
        lower.contains('.avi') ||
        lower.contains('.mkv');
  }

  @override
  void initState() {
    super.initState();
    _checkAndInitVideo();
  }

  @override
  void didUpdateWidget(covariant ProfileGridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _videoController?.dispose();
      _videoController = null;
      _isVideoInitialized = false;
      _isVideoError = false;
      _checkAndInitVideo();
    }
  }

  Future<void> _checkAndInitVideo() async {
    final String cleanUrl = widget.imageUrl.trim();
    final String cleanThumb = (widget.thumbnailUrl ?? '').trim();

    // Only initialize VideoPlayerController if no static thumbnail image exists and main URL is a video
    if (cleanThumb.isEmpty && _isVideoUrl(cleanUrl)) {
      try {
        final Uri uri = Uri.parse(cleanUrl);
        _videoController = VideoPlayerController.networkUrl(
          uri,
          httpHeaders: const {
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
          },
        );

        await _videoController!.initialize();
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
        }
      } catch (e) {
        debugPrint('ProfileGridCard video frame init error: $e');
        if (mounted) {
          setState(() {
            _isVideoError = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  static const List<List<Color>> _cardGradients = [
    [Color(0xFF2A2A3D), Color(0xFF1E1E2C)],
    [Color(0xFF3A1C71), Color(0xFF1E1E2C)],
    [Color(0xFF4A00E0), Color(0xFF1E1E2C)],
    [Color(0xFF005C97), Color(0xFF1E1E2C)],
  ];

  @override
  Widget build(BuildContext context) {
    String cleanUrl = widget.imageUrl.trim();
    String cleanThumb = (widget.thumbnailUrl ?? '').trim();

    String displayImageUrl = cleanThumb.isNotEmpty
        ? cleanThumb
        : (!_isVideoUrl(cleanUrl) ? cleanUrl : '');

    final bool hasValidImage = displayImageUrl.isNotEmpty;
    final List<Color> fallbackGradient =
        _cardGradients[widget.index % _cardGradients.length];

    final imageCard = InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // ---------------- Real Video Frame / Network Image / Fallback ----------------
              Positioned.fill(
                child: _isVideoInitialized && _videoController != null
                    ? FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _videoController!.value.size.width > 0
                              ? _videoController!.value.size.width
                              : 100,
                          height: _videoController!.value.size.height > 0
                              ? _videoController!.value.size.height
                              : 100,
                          child: VideoPlayer(_videoController!),
                        ),
                      )
                    : (hasValidImage
                        ? CachedNetworkImage(
                            imageUrl: displayImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: const Color(0xFF1E1E2C),
                              highlightColor: const Color(0xFF2E2E42),
                              child: Container(
                                color: const Color(0xFF1E1E2C),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: fallbackGradient,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white70,
                                  size: 40.r,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: fallbackGradient,
                              ),
                            ),
                            child: Center(
                              child: _isVideoError
                                  ? Icon(
                                      Icons.play_circle_fill_rounded,
                                      color: const Color(0xFF9F75FF),
                                      size: 36.r,
                                    )
                                  : const CircularProgressIndicator(
                                      color: Color(0xFF9F75FF),
                                      strokeWidth: 2,
                                    ),
                            ),
                          )),
              ),

              // ---------------- Gradient Overlay for Contrast ----------------
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // ---------------- Play Icon Overlay in Center ----------------
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26.r,
                    ),
                  ),
                ),
              ),

              // ---------------- Caption Preview if available ----------------
              if (widget.caption != null && widget.caption!.trim().isNotEmpty)
                Positioned(
                  left: 10.w,
                  right: 10.w,
                  bottom: widget.showStatsUnder ? 10.h : 34.h,
                  child: Text(
                    widget.caption!.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              // ---------------- Views Counter ----------------
              if (!widget.showStatsUnder)
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          widget.overlayIconPath,
                          width: 12.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          widget.viewCount,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
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
    );

    if (widget.showStatsUnder) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: imageCard),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/heart.png',
                  color: Colors.white,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 4.w),
                Text(
                  widget.likesCount,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),
                Image.asset(
                  'assets/images/message.png',
                  color: Colors.white,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 4.w),
                Text(
                  widget.commentsCount,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),
                Image.asset(
                  'assets/images/Share.png',
                  color: Colors.white,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return imageCard;
  }
}
