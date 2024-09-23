// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// class LikedProductsProvider extends ChangeNotifier {
//   // A list to store liked product IDs
//   List<String> _likedProducts = [];

//   // Access to Hive box for persistent storage
//   final Box likedProductsBox = Hive.box('likedProductsBox');

//   LikedProductsProvider() {
//     // Load liked products from Hive when the provider is initialized
//     _likedProducts = likedProductsBox.get('likedProducts', defaultValue: []).cast<String>();
//   }

//   // Method to check if a product is liked
//   bool isProductLiked(String productId) {
//     return _likedProducts.contains(productId);
//   }

//   // Method to toggle like status of a product
//   void toggleLike(String productId) {
//     if (isProductLiked(productId)) {
//       _likedProducts.remove(productId);
//     } else {
//       _likedProducts.add(productId);
//     }

//     // Save liked products to Hive
//     likedProductsBox.put('likedProducts', _likedProducts);

//     notifyListeners();
//   }

//   // Method to get all liked products
//   List<String> getLikedProducts() {
//     return _likedProducts;
//   }
// }
