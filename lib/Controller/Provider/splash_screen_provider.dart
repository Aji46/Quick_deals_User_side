import 'package:flutter/material.dart';

class SplashScreenProvider with ChangeNotifier {
  bool _isNavigating = false;

  bool get isNavigating => _isNavigating;

  void startNavigation() {
    _isNavigating = true;
    notifyListeners();
  }
}