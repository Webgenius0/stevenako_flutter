// import 'dart:io';
// import 'package:abojude_flutter/networks/endpoints.dart' as endpoints;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';

// class ProfileAvatar extends StatelessWidget {
//   final String? imageUrl;
//   final File? imageFile;
//   final double radius;
//   final double? borderWidth;
//   final Color? borderColor;

//   const ProfileAvatar({
//     super.key,
//     this.imageUrl,
//     this.imageFile,
//     this.radius = 40,
//     this.borderWidth,
//     this.borderColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: borderWidth != null
//             ? Border.all(
//                 color: borderColor ?? Colors.white,
//                 width: borderWidth!,
//               )
//             : null,
//       ),
//       child: CircleAvatar(
//         radius: radius.r,
//         backgroundColor: Colors.grey[200],
//         child: ClipOval(child: _buildImage()),
//       ),
//     );
//   }

//   Widget _buildImage() {
//     final double size = (radius * 2).r;

//     if (imageFile != null) {
//       return Image.file(
//         imageFile!,
//         width: size,
//         height: size,
//         fit: BoxFit.cover,
//       );
//     }

//     String? fullImageUrl = imageUrl;
//     if (fullImageUrl != null && fullImageUrl.isNotEmpty) {
//       // Prepend base URL if it's a relative path
//       if (!fullImageUrl.startsWith('http')) {
//         fullImageUrl =
//             "${endpoints.url}/${fullImageUrl.startsWith('/') ? fullImageUrl.substring(1) : fullImageUrl}";
//       }

//       return CachedNetworkImage(
//         imageUrl: fullImageUrl,
//         width: size,
//         height: size,
//         fit: BoxFit.cover,
//         imageBuilder: (context, imageProvider) => Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//           ),
//         ),
//         placeholder: (context, url) => Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             width: size,
//             height: size,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//         errorWidget: (context, url, error) => _buildPlaceholder(size),
//       );
//     }

//     return _buildPlaceholder(size);
//   }

//   Widget _buildPlaceholder(double size) {
//     return Image.asset(
//       'assets/images/person_img.png',
//       width: size,
//       height: size,
//       fit: BoxFit.cover,
//     );
//   }
// }
