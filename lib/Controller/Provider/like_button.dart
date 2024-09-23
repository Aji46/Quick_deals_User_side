

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



import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LikedHiveProvider extends ChangeNotifier {
  // A list to store liked product IDs
  List<String> _likedProducts = [];

  // Access to Hive box for persistent storage
  final Box likedProductsBox = Hive.box('liked_products');

  // Constructor to load liked products from Hive when the provider is initialized
  LikedHiveProvider() {
    _likedProducts = likedProductsBox.get('liked_products', defaultValue: []).cast<String>();
  }

  // Method to check if a product is liked
  bool isProductLiked(String productId) {
    return _likedProducts.contains(productId);
  }

  // Method to toggle like status of a product
  void toggleLike(String productId) {
    if (isProductLiked(productId)) {
      // If the product is liked, dislike it (remove it from the list)
      _likedProducts.remove(productId);
    } else {
      // If the product is not liked, like it (add it to the list)
      _likedProducts.add(productId);
    }

    // Save updated liked products to Hive
    likedProductsBox.put('liked_products', _likedProducts);

    // Notify listeners about the change
    notifyListeners();
  }

  // Method to get all liked products
  List<String> getLikedProducts() {
    return _likedProducts;
  }

  // Method to explicitly like a product
  void likeProduct(String productId) {
    if (!isProductLiked(productId)) {
      _likedProducts.add(productId);
      likedProductsBox.put('liked_products', _likedProducts);
      notifyListeners();
    }
  }

  // Method to explicitly dislike a product
  void dislikeProduct(String productId) {
    if (isProductLiked(productId)) {
      _likedProducts.remove(productId);
      likedProductsBox.put('liked_products', _likedProducts);
      notifyListeners();
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
