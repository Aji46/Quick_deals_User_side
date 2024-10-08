

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// class LikedHiveProvider extends ChangeNotifier {
//   // A list to store liked product IDs
//   List<String> _likedProducts = [];

//   // Access to Hive box for persistent storage
//   final Box likedProductsBox = Hive.box('liked_products');

//   LikedProductsProvider() {
//     // Load liked products from Hive when the provider is initialized
//     _likedProducts = likedProductsBox.get('liked_products', defaultValue: []).cast<String>();
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
//     likedProductsBox.put('liked_products', _likedProducts);

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

  // Method to explicitly like a product
  Future<void> likeProduct(String productId) async {
    if (!isProductLiked(productId)) {
      _likedProducts.add(productId);
      await _updateLikedProductsInFirestore();
      notifyListeners();
    }
  }

  // Method to explicitly dislike a product
  Future<void> dislikeProduct(String productId) async {
    if (isProductLiked(productId)) {
      _likedProducts.remove(productId);
      await _updateLikedProductsInFirestore();
      notifyListeners();
    }
  }

  // Helper method to update liked products in Firestore
  Future<void> _updateLikedProductsInFirestore() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore.collection('likedProducts').doc(userId).set({
        'likedProducts': _likedProducts,
      });
    } catch (e) {
      // Handle errors, such as network issues
      print("Failed to update liked products: $e");
    }
  }
}






// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// class LikedHiveProvider extends ChangeNotifier {
//   Box<String>? _likedBox;

//   LikedHiveProvider() {
//     _initBox();
//   }

//   // Initialize Hive box for storing liked products
//   Future<void> _initBox() async {
//     _likedBox = await Hive.openBox<String>('liked_products');
//     notifyListeners(); // Notify listeners once the box is initialized
//   }

//   // Get the list of liked products' IDs
//   List<String> getLikedProducts() {
//     if (_likedBox == null) return []; // Check if box is initialized
//     return _likedBox!.keys.cast<String>().toList(); // Return keys (product IDs) as a list
//   }

//   // Add a liked product to the box
//   void addLikedProduct(String productId) {
//     _likedBox?.put(productId, productId); // Add product by its ID
//     notifyListeners(); // Notify listeners after updating
//   }

//   // Remove a liked product from the box
//   void removeLikedProduct(String productId) {
//     _likedBox?.delete(productId); // Remove the product by its ID
//     notifyListeners(); // Notify listeners after updating
//   }



//   bool isProductLiked(String productId) {
//   if (_likedBox == null) return false;
//   return _likedBox!.containsKey(productId);
// }


// }






















// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// class LikedHiveProvider with ChangeNotifier {
//   Box? _likedBox; // Nullable to handle initialization

//   // Initialize Hive box
//   Future<void> init() async {
//     _likedBox = await Hive.openBox('liked_products');
//     notifyListeners(); // Notify listeners after box is initialized
//   }

//   // Check if a product is liked
//   bool isProductLiked(String productId) {
//     if (_likedBox == null) return false; // Handle null case
//     return _likedBox!.get(productId, defaultValue: false);
//   }

//   // Toggle like status
//   Future<void> toggleLike(String productId) async {
//     if (_likedBox == null) return; // Ensure box is initialized

//     bool currentValue = _likedBox!.get(productId, defaultValue: false);

//     if (currentValue) {
//       await _likedBox!.delete(productId); // Unlike product
//     } else {
//       await _likedBox!.put(productId, true); // Like product
//     }

//     notifyListeners(); // Notify listeners of the change
//   }

//   // Get all liked products
//   List<String> getLikedProducts() {
//     if (_likedBox == null) return [];
//     return _likedBox!.keys.cast<String>().toList();
//   }

//    bool checkLikedStatus(String productId) {
//     return _likedBox?.get(productId, defaultValue: false) ?? false;
//   }
// }
