import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/Model/user_product/user_product.dart';



class UserProductController with ChangeNotifier {
   final UserProductModel _userProductModel;


  UserProductController(this._userProductModel);

  Stream<QuerySnapshot> fetchUserProducts(String userId) {
    return _userProductModel.fetchUserProducts(userId);
  }

  Future<void> deleteProduct(String productId) async {
    await _userProductModel.deleteProduct(productId);
    notifyListeners();
  }

   Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final doc = await FirebaseFirestore.instance.collection('user_products').doc(productId).get();
    return doc.data()!;
  }
  
}
