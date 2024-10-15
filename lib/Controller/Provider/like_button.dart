





// class LikedProductsProvider extends ChangeNotifier {
//   // Firebase Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Firebase Auth instance to get the current user's ID
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // A list to store liked product IDs locally for the current session
//   List<String> _likedProducts = [];

//   // Constructor to load liked products from Firebase when the provider is initialized
//   LikedProductsProvider() {
//     _loadLikedProducts();
//   }

//   // Method to load liked products from Firebase for the current user
//   Future<void> _loadLikedProducts() async {
//     final userId = _auth.currentUser?.uid;
//     if (userId != null) {
//       try {
//         DocumentSnapshot userLikesDoc = await _firestore.collection('likedProducts').doc(userId).get();
//         if (userLikesDoc.exists) {
//           Map<String, dynamic>? data = userLikesDoc.data() as Map<String, dynamic>?;
//           if (data != null && data.containsKey('likedProducts')) {
//             _likedProducts = List<String>.from(data['likedProducts']);
//           }
//         }
//       } catch (e) {
//         // Handle errors, such as network issues
//         print("Failed to load liked products: $e");
//       }
//       notifyListeners();
//     }
//   }

//   // Method to check if a product is liked
//   bool isProductLiked(String productId) {
//     return _likedProducts.contains(productId);
//   }

//   // Method to toggle like status of a product and update Firestore
//  // Method to toggle like status of a product and update Firestore
// Future<void> toggleLike(String productId) async {
//   final userId = _auth.currentUser?.uid;
//   if (userId == null) return;

//   if (isProductLiked(productId)) {
//     _likedProducts.remove(productId);
//   } else {
//     _likedProducts.add(productId);
//   }

//   // Update the Firestore document with the new list of liked products
//   try {
//     await _firestore.collection('likedProducts').doc(userId).set({
//       'likedProducts': _likedProducts,
//     });

//     // Notify listeners after successfully updating Firebase
//     notifyListeners();
//   } catch (e) {
//     // Handle errors, such as network issues
//     print("Failed to update liked products: $e");
//   }
// }


//   // Method to get all liked products
//   List<String> getLikedProducts() {
//     return _likedProducts;
//   }

//   // Method to explicitly like a product
//   Future<void> likeProduct(String productId) async {
//     if (!isProductLiked(productId)) {
//       _likedProducts.add(productId);
//       await _updateLikedProductsInFirestore();
//       notifyListeners();
//     }
//   }

//   // Method to explicitly dislike a product
//   Future<void> dislikeProduct(String productId) async {
//     if (isProductLiked(productId)) {
//       _likedProducts.remove(productId);
//       await _updateLikedProductsInFirestore();
//       notifyListeners();
//     }
//   }

//   // Helper method to update liked products in Firestore
//   Future<void> _updateLikedProductsInFirestore() async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) return;

//     try {
//       await _firestore.collection('likedProducts').doc(userId).set({
//         'likedProducts': _likedProducts,
//       });
//     } catch (e) {
//       print("Failed to update liked products: $e");
//     }
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedProductsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> _likedProducts = [];

  LikedProductsProvider() {
    _loadLikedProducts();
  }

  Future<void> _loadLikedProducts() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        DocumentSnapshot userLikesDoc = await _firestore.collection('likedProducts').doc(userId).get();
        if (userLikesDoc.exists) {
          Map<String, dynamic>? data = userLikesDoc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('likedProducts')) {
            _likedProducts = List<String>.from(data['likedProducts']);
          }
        }
      } catch (e) {
        print("Failed to load liked products: $e");
      }
      notifyListeners(); // Ensure the UI is updated when products are loaded
    }
  }

  // Refresh liked products when an item is added or removed
  Future<void> refreshLikedProducts() async {
    await _loadLikedProducts();
  }

  bool isProductLiked(String productId) {
    return _likedProducts.contains(productId);
  }

  Future<void> toggleLike(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    if (isProductLiked(productId)) {
      _likedProducts.remove(productId);
    } else {
      _likedProducts.add(productId);
    }

    try {
      await _firestore.collection('likedProducts').doc(userId).set({
        'likedProducts': _likedProducts,
      });
    } catch (e) {
      print("Failed to update liked products: $e");
    }

    notifyListeners(); // Make sure to notify after each change
  }

  List<String> getLikedProducts() {
    return _likedProducts;
  }

  Future<void> _updateLikedProductsInFirestore() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore.collection('likedProducts').doc(userId).set({
        'likedProducts': _likedProducts,
      });
    } catch (e) {
      print("Failed to update liked products: $e");
    }
  }
}
