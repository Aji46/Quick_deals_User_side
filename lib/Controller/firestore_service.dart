import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
    } catch (e) {
      throw Exception("Error adding user to Firestore: $e");
    }
  }
}
