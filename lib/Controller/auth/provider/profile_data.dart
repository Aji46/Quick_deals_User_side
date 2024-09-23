import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Model/fetch_data/logined_user.dart';

class ProfileDataProvider with ChangeNotifier {
  User? _firebaseUser;
  UserModel? _userModel;

  User? get user => _firebaseUser;
  UserModel? get userModel => _userModel;

  ProfileDataProvider() {
    _initUser();
  }

  Future<void> _initUser() async {
    _firebaseUser = FirebaseAuth.instance.currentUser;
    if (_firebaseUser != null) {
      await _fetchUserData();
    }
    notifyListeners();
  }

  Future<void> _fetchUserData() async {
    if (_firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser!.uid)
          .get();

      if (userDoc.exists) {
        _userModel = UserModel.fromMap(
          userDoc.data() as Map<String, dynamic>,
          _firebaseUser!.uid,
        );
        notifyListeners();
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = userCredential.user;
      await _fetchUserData();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _firebaseUser = null;
    _userModel = null;
    notifyListeners();
  }
}
