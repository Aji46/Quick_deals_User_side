import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/Model/auth/auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  User? _user;
  User? get user => _user;

  AuthProvider({required this.authRepository}) {
    // Listen to authentication state changes
    authRepository.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _user = await authRepository.signInWithEmailAndPassword(email, password);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    _user = null;
    notifyListeners();
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    if (_user == null) {
      return {}; // or throw an exception
    }

    return await authRepository.getUserDetails(_user!.uid);
  }
}
