import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      _user = userCredential.user;
      await _saveUserDataToFirestore();

      // Update SharedPreferences
      if (_user != null) {
             

        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      }

      notifyListeners();
      return _user != null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }

  Future<void> _saveUserDataToFirestore() async {
    if (_user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      await userRef.set({
        'email': _user!.email,
        'phoneNumber': _user!.phoneNumber ?? '',
        'profilePicture': _user!.photoURL ?? '',
        'username': _user!.displayName ?? '',
      }, SetOptions(merge: true));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    // Update SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    _user = null;
    notifyListeners();
  }
}
