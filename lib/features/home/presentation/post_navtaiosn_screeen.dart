import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/features/home/model/get_all_post_model.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';
import 'package:stevenako_flutter/features/home/presentation/widgets/home_report_bottom_sheet.dart';
import 'package:stevenako_flutter/features/profile/presentation/profile_screen.dart';
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/helpers/ui_helpers.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:stevenako_flutter/provider/post_comments_provider.dart';


class PostsSubScreenTwo extends StatefulWidget {
  const PostsSubScreenTwo({super.key});

  @override
  State<PostsSubScreenTwo> createState() => _PostsSubScreenTwoState();
}

class _PostsSubScreenTwoState extends State<PostsSubScreenTwo> {
  final Set<int> _likedPostIds = {};
  final Map<int, int> _extraLikes = {};

  @override
  void initState() {
    super.initState();
    getAllPostRxObj.getAllPosts();
  }

  Future<void> _refreshPosts() async {
    await getAllPostRxObj.getAllPosts();
  }

  void _showPostOptions(BuildContext context, PostItem post, int index) {
    final int? postId = post.id;
    final String caption = post.caption ?? post.title ?? '';
    final String postUrl = post.mediaUrl ??
        (post.media != null && post.media!.isNotEmpty
            ? (post.media!.first.mediaUrl ?? '')
            : '');
    final String shareText = caption.isNotEmpty
        ? caption
        : (postUrl.isNotEmpty ? postUrl : 'Check out this post on Stevenako!');

    final dynamic savedUserId =
        appData.read('user_id') ?? appData.read(kKeyUserID);
    final dynamic profileUserId =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
    final String? currentIdStr =
        (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
            ? savedUserId.toString().trim()
            : profileUserId?.toString().trim();
    final String? postUserIdStr = post.user?.id?.toString().trim();
    final bool isOwnPost = post.isMyPost == true ||
        (currentIdStr != null &&
            postUserIdStr != null &&
            currentIdStr == postUserIdStr);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('Post Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post saved!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.bookmark, size: 20),
                  SizedBox(width: 8),
                  Text('Save post'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                _showShareOptions(context, postId, shareText, isOwnPost: isOwnPost);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.share, size: 20),
                  SizedBox(width: 8),
                  Text('Share post'),
                ],
              ),
            ),
            if (isOwnPost) ...[
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.pencil, size: 20),
                    SizedBox(width: 8),
                    Text('Edit post'),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(index, postId);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.delete, size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Delete post'),
                  ],
                ),
              ),
            ] else ...[
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  HomeReportBottomSheet.show(context, postId: postId);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.exclamationmark_triangle, size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Report post'),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  final authorId = post.user?.id;
                  final authorName = post.user?.username ?? post.user?.name ?? 'User';
                  if (authorId != null) {
                    _confirmBlockUser(authorId.toString(), authorName);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.slash_circle, size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Block user'),
                  ],
                ),
              ),
            ],
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

  void _showShareOptions(BuildContext context, int? postId, String shareText, {bool isOwnPost = false}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return CupertinoActionSheet(
          title: const Text('Share Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                Clipboard.setData(ClipboardData(text: shareText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.doc_on_doc, size: 20),
                  SizedBox(width: 8),
                  Text('Copy Post Text / Link'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                SharePlus.instance.share(ShareParams(text: shareText));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.share_up, size: 20),
                  SizedBox(width: 8),
                  Text('Share via App...'),
                ],
              ),
            ),
            if (!isOwnPost)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  HomeReportBottomSheet.show(context, postId: postId);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.exclamationmark_triangle, size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Report Post'),
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

  void _confirmDelete(int index, dynamic postId) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Delete Post?'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('This action cannot be undone. Are you sure you want to delete this post?'),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(dialogContext);
                if (postId != null) {
                  final bool success =
                      await deletePostRxObj.deletePost(postId);
                  if (success) {
                    ToastUtil.showShortToast('Post deleted successfully');
                    getAllPostRxObj.getAllPosts();
                  } else {
                    ToastUtil.showShortToast('Failed to delete post. Please try again.');
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmBlockUser(String userId, String username) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text('Block @$username?'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'They will no longer be able to message you, view your profile, or see your posts. You will not see their content in your feed.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(dialogContext);
                final res = await blockOrUnblockUserRxObj.blockOrUnblockUser(userId);
                if (res != null) {
                  ToastUtil.showShortToast('User blocked successfully');
                  _refreshPosts();
                } else {
                  ToastUtil.showShortToast('Failed to block user. Please try again.');
                }
              },
              child: const Text('Block'),
            ),
          ],
        );
      },
    );
  }

  // ---------- Comments bottom sheet with Provider & Apple Cupertino Design ----------
  void _showCommentsSheet(Map<String, dynamic> postData) {
    final String postKey = postData['postId']?.toString() ??
        postData['id']?.toString() ??
        'post_${postData['userName']}_${(postData['text'] ?? '').hashCode}';

    final commentsProvider =
        Provider.of<PostCommentsProvider>(context, listen: false);
    commentsProvider.initializeComments(postKey, postData['comments']);
    commentsProvider.setActivePost(postKey);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _CommentsSheet(
          post: postData,
          postKey: postKey,
          onCommentsChanged: (updatedComments) {
            setState(() {
              postData['comments'] = updatedComments;
            });
          },
        );
      },
    );
  }



  Widget _buildAvatarImage(String? url) {
    if (url == null || url.isEmpty) {
      return   CircleAvatar(
        radius: 18.r,
        backgroundColor: Color(0xFF2A2A3A),
        child: Icon(Icons.person, color: Colors.white54, size: 20),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 36.w,
        height: 36.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: const Color(0xFF1E1E2C),
          highlightColor: const Color(0xFF2E2E42),
          child: Container(
            width: 36.w,
            height: 36.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1E1E2C),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF2A2A3A),
          child: const Icon(Icons.person, color: Colors.white54, size: 20),
        ),
      ),
    );
  }

  String _resolveFullMediaUrl(String? mediaPath) {
    if (mediaPath == null || mediaPath.trim().isEmpty) return '';
    final trimmed = mediaPath.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) {
      return 'https://dashboard.realmworldapp.live$trimmed';
    }
    return 'https://dashboard.realmworldapp.live/$trimmed';
  }

  bool _isVideoUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final cleanUrl = url.trim().toLowerCase();
    return cleanUrl.endsWith('.mp4') ||
        cleanUrl.endsWith('.mov') ||
        cleanUrl.endsWith('.avi') ||
        cleanUrl.endsWith('.webm') ||
        cleanUrl.endsWith('.m3u8') ||
        cleanUrl.endsWith('.mkv') ||
        cleanUrl.contains('/posts-videos');
  }

  bool _isDisplayableImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final fullUrl = _resolveFullMediaUrl(url);
    if (_isVideoUrl(fullUrl)) return false;

    final cleanUrl = fullUrl.toLowerCase();
    if (cleanUrl.contains('mixkit.co')) return false;
    return cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://');
  }

  void _openImageFullscreen(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.95),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: Colors.white38,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12.h,
                  right: 16.w,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostMediaImage(String? rawUrl) {
    final fullUrl = _resolveFullMediaUrl(rawUrl);
    if (!_isDisplayableImageUrl(fullUrl)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: GestureDetector(
        onTap: () => _openImageFullscreen(context, fullUrl),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 160.h,
              maxHeight: 380.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF151422),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 0.8,
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: fullUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              imageBuilder: (context, imageProvider) => Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 160.h,
                  maxHeight: 380.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: const Color(0xFF1E1E2C),
                highlightColor: const Color(0xFF2E2E42),
                child: Container(
                  height: 200.h,
                  width: double.infinity,
                  color: const Color(0xFF1E1E2C),
                ),
              ),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: const Color(0xFF0F0E17),
        padding: EdgeInsets.only(top: 60.h),
        child: RefreshIndicator(
          color: const Color(0xFF8B5CF6),
          backgroundColor: Colors.black,
          onRefresh: _refreshPosts,
          child: StreamBuilder<GetAllPostModel>(
            stream: getAllPostRxObj.dataFetcher.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const PostsShimmerLoader();
              }

              if (snapshot.hasError) {
                final String cleanError =
                    ToastUtil.cleanErrorMessage(snapshot.error);
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Container(
                            padding: EdgeInsets.all(24.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E2C).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color:   Color(0xFFEF4444).withValues(alpha: 0.3),
                                width: 1.w,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.wifi_off_rounded,
                                  color: const Color(0xFFEF4444),
                                  size: 44.r,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Unable to load posts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  cleanError,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton.icon(
                                  onPressed: _refreshPosts,
                                  icon: Icon(Icons.refresh_rounded, size: 18.r),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8B5CF6),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              final List<PostItem> livePosts =
                  snapshot.data?.data?.posts?.data ?? [];

              if (livePosts.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20.r),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E2C),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Icon(
                                  Icons.dynamic_feed_rounded,
                                  color: const Color(0xFF8B5CF6),
                                  size: 42.r,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No Posts Yet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Be the first to share something with the community!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13.sp,
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

              return LiveList.options(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.only(
                  top: 8.h,
                  bottom: 120.h,
                  left: 16.w,
                  right: 16.w,
                ),
                options: const LiveOptions(
                  delay: Duration(milliseconds: 40),
                  showItemInterval: Duration(milliseconds: 80),
                  showItemDuration: Duration(milliseconds: 250),
                  visibleFraction: 0.05,
                ),
                itemCount: livePosts.length,
                itemBuilder: (context, index, animation) {
                  final PostItem postModel = livePosts[index];
                  final int postId = postModel.id ?? index;
                  final bool isLiked = _likedPostIds.contains(postId) ||
                      (postModel.isLiked == true);
                  final int likesCount =
                      (postModel.likesCount ?? 0) + (_extraLikes[postId] ?? 0);
                  final int commentsCount = postModel.commentsCount ?? 0;

                  String? mediaUrl = postModel.mediaUrl;
                  if ((mediaUrl == null ||
                          mediaUrl.isEmpty ||
                          mediaUrl.contains('mixkit.co')) &&
                      postModel.media != null &&
                      postModel.media!.isNotEmpty) {
                    final validMedia = postModel.media!.firstWhere(
                      (m) =>
                          m.mediaUrl != null &&
                          m.mediaUrl!.trim().isNotEmpty &&
                          !m.mediaUrl!.contains('mixkit.co'),
                      orElse: () => postModel.media!.first,
                    );
                    mediaUrl = validMedia.mediaUrl;
                  }

                  final String avatarUrl = postModel.user?.avatar ?? '';
                  final String userName = postModel.user?.name ??
                      postModel.user?.username ??
                      'Community Member';
                  final String timeText = postModel.createdAt != null
                      ? '${postModel.createdAt!.hour}:${postModel.createdAt!.minute} '
                      : 'Just now';
                  final String captionText =
                      postModel.caption ?? postModel.title ?? '';

                  final Map<String, dynamic> postDataForSheet = {
                    'postId': postId,
                    'id': postId,
                    'userName': userName,
                    'avatar': avatarUrl,
                    'text': captionText,
                    'comments': <Map<String, String>>[],
                  };


                  final dynamic savedUserId =
                      appData.read('user_id') ?? appData.read(kKeyUserID);
                  final dynamic profileUserId =
                      getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
                  final String? currentIdStr =
                      (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
                          ? savedUserId.toString().trim()
                          : profileUserId?.toString().trim();
                  final String? postUserIdStr = postModel.user?.id?.toString().trim();
                  final bool isOwnPost = postModel.isMyPost == true ||
                      (currentIdStr != null &&
                          postUserIdStr != null &&
                          currentIdStr == postUserIdStr);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _buildSinglePostCard(
                          index: index,
                          postId: postId,
                          avatarUrl: avatarUrl,
                          userName: userName,
                          timeText: timeText,
                          captionText: captionText,
                          mediaUrl: mediaUrl,
                          isLiked: isLiked,
                          likesCount: likesCount,
                          commentsCount: commentsCount,
                          postDataForSheet: postDataForSheet,
                          userId: postModel.user?.id,
                          isOwnPost: isOwnPost,
                          onDeleteTap: () => _confirmDelete(index, postId),
                          onLikeTap: () {
                            setState(() {
                              if (_likedPostIds.contains(postId)) {
                                _likedPostIds.remove(postId);
                                _extraLikes[postId] =
                                    (_extraLikes[postId] ?? 0) - 1;
                              } else {
                                _likedPostIds.add(postId);
                                _extraLikes[postId] =
                                    (_extraLikes[postId] ?? 0) + 1;
                              }
                            });
                          },
                          onMoreTap: () =>
                              _showPostOptions(context, postModel, index),
                          onShareTap: () {
                            _showShareOptions(
                              context,
                              postId,
                              captionText.isNotEmpty
                                  ? captionText
                                  : (mediaUrl ?? 'Check out this post on Stevenako!'),
                              isOwnPost: isOwnPost,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSinglePostCard({
    required int index,
    required int postId,
    required String avatarUrl,
    required String userName,
    required String timeText,
    required String captionText,
    required String? mediaUrl,
    required bool isLiked,
    required int likesCount,
    required int commentsCount,
    required Map<String, dynamic> postDataForSheet,
    required VoidCallback onLikeTap,
    required VoidCallback onMoreTap,
    required VoidCallback onShareTap,
    bool isOwnPost = false,
    VoidCallback? onDeleteTap,
    int? userId,
  }) {
    final String resolvedMediaUrl = _resolveFullMediaUrl(mediaUrl);
    final bool hasImage = _isDisplayableImageUrl(resolvedMediaUrl);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: hasImage ? 14.h : 10.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(hasImage ? 16.r : 12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize
            .min, // Ensures tight fitting around text for text-only posts
        children: [
          // Header
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(userId: userId),
                    ),
                  );
                },
                child: _buildAvatarImage(_resolveFullMediaUrl(avatarUrl)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: userId),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      Text(
                        timeText,
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isOwnPost && onDeleteTap != null)
                GestureDetector(
                  onTap: onDeleteTap,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D4D).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFFF4D4D),
                      size: 18,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: onMoreTap,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.more_horiz, color: Colors.white54),
                ),
              ),
            ],
          ),

          // Caption Text
          if (captionText.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              captionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],

          // Media Content (ONLY rendered if valid image exists, NO dummy boxes)
          if (hasImage) ...[_buildPostMediaImage(resolvedMediaUrl)],

          SizedBox(height: hasImage ? 12.h : 8.h),

          // Action Bar
          Row(
            children: [
              GestureDetector(
                onTap: onLikeTap,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? const Color(0xFFFF3F55) : Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$likesCount',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _showCommentsSheet(postDataForSheet),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/mesagenva.png',
                      height: 17.w,
                      width: 17.w,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                      SizedBox(width: 6.w),
                    Builder(
                      builder: (ctx) {
                        final String postKey = postId.toString();

                        final dynamicCommentsCount =
                            ctx.watch<PostCommentsProvider>().getCommentCount(postKey);
                        final totalComments =
                            (commentsCount > 0 ? commentsCount : 0) +
                            dynamicCommentsCount;
                        return Text(
                          '$totalComments',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                          ),
                        );
                      },
                    ),
                  ],

                ),
              ),
              UIHelper.horizontalSpace(16.w),
              GestureDetector(
                onTap: onShareTap,
                child: Image.asset(
                  'assets/icons/sheee.png',
                  height: 17.w,
                  width: 17.w,
                  errorBuilder: (context, error, stackTrace) =>   Icon(
                    Icons.share_outlined,
                    color: Colors.white70,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostsShimmerLoader extends StatefulWidget {
  const PostsShimmerLoader({super.key});

  @override
  State<PostsShimmerLoader> createState() => _PostsShimmerLoaderState();
}

class _PostsShimmerLoaderState extends State<PostsShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.15 + (_controller.value * 0.25);
        final color = Colors.white.withValues(alpha: opacity);

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w, bottom: 24.h),
          itemCount: 3,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 70.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 200.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.r),
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

// ==========================================
// Comments Bottom Sheet Widget (Provider State Management & Apple Cupertino Design)
// ==========================================
class _CommentsSheet extends StatefulWidget {
  final Map<String, dynamic> post;
  final String postKey;
  final ValueChanged<List<Map<String, String>>> onCommentsChanged;

  const _CommentsSheet({
    required this.post,
    required this.postKey,
    required this.onCommentsChanged,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider =
            Provider.of<PostCommentsProvider>(context, listen: false);
        provider.setActivePost(widget.postKey);
        provider.initializeComments(widget.postKey, widget.post['comments']);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitComment(PostCommentsProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    provider.addComment(
      postKey: widget.postKey,
      text: text,
      userName: provider.getCurrentUserName(),
      avatar: provider.getCurrentUserAvatar(),
      userId: provider.getCurrentUserId(),
    );

    widget.onCommentsChanged(
      provider.getComments(widget.postKey).map((c) => c.toMap()).toList(),
    );
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _startReply(PostCommentsProvider provider, int index) {
    provider.startReply(index);
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _startEdit(
    PostCommentsProvider provider,
    int index,
    String currentText,
  ) {
    provider.startEdit(index);
    _controller.text = currentText;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _focusNode.requestFocus();
  }

  void _cancelReplyOrEdit(PostCommentsProvider provider) {
    provider.cancelReplyOrEdit();
    _controller.clear();
    _focusNode.unfocus();
  }

  void _deleteComment(PostCommentsProvider provider, int index) {
    provider.deleteComment(postKey: widget.postKey, index: index);
    widget.onCommentsChanged(
      provider.getComments(widget.postKey).map((c) => c.toMap()).toList(),
    );
  }

  // Apple CupertinoActionSheet for comment options
  void _showCommentOptions(
    BuildContext context,
    PostCommentsProvider provider,
    int index,
    PostCommentItem comment,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (actionSheetContext) {
        return CupertinoActionSheet(
          title: Text(
            'Comment by ${comment.userName}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          message: Text(
            comment.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(actionSheetContext);
                _startReply(provider, index);
              },
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.reply, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text('Reply'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(actionSheetContext);
                _startEdit(provider, index, comment.text);
              },
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.pencil, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text('Edit'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(actionSheetContext);
                Clipboard.setData(ClipboardData(text: comment.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment copied to clipboard!')),
                );
              },
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.doc_on_doc, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text('Copy text'),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(actionSheetContext);
              _confirmDeleteComment(context, provider, index);
            },
            child:   Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.delete,
                    size: 18.sp, color: CupertinoColors.destructiveRed),
                SizedBox(width: 8.w),
                Text('Delete'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Apple CupertinoAlertDialog for delete confirmation
  void _confirmDeleteComment(
    BuildContext context,
    PostCommentsProvider provider,
    int index,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Delete Comment?'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'This action cannot be undone. Are you sure you want to delete this comment?',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(dialogContext);
                _deleteComment(provider, index);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment deleted.')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCommentsProvider>(
      builder: (context, provider, child) {
        final comments = provider.getComments(widget.postKey);
        final replyingIndex = provider.replyingToIndex;
        final editingIndex = provider.editingIndex;
        final currentUserAvatar = provider.getCurrentUserAvatar();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Comments (${comments.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white12, height: 1),

                  // Comments list
                  Expanded(
                    child: comments.isEmpty
                        ? const Center(
                            child: Text(
                              'No comments yet.\nBe the first to comment!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 13),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              final replyTo = comment.replyTo;
                              final wasEdited = comment.edited;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 18),
                                child: GestureDetector(
                                  onLongPress: () => _showCommentOptions(
                                    context,
                                    provider,
                                    index,
                                    comment,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          final dynamic rawUserId =
                                              comment.userId;
                                          final int? userId = rawUserId is int
                                              ? rawUserId
                                              : int.tryParse(
                                                  rawUserId?.toString() ?? '',
                                                );
                                          if (userId != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                        userId: userId),
                                              ),
                                            );
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: comment.avatar.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: comment.avatar,
                                                  width: 32,
                                                  height: 32,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url, error) =>
                                                      _buildAvatarFallback(
                                                          comment.userName),
                                                )
                                              : _buildAvatarFallback(
                                                  comment.userName),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (replyTo != null &&
                                                replyTo.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3),
                                                child: Text(
                                                  'Replying to $replyTo',
                                                  style: const TextStyle(
                                                    color: Color(0xFFFF3F55),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              comment.userName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              comment.text,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                if (wasEdited)
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      'edited',
                                                      style: TextStyle(
                                                        color: Colors.white30,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                GestureDetector(
                                                  onTap: () => _startReply(
                                                      provider, index),
                                                  child: const Text(
                                                    'Reply',
                                                    style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                GestureDetector(
                                                  onTap: () => _startEdit(
                                                      provider,
                                                      index,
                                                      comment.text),
                                                  child: const Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                GestureDetector(
                                                  onTap: () =>
                                                      _confirmDeleteComment(
                                                          context,
                                                          provider,
                                                          index),
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Color(0xFFFF3F55),
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showCommentOptions(
                                          context,
                                          provider,
                                          index,
                                          comment,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            CupertinoIcons.ellipsis,
                                            color: Colors.white38,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // Reply / Edit banner
                  if (replyingIndex != null || editingIndex != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: const Color(0xFF2A2A3A),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              editingIndex != null
                                  ? 'Editing comment'
                                  : (replyingIndex != null &&
                                          replyingIndex < comments.length)
                                      ? 'Replying to ${comments[replyingIndex].userName}'
                                      : 'Replying to comment',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _cancelReplyOrEdit(provider),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white54,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Input field
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: currentUserAvatar.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: currentUserAvatar,
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        _buildAvatarFallback(
                                            provider.getCurrentUserName()),
                                  )
                                : _buildAvatarFallback(
                                    provider.getCurrentUserName()),
                          ),

                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                              ),
                              decoration: InputDecoration(
                                hintText: editingIndex != null
                                    ? 'Edit your comment...'
                                    : replyingIndex != null
                                    ? 'Write a reply...'
                                    : 'Add a comment...',
                                hintStyle:
                                    const TextStyle(color: Colors.white38),
                                filled: true,
                                fillColor: const Color(0xFF2A2A3A),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onSubmitted: (_) => _submitComment(provider),
                              textInputAction: TextInputAction.send,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _submitComment(provider),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF3F55),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAvatarFallback(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF8B5CF6),
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

