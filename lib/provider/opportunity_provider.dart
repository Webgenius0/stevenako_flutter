// import 'package:flutter/material.dart';

// class OpportunityProvider extends ChangeNotifier {
//   final List<OpportunityModel> _opportunities = [
//     OpportunityModel(
//       title: 'Assessing the Efficacy and Safety',
//       description:
//           'Explore gene therapy approaches for rare genetic diseases with our multidisciplinary team.',
//       doctor: 'Dr. Jhon Smith',
//       deadline: 'Mar 15, 2026',
//       category: 'Neurologist',
//       imageUrl: 'assets/images/img1.png',
//       isFavorite: false,
//     ),
//     OpportunityModel(
//       title: 'Assessing the Efficacy and Safety',
//       description:
//           'Explore gene therapy approaches for rare genetic diseases with our multidisciplinary team.',
//       doctor: 'Dr. Sarah Chen',
//       deadline: 'Mar 15, 2026',
//       category: 'Neurologist',
//       imageUrl: 'assets/images/img2.png',
//       isFavorite: false,
//     ),
//     OpportunityModel(
//       title: 'Assessing the Efficacy and Safety',
//       description:
//           'Explore gene therapy approaches for rare genetic diseases with our multidisciplinary team.',
//       doctor: 'Dr. Jhon Smith',
//       deadline: 'Mar 15, 2026',
//       category: 'Neurologist',
//       imageUrl: 'assets/images/img1.png',
//       isFavorite: false,
//     ),
//     OpportunityModel(
//       title: 'Assessing the Efficacy and Safety',
//       description:
//           'Explore gene therapy approaches for rare genetic diseases with our multidisciplinary team.',
//       doctor: 'Dr. Sarah Chen',
//       deadline: 'Mar 15, 2026',
//       category: 'Neurologist',
//       imageUrl: 'assets/images/img2.png',
//       isFavorite: false,
//     ),
//   ];

//   List<OpportunityModel> get opportunities => _opportunities;

//   int get favoriteCount => _opportunities.where((o) => o.isFavorite).length;

//   void toggleFavorite(int index) {
//     if (index >= 0 && index < _opportunities.length) {
//       _opportunities[index] = _opportunities[index].copyWith(
//         isFavorite: !_opportunities[index].isFavorite,
//       );
//       notifyListeners();
//     }
//   }
// }
