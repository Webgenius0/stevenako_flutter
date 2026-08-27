import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;

  const ProfileAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final String cleanUrl = imageUrl.trim();

    return Center(
      child: Stack(
        children: [
          Container(
            width: 106.r,
            height: 106.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF27273A),
            ),
            child: ClipOval(
              child: cleanUrl.isNotEmpty &&
                      (cleanUrl.startsWith('http://') ||
                          cleanUrl.startsWith('https://'))
                  ? CachedNetworkImage(
                      imageUrl: cleanUrl,
                      width: 106.r,
                      height: 106.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: const Color(0xFF1E1E2C),
                        highlightColor: const Color(0xFF2E2E42),
                        child: Container(
                          width: 106.r,
                          height: 106.r,
                          color: const Color(0xFF1E1E2C),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 106.r,
                        height: 106.r,
                        color: const Color(0xFF242238),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white54,
                          size: 52.r,
                        ),
                      ),
                    )
                  : Container(
                      width: 106.r,
                      height: 106.r,
                      color: const Color(0xFF242238),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white54,
                        size: 52.r,
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.editProfileScreen);
              },
              child: Image.asset(
                'assets/images/edit.png',
                color: Colors.white,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Color(0xFF9F75FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 14.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
