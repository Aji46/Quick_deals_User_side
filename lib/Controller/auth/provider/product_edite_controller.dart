import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:quick_o_deals/Model/user_product/user_product.dart';

class UserProductController extends ChangeNotifier {
  final UserProductModel _productModel;

  UserProductController(this._productModel);

  Future<void> updateProduct({
    required String productId,
    required String name,
    required String price,
    required String details,
    File? imageFile,
  }) async {
    Map<String, dynamic> updates = {
      'productName': name,
      'productPrice': price,
      'productDetails': details,
    };

    if (imageFile != null) {
      String imageUrl = await _uploadImage(imageFile);
      updates['images'] = [imageUrl];
    }

    try {
      await FirebaseFirestore.instance.collection('user_products').doc(productId).update(updates);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().toIso8601String()}');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
