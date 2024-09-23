import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/Model/auth/register/registermodel.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    String? profilePicture,
  }) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a UserModel instance
      UserModel user = UserModel(
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        profilePicture: '',

      );

      // Store additional user information in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toMap());

      // Notify listeners if needed
      notifyListeners();
    } catch (e) {
      // Handle errors
      throw Exception('Failed to register user: $e');
    }
  }


  
}
