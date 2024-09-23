// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:quick_o_deals/View/Pages/use_login/otp_screen.dart';

// class PhoneNumberProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController phoneController = TextEditingController();
//   String _selectedCountryCode = "+91";
//   String? _verificationId; // Add this line

//   String get selectedCountryCode => _selectedCountryCode;

//   void updateCountryCode(String newCode) {
//     _selectedCountryCode = newCode;
//     notifyListeners();
//   }

//   Future<void> signInWithPhoneNumber(BuildContext context) async {
//     final phoneNumber = "$_selectedCountryCode${phoneController.text}";

//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => OTPInput(verificationId: _verificationId!)));
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print('Verification failed: ${e.message}');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId; // Store the verification ID
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Handle timeout if needed
//       },
//     );
//   }
// }
