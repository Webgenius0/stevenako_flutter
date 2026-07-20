// import 'package:flutter/material.dart';
// import 'package:ibraheemaltamim_flutter/features/home/model/wishlist_model.dart';

// class WishlistProvider extends ChangeNotifier {
//   final List<WishlistModel> _wishLists = [
//     WishlistModel(
//       title: 'Assessing the Efficacy and Safety',
//       description:
//           'Explore gene therapy approaches for rare genetic diseases with our multidisciplinary team.',
//       doctor: 'Dr. Jhon Smith',
//       deadline: 'Mar 15, 2026',
//       category: 'Neurologist',
//       imageUrl: 'assets/images/img1.png',
//       isFavorite: true,
//     ),
//     WishlistModel(
//       title: 'Assessing the Efficacy and Safety',
//       description:
//           'Explore gene therapy approaches for rare genetic diseases with our multidisciplinary team.',
//       doctor: 'Dr. Sarah Chen',
//       deadline: 'Mar 15, 2026',
//       category: 'Neurologist',
//       imageUrl: 'assets/images/img2.png',
//       isFavorite: true,
//     ),
//   ];

//   List<WishlistModel> get wishLists => _wishLists;

//   int get favoriteCount => _wishLists.where((o) => o.isFavorite).length;

//   void toggleFavorite(int index) {
//     if (index >= 0 && index < _wishLists.length) {
//       _wishLists[index] = _wishLists[index].copyWith(
//         isFavorite: !_wishLists[index].isFavorite,
//       );
//       notifyListeners();
//     }
//   }

//   void removeFromWishlist(int index) {
//     if (index >= 0 && index < _wishLists.length) {
//       _wishLists.removeAt(index);
//       notifyListeners();
//     }
//   }
// }
