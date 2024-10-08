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



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedProductsProvider extends ChangeNotifier {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance to get the current user's ID
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // A list to store liked product IDs locally for the current session
  List<String> _likedProducts = [];

  // Constructor to load liked products from Firebase when the provider is initialized
  LikedProductsProvider() {
    _loadLikedProducts();
  }

  // Method to load liked products from Firebase for the current user
  Future<void> _loadLikedProducts() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        DocumentSnapshot userLikesDoc = await _firestore.collection('likedProducts').doc(userId).get();
        if (userLikesDoc.exists) {
          // Safely cast the data to Map<String, dynamic> before accessing
          Map<String, dynamic>? data = userLikesDoc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('likedProducts')) {
            _likedProducts = List<String>.from(data['likedProducts']);
          }
        }
      } catch (e) {
        // Handle errors, such as network issues
        print("Failed to load liked products: $e");
      }
      notifyListeners();
    }
  }

  // Method to check if a product is liked
  bool isProductLiked(String productId) {
    return _likedProducts.contains(productId);
  }

  // Method to toggle like status of a product and update Firestore
  Future<void> toggleLike(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    if (isProductLiked(productId)) {
      _likedProducts.remove(productId);
    } else {
      _likedProducts.add(productId);
    }

    // Update the Firestore document with the new list of liked products
    try {
      await _firestore.collection('likedProducts').doc(userId).set({
        'likedProducts': _likedProducts,
      });
    } catch (e) {
      // Handle errors, such as network issues
      print("Failed to update liked products: $e");
    }

    notifyListeners();
  }

  // Method to get all liked products
  List<String> getLikedProducts() {
    return _likedProducts;
  }
}


