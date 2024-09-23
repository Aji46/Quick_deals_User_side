// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quick_o_deals/Model/category/category.dart';

// class CategoryProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<CategoryModel> _categories = [];

//   List<CategoryModel> get categories => _categories;

//   Future<void> fetchCategories() async {
//     try {
//       final snapshot = await _firestore.collection('category').get();
//       if (snapshot.docs.isNotEmpty) {
//         _categories = snapshot.docs.map((doc) {
//           return CategoryModel.fromJson(doc.data());
//         }).toList();
//       } else {
//         _categories = [];
//       }
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching categories: $e');
//       _categories = [];
//       notifyListeners();
//     }
//   }
// }