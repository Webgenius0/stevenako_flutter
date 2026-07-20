
// import 'package:abojude_flutter/helpers/toast.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// Future<void> showCustomImagePicker({
//   required BuildContext context,
//   required Function(XFile pickedFile) onImagePicked,
// }) async {
//   final picker = ImagePicker();

//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (_) => Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFF0F1B2A),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       child: SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: Colors.white),
//               title: const Text(
//                 'Choose from Gallery',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               onTap: () async {
//                 final image = await picker.pickImage(
//                   source: ImageSource.gallery,
//                 );
//                 if (image != null) {
//                   onImagePicked(image);
//                 }
//                 final success = true;
//                 if (success) {
//                   ToastUtil.showShortToast("Image uploaded successfully.");
//                 }
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.white),
//               title: const Text(
//                 'Take a Photo',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               onTap: () async {
//                 final image = await picker.pickImage(
//                   source: ImageSource.camera,
//                 );
//                 if (image != null) {
//                   onImagePicked(image);
//                 }
//                 final success = true;
//                 if (success) {
//                   ToastUtil.showShortToast("Image uploaded successfully.");
//                 }
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
