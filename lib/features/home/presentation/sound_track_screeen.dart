import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================
// SoundTrackScreeen — Sound/audio detail page: cover art, sound
// title, artist link, post count, and a grid of videos using
// this sound. Matches the provided design 1:1.
// (Class name kept exactly as given, typo and all, so it stays
// a drop-in replacement for your existing stub.)
// ============================================================

class _SoundVideo {
  final String thumbnailUrl;
  final String views; // pre-formatted, e.g. "5.6k"
  final String creatorName;
  final String creatorAvatarUrl;
  final bool isVerified;

  const _SoundVideo({
    required this.thumbnailUrl,
    required this.views,
    required this.creatorName,
    required this.creatorAvatarUrl,
    this.isVerified = false,
  });
}

class SoundTrackScreeen extends StatefulWidget {
  final String soundTitle;
  final String artistName;
  final String coverImageUrl;
  final int postCount;

  const SoundTrackScreeen({
    super.key,
    this.soundTitle = 'original sound - axelrosethebullmastiff',
    this.artistName = 'Axel Rose | Bullmastiff',
    this.coverImageUrl =
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400',
    this.postCount = 4366,
  });

  @override
  State<SoundTrackScreeen> createState() => _SoundTrackScreeenState();
}

class _SoundTrackScreeenState extends State<SoundTrackScreeen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _hintColor = Color(0xFF9C9AAB);
  static const Color _badgeRed = Color(0xFFEF4444);

  bool _isSaved = false;

  // TODO: Replace with real videos that use this sound, from your backend.
  final List<_SoundVideo> _videos = const [
    _SoundVideo(
      thumbnailUrl:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      views: '5.6k',
      creatorName: 'Jerome Bell',
      creatorAvatarUrl: 'https://i.pravatar.cc/150?img=5',
      isVerified: true,
    ),
    _SoundVideo(
      thumbnailUrl:
      'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400',
      views: '5.6k',
      creatorName: 'Brooklyn Sim...',
      creatorAvatarUrl: 'https://i.pravatar.cc/150?img=9',
      isVerified: true,
    ),
    _SoundVideo(
      thumbnailUrl:
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
      views: '5.6k',
      creatorName: 'Alex Rivera',
      creatorAvatarUrl: 'https://i.pravatar.cc/150?img=15',
      isVerified: false,
    ),
    _SoundVideo(
      thumbnailUrl:
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400',
      views: '5.6k',
      creatorName: 'Morgan Lee',
      creatorAvatarUrl: 'https://i.pravatar.cc/150?img=20',
      isVerified: true,
    ),
  ];

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  void _onToggleSave() {
    setState(() => _isSaved = !_isSaved);
    // TODO: persist saved/bookmarked sound to backend
  }

  void _onArtistTap() {
    // TODO: navigate to the artist's profile
  }

  void _onVideoTap(_SoundVideo video) {
    // TODO: open this video in the feed/player
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
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 30),
                    ),
                    IconButton(
                      onPressed: _onToggleSave,
                      icon: Image.asset(
                        'assets/images/bookmarkIcon.png',
                        width: 26,
                        height: 26,
                        color: _isSaved ?   Colors.red : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Sound info + cover art
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover art with play overlay
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            widget.coverImageUrl,
                            width: 152,
                            height: 152,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 152,
                                  height: 152,
                                  color: const Color(0xFF2A2A3A),
                                ),
                          ),
                          Container(
                            width: 152,
                            height: 152,
                            color: Colors.black.withOpacity(0.15),
                          ),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.25),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Title, artist, post count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.soundTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: _onArtistTap,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.artistName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right,
                                    color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '${widget.postCount} posts',
                            style: const TextStyle(
                              color: _hintColor,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Video grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                  itemCount: _videos.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    return _VideoTile(
                      video: video,
                      onTap: () => _onVideoTap(video),
                    );
                  },
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
// Reusable grid tile
// ============================================================

class _VideoTile extends StatelessWidget {
  final _SoundVideo video;
  final VoidCallback onTap;

  const _VideoTile({required this.video, required this.onTap});

  static const Color _badgeRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              video.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF2A2A3A),
              ),
            ),

            // Bottom gradient for legible name/avatar overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 70,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // View count badge (top-right)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/palyIcon.png',height: 11.h,width: 11.w,),
                      SizedBox(width: 4.w),
                    Text(
                      video.views,
                      style:   TextStyle(
                        color: Colors.white,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Creator row (bottom-left)
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      video.creatorAvatarUrl,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 24,
                        height: 24,
                        color: const Color(0xFF2A2A3A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      video.creatorName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (video.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.verified,
                        color: _badgeRed, size: 14),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}