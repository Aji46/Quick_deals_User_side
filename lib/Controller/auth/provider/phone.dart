import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/login_.dart';
import 'package:quick_o_deals/View/Pages/use_login/otp_screen.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';


class PhoneNumberProvider extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = "+91";  // Default country code
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  // Update the country code selected by the user
  void updateCountryCode(String newCountryCode) {
    selectedCountryCode = newCountryCode;
    notifyListeners();
  }

  // Trigger the phone number verification process
  Future<void> signInWithPhoneNumber(BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "$selectedCountryCode${phoneController.text.trim()}",  // Combine country code with phone number
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential, context);
        },
        verificationFailed: (FirebaseAuthException e) {
          _handleVerificationError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          print("OTP sent to ${phoneController.text.trim()}");
          _navigateToSMSCodeScreen(context, verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto-retrieval timeout for verificationId: $verificationId");
        },
        timeout: const Duration(seconds: 60),  // Set a timeout duration for auto-retrieval of OTP
      );
    } catch (e) {
      print("Error during phone number verification: $e");
    }
  }

  // Sign in the user with the provided credential
  Future<void> _signInWithCredential(PhoneAuthCredential credential, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      print("User signed in: ${_user?.uid}");

      // Save user data to Firestore after signing in
      await _saveUserDataToFirestore();

      // Set login status to true in the provider
      Provider.of<logProvider>(context, listen: false).setLoginStatus(true);

      // Navigate to the home page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => MyHomePage()));
    } catch (e) {
      print("Error signing in with credential: $e");
    }
  }

  // Save the user data to Firestore after successful sign-in
  Future<void> _saveUserDataToFirestore() async {
    if (_user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      await userRef.set({
        'email': '',  // You can replace these with actual data if available
        'phoneNumber': _user!.phoneNumber ?? '',
        'profilePicture': '',
        'username': '',
      }, SetOptions(merge: true));  // Merge data to avoid overwriting existing fields
    }
  }

  // Handle any verification errors during the phone number verification process
  void _handleVerificationError(FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case 'invalid-phone-number':
        errorMessage = 'The provided phone number is not valid.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Please try again later.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Phone authentication is not enabled for this project.';
        break;
      default:
        errorMessage = 'Verification failed. Error: ${e.message}';
        break;
    }

    print(errorMessage);
    // Optionally, you can show a dialog or snack bar to inform the user
  }

  // Navigate to the OTP screen after the code has been sent
  void _navigateToSMSCodeScreen(BuildContext context, String verificationId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VerifyOtp(
          verificationId: verificationId,
          onCodeEntered: (String smsCode) async {
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: smsCode,
            );
            await _signInWithCredential(credential, context);
          },
        ),
      ),
    );
  }
}
