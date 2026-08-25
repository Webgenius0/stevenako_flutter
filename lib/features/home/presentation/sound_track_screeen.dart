import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/features/home/data/rx_get_soudn_api/rx.dart';
import 'package:stevenako_flutter/features/home/model/get_soudn_modle.dart';

class SoundTrackScreeen extends StatefulWidget {
  final String soundTitle;
  final String artistName;
  final String coverImageUrl;
  final int postCount;

  const SoundTrackScreeen({
    super.key,
    this.soundTitle = 'Original Sound',
    this.artistName = 'Artist Name',
    this.coverImageUrl =
        'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400',
    this.postCount = 0,
  });

  @override
  State<SoundTrackScreeen> createState() => _SoundTrackScreeenState();
}

class _SoundTrackScreeenState extends State<SoundTrackScreeen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _hintColor = Color(0xFF9C9AAB);
  static const Color _purple = Color(0xFF7C3AED);

  late final GetSoundRx _getSoundRxObj;
  Sound? _selectedSound;

  @override
  void initState() {
    super.initState();
    _getSoundRxObj = GetSoundRx(
      empty: GetuserModel(
        success: false,
        code: 0,
        message: "",
        data: null,
      ),
      dataFetcher: BehaviorSubject<GetuserModel>(),
    );
    _getSoundRxObj.fetchSounds();
  }

  @override
  void dispose() {
    _getSoundRxObj.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  void _onSelectSound(Sound sound) {
    setState(() => _selectedSound = sound);
    Navigator.of(context).pop(sound);
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
              // ---- Top Header Bar ----
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
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
                        'Select Sound',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              // ---- Live Sound StreamBuilder ----
              Expanded(
                child: StreamBuilder<GetuserModel>(
                  stream: _getSoundRxObj.stream,
                  builder: (context, snapshot) {
                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting &&
                            !snapshot.hasData;

                    if (isLoading) {
                      return const _SoundListShimmer();
                    }

                    final sounds = snapshot.data?.data?.sounds ?? [];

                    if (sounds.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.music_off_outlined,
                              color: _hintColor,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No sounds available',
                              style: TextStyle(
                                color: _hintColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _getSoundRxObj.fetchSounds(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _purple,
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      itemCount: sounds.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 14.h),
                      itemBuilder: (context, index) {
                        final sound = sounds[index];
                        final isSelected = _selectedSound?.id == sound.id;

                        return _SoundItemRow(
                          sound: sound,
                          isSelected: isSelected,
                          onTap: () => _onSelectSound(sound),
                        );
                      },
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

/// Shimmer Skeleton Loading Widget for Sound List
class _SoundListShimmer extends StatelessWidget {
  const _SoundListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: 6,
      separatorBuilder: (context, index) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF262338),
          highlightColor: const Color(0xFF3B3654),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF161426),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 90.w,
                        height: 12.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 54.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Sound Item Card Row Widget with CachedNetworkImage and Fallbacks
class _SoundItemRow extends StatelessWidget {
  final Sound sound;
  final bool isSelected;
  final VoidCallback onTap;

  const _SoundItemRow({
    required this.sound,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _hintColor = Color(0xFF9C9AAB);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);

  @override
  Widget build(BuildContext context) {
    final title = sound.title ?? 'Original Sound';
    final artist = sound.artist ?? sound.creator?.name ?? 'Unknown Artist';
    final postsCount = sound.postsCount ?? 0;
    final thumbnailUrl = sound.thumbnailUrl ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? _purple : _cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(16.r),
            color: const Color(0xFF161426),
          ),
          child: Row(
            children: [
              // Cover art thumbnail with CachedNetworkImage & Shimmer
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (thumbnailUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        width: 56.w,
                        height: 56.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: const Color(0xFF262338),
                          highlightColor: const Color(0xFF3B3654),
                          child: Container(
                            width: 56.w,
                            height: 56.h,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 56.w,
                          height: 56.h,
                          color: const Color(0xFF2A2A3E),
                          child: const Icon(
                            Icons.music_note,
                            color: _purpleLight,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 56.w,
                        height: 56.h,
                        color: const Color(0xFF2A2A3E),
                        child: const Icon(
                          Icons.music_note,
                          color: _purpleLight,
                        ),
                      ),
                    Container(
                      width: 56.w,
                      height: 56.h,
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14.w),

              // Title, artist, posts count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _hintColor,
                        fontSize: 13.5.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '$postsCount posts',
                      style: TextStyle(
                        color: _purpleLight,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Select Action Button
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: const LinearGradient(
                      colors: [_purpleLight, _purple],
                    ),
                  ),
                  child: Text(
                    'Use',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
