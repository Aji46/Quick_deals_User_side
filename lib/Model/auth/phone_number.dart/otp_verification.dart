import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumberModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedCountryCode = "+91";

  String get selectedCountryCode => _selectedCountryCode;

  void updateCountryCode(String newCode) {
    _selectedCountryCode = newCode;
  }

  Future<void> signInWithPhoneNumber(String phoneNumber, Function(String) onVerificationCompleted) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        onVerificationCompleted(credential.verificationId!);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        onVerificationCompleted(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout if needed
      },
    );
  }
}
