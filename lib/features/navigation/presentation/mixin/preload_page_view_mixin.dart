// import 'package:flutter/material.dart';

// mixin PreloadPageViewMixin<T extends StatefulWidget> on State<T> {
//   late PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(
//       initialPage: 0,
//       keepPage: true,
//       viewportFraction: 1.0,
//     );

//     // Force load all pages by briefly scrolling through them
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       for (var i = 0; i < numberOfPages; i++) {
//         await _pageController.animateToPage(
//           i,
//           duration: const Duration(milliseconds: 1),
//           curve: Curves.linear,
//         );
//       }
//       // Return to first page
//       await _pageController.animateToPage(
//         0,
//         duration: const Duration(milliseconds: 1),
//         curve: Curves.linear,
//       );
//     });
//   }

//   PageController get pageController => _pageController;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
