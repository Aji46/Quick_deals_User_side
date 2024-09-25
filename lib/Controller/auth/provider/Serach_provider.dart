import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/Model/Product_featch/productMOodel.dart';
import 'package:quick_o_deals/Model/category/category.dart';
class ProductSearchProvider extends ChangeNotifier {
    double maxProductPrice = 10000; 
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';
  bool _isSearchExpanded = false;
  Timer? _debounce;
  List<CategoryModel> _categories = [];

  List<ProductModel> get filteredProducts => _filteredProducts;
  String get searchQuery => _searchQuery;
  bool get isSearchExpanded => _isSearchExpanded;
  List<CategoryModel> get categories => _categories;

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('user_products').get();
    _products = snapshot.docs.map((doc) => ProductModel.fromDocument(doc)).toList();
    _filteredProducts = _products;
    notifyListeners();
  }

  void listenToCategories() {
    FirebaseFirestore.instance.collection('category').snapshots().listen((snapshot) {
      _categories = snapshot.docs
          .map((doc) => CategoryModel(
                id: doc.id,
                name: doc['name'],
                image: doc['image'],
              ))
          .toList();
      notifyListeners();
    });
  }

  void searchProducts(String query) {
    _searchQuery = query;

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((product) =>
                product.productName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      notifyListeners();
    });
  }

  void filterProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? recentlyAdded,
  }) {
    _filteredProducts = _products.where((product) {
      final matchesCategory = categoryId == null || product.categoryId == categoryId;
      final productPriceAsInt = int.tryParse(product.productPrice); 
      
      final matchesPrice = productPriceAsInt! >= (minPrice ?? 0) && productPriceAsInt <= (maxPrice ?? double.infinity.toInt());
      final matchesRecentlyAdded = !recentlyAdded! || (product.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 30))));

      return matchesCategory && matchesPrice && matchesRecentlyAdded;
    }).toList();
    notifyListeners();
  }

 Future<void> fetchMaxProductPrice() async {
  try {
    // Assuming you have a collection named 'user_products'
    final snapshot = await FirebaseFirestore.instance.collection('user_products').get();
    
    // Find the maximum product price using tryParse
    maxProductPrice = snapshot.docs.map((doc) {
      // Attempt to parse the price from string to double
      String priceString = doc['productPrice'] as String;
      return double.tryParse(priceString) ?? 0.0; // Default to 0.0 if parsing fails
    }).reduce((a, b) => a > b ? a : b);
    
    notifyListeners(); // Notify listeners after updating the max price
  } catch (e) {
    // Handle errors if needed
    print('Error fetching max product price: $e');
  }
}

}


