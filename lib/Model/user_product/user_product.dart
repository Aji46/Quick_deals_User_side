import 'package:cloud_firestore/cloud_firestore.dart';

class UserProductModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchUserProducts(String userId) {
    return _firestore
        .collection('user_products')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore
        .collection('user_products')
        .doc(productId)
        .delete();
  } 
}
