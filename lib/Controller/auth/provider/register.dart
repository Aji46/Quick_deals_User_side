import 'package:flutter/material.dart';

class TermsProvider with ChangeNotifier {
  bool _acceptedTerms = false;

  bool get acceptedTerms => _acceptedTerms;

  void toggleAcceptedTerms(bool? value) {
    _acceptedTerms = value ?? false;
    notifyListeners();
  }
}
