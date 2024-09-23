
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/Model/Product_featch/productMOodel.dart';

class ProductSearchProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';
  bool _isSearchExpanded = false;
  Timer? _debounce;

  List<ProductModel> get filteredProducts => _filteredProducts;
  String get searchQuery => _searchQuery;
  bool get isSearchExpanded => _isSearchExpanded;

  Future<void> fetchProducts() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('user_products').get();
    _products = snapshot.docs.map((doc) => ProductModel.fromDocument(doc)).toList();
    _filteredProducts = _products;
    notifyListeners();
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

  void toggleSearchBar() {
    _isSearchExpanded = !_isSearchExpanded;
    notifyListeners();
  }
}
