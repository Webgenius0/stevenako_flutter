import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/home/model/get_user_info_model.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_actions_row.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_app_bar.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_avatar.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_grid_card.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_save_post_card.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_stats_row.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_tab_button.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_video_preview_dialog.dart';
// import 'package:stevenako_flutter/features/setting/model/user_profile_model.dart'; // Commented out: not used directly (getUserProfileRxObj disabled)
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId;
  const ProfileScreen({super.key,   this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _activeTab = 0; // 0: Video, 1: Grid/Photo, 2: Bookmark

  @override
  void initState() {
    super.initState();
    // Defer API calls to after the first frame to avoid
    // "setState() called during build" assertion errors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final dynamic mySavedId = appData.read('user_id');
      final dynamic effectiveId = widget.userId ?? mySavedId;
      if (effectiveId != null) {
        getUserInfoRxObj.getUserInfo(id: effectiveId);
      }
    });
  }

  Future<void> _onRefresh() async {
    final dynamic mySavedId = appData.read('user_id');
    final dynamic effectiveId = widget.userId ?? mySavedId;

    if (effectiveId != null) {
      await getUserInfoRxObj.getUserInfo(id: effectiveId);
    }
  }

  Widget _buildPhotoTabContent(List<PostItem> posts, bool isLoading) {
    if (isLoading && posts.isEmpty) {
      return _buildShimmerPhotoGrid();
    }

    if (posts.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 36.h),
        child: Column(
          children: [
            Icon(
              Icons.photo_library_outlined,
              color: Colors.white38,
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              'No photos uploaded yet',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Your photo posts will appear here',
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.63,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        String imageUrl = '';

        try {
          if (post.media != null && post.media!.isNotEmpty) {
            final firstMedia = post.media!.first;
            if (firstMedia.mediaUrl != null &&
                firstMedia.mediaUrl!.isNotEmpty) {
              imageUrl = firstMedia.mediaUrl!;
            }
          }
        } catch (e) {
          debugPrint('Error parsing photo post media URL: $e');
        }

        final String likesCount = (post.likesCount ?? 0).toString();
        final String commentsCount = (post.commentsCount ?? 0).toString();
        final String viewsCount = (post.viewsCount ?? 0).toString();

        return ProfileGridCard(
          index: index,
          imageUrl: imageUrl,
          viewCount: viewsCount,
          likesCount: likesCount,
          commentsCount: commentsCount,
          showStatsUnder: true,
          overlayIconPath: 'assets/images/gallery.png',
        );
      },
    );
  }

  Widget _buildVideoTabContent(List<PostItem> posts, bool isLoading) {
    if (isLoading && posts.isEmpty) {
      return _buildShimmerPhotoGrid();
    }

    if (posts.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 36.h),
        child: Column(
          children: [
            Icon(
              Icons.video_collection_outlined,
              color: Colors.white38,
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              'No videos uploaded yet',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Your video posts will appear here',
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.63,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        String thumbnailUrl = '';
        try {
          if (post.media != null && post.media!.isNotEmpty) {
            final firstMedia = post.media!.first;
            if (firstMedia.mediaUrl != null &&
                firstMedia.mediaUrl!.isNotEmpty) {
              thumbnailUrl = firstMedia.mediaUrl!;
            }
          }
        } catch (e) {
          debugPrint('Error parsing video post thumbnail URL: $e');
        }

        final String likesCount = (post.likesCount ?? 0).toString();
        final String commentsCount = (post.commentsCount ?? 0).toString();
        final String viewsCount = (post.viewsCount ?? 0).toString();

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.black,
              builder: (context) => ProfileVideoPreviewDialog(
                posts: posts,
                initialIndex: index,
              ),
            );
          },
          child: ProfileGridCard(
            index: index,
            imageUrl: thumbnailUrl,
            viewCount: viewsCount,
            likesCount: likesCount,
            commentsCount: commentsCount,
            showStatsUnder: true,
            overlayIconPath: 'assets/images/play.png',
          ),
        );
      },
    );
  }

  Widget _buildShimmerPhotoGrid() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E2C),
      highlightColor: const Color(0xFF2E2E42),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.63,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16.r),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerProfileHeader() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E2C),
      highlightColor: const Color(0xFF2E2E42),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 106.r,
            height: 106.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1E1E2C),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: 140.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 90.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) => Container(
                width: 70.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveTabContent(List<PostItem> posts, bool isLoading) {
    if (isLoading && posts.isEmpty) {
      return _buildShimmerPhotoGrid();
    }

    if (posts.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 36.h),
        child: Column(
          children: [
            Icon(
              Icons.article_outlined,
              color: Colors.white38,
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              'No text posts yet',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Your text posts will appear here',
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final String username = post.user?.username ??
            post.user?.name ??
            'User';
        final String avatarUrl = post.user?.avatar ?? '';
        final String content = post.caption ?? '';
        final String likes = (post.likesCount ?? 0).toString();
        final String comments = (post.commentsCount ?? 0).toString();
        final String shares = (post.sharesCount ?? 0).toString();
        final String timeAgo = _formatTimeAgo(post.createdAt);

        String? imageUrl;
        if (post.media != null && post.media!.isNotEmpty) {
          imageUrl = post.media!.first.mediaUrl;
        }

        return ProfileSavePostCard(
          avatarUrl: avatarUrl,
          username: username,
          timeAgo: timeAgo,
          content: content,
          imageUrl: imageUrl,
          likes: likes,
          comments: comments,
          shares: shares,
        );
      },
    );
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return 'Just now';
    final duration = DateTime.now().difference(date);
    if (duration.inDays >= 365) {
      return '${(duration.inDays / 365).floor()}y';
    } else if (duration.inDays >= 30) {
      return '${(duration.inDays / 30).floor()}m';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays}d';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: Builder(
                    builder: (context) {
                      final dynamic mySavedId = appData.read('user_id');
                      final bool isMe = (widget.userId == null) ||
                          (mySavedId != null &&
                              widget.userId.toString() == mySavedId.toString());

                      return ValueListenableBuilder<bool>(
                        valueListenable: getUserInfoRxObj.isLoading,
                        builder: (context, isLoading, child) {
                          return StreamBuilder<GetUserInfoModel>(
                            stream: getUserInfoRxObj.stream,
                            builder: (context, snapshot) {
                              if (isLoading && !snapshot.hasData) {
                                return Column(
                                  children: [
                                    ProfileAppBar(
                                      name: isMe ? 'My Profile' : 'User Profile',
                                      balance: '0.00',
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: _buildShimmerProfileHeader(),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              final userInfo = snapshot.data?.data?.user ??
                                  getUserInfoRxObj
                                      .dataFetcher.valueOrNull?.data?.user;
                              final userPosts = snapshot.data?.data?.posts ??
                                  getUserInfoRxObj
                                      .dataFetcher.valueOrNull?.data?.posts;

                              final String name =
                                  userInfo?.name ?? (isMe ? 'My Profile' : 'User Profile');
                              final String avatarUrl = userInfo?.avatar ?? '';
                              final String username =
                                  (userInfo?.username != null &&
                                          userInfo!.username!.isNotEmpty)
                                      ? (userInfo.username!.startsWith('@')
                                          ? userInfo.username!
                                          : '@${userInfo.username}')
                                      : '';
                              final String bio =
                                  userInfo?.bio?.toString() ?? '';
                              final String likes =
                                  (userInfo?.likesCount ?? 0).toString();
                              final String followers =
                                  (userInfo?.followersCount ?? 0).toString();
                              final String following =
                                  (userInfo?.followingCount ?? 0).toString();

                              return _buildProfileView(
                                name: name,
                                avatarUrl: avatarUrl,
                                username: username,
                                bio: bio,
                                likes: likes,
                                followers: followers,
                                following: following,
                                targetUserId: widget.userId ?? userInfo?.id,
                                isMe: isMe,
                                userPosts: userPosts,
                                isLoading: isLoading,
                              );
                            },
                          );
                        },
                      );

                      /*
                      // Commented out as requested (avoiding /user/me API call):
                      // return ValueListenableBuilder<bool>(
                      //   valueListenable: getUserProfileRxObj.isLoading,
                      //   builder: (context, isLoading, child) {
                      //     return StreamBuilder<UserProfileModel>(
                      //       stream: getUserProfileRxObj.stream,
                      //       builder: (context, snapshot) {
                      //         final user = snapshot.data?.data?.user ??
                      //             getUserProfileRxObj
                      //                 .dataFetcher.valueOrNull?.data?.user;
                      //         return _buildProfileView(...);
                      //       },
                      //     );
                      //   },
                      // );
                      */
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView({
    required String name,
    required String avatarUrl,
    required String username,
    required String bio,
    required String likes,
    required String followers,
    required String following,
    required int? targetUserId,
    required bool isMe,
    required UserPosts? userPosts,
    required bool isLoading,
  }) {
    return Column(
      children: [
        ProfileAppBar(name: name, balance: '250.00'),
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFF7C3AED),
            backgroundColor: const Color(0xFF1E1E2C),
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.only(bottom: 120.h),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  ProfileAvatar(imageUrl: avatarUrl),
                  SizedBox(height: 12.h),
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (username.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      username,
                      style: GoogleFonts.inter(
                        color: Colors.white60,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                  if (bio.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          bio,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8F8FD9),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 20.h),
                  ProfileStatsRow(
                    likes: likes,
                    followers: followers,
                    following: following,
                  ),
                  SizedBox(height: 24.h),
                  ProfileActionsRow(
                    name: name,
                    avatarUrl: avatarUrl,
                    targetUserId: targetUserId,
                    isMe: isMe,
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.h,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        ProfileTabButton(
                          index: 0,
                          activeTab: _activeTab,
                          assetPath: 'assets/images/video.png',
                          onTap: (val) => setState(() => _activeTab = val),
                        ),
                        ProfileTabButton(
                          index: 1,
                          activeTab: _activeTab,
                          assetPath: 'assets/images/gallery.png',
                          onTap: (val) => setState(() => _activeTab = val),
                        ),
                        ProfileTabButton(
                          index: 2,
                          activeTab: _activeTab,
                          assetPath: 'assets/images/save.png',
                          onTap: (val) => setState(() => _activeTab = val),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _activeTab == 2
                        ? _buildSaveTabContent(userPosts?.text ?? [], isLoading)
                        : (_activeTab == 1
                            ? _buildPhotoTabContent(userPosts?.photo ?? [], isLoading)
                            : _buildVideoTabContent(userPosts?.video ?? [], isLoading)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
