import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class logProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _phoneNumber;
  String? _username;
  String? _profilePicture;

  bool get isLoggedIn => _isLoggedIn;
  String? get phoneNumber => _phoneNumber;
  String? get username => _username;
  String? get profilePicture => _profilePicture;

  logProvider() {
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('Login Status Loaded: $_isLoggedIn');
    
    if (_isLoggedIn) {
      await _loadUserData();
    }
    
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      _phoneNumber = userDoc.get('phoneNumber') ?? '';
      _username = userDoc.get('username') ?? '';
      _profilePicture = userDoc.get('profilePicture') ?? '';
      notifyListeners();
    }
  }

  Future<void> setLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = status;
    await prefs.setBool('isLoggedIn', status);
    print('Login Status Updated: $_isLoggedIn');
    notifyListeners();
  }
}
