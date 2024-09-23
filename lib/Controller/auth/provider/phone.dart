import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/login_.dart';
import 'package:quick_o_deals/View/Pages/use_login/otp_screen.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';

class PhoneNumberProvider extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = "+91";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  void updateCountryCode(String newCountryCode) {
    selectedCountryCode = newCountryCode;
    notifyListeners();
  }

  Future<void> signInWithPhoneNumber(BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "$selectedCountryCode${phoneController.text.trim()}",
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
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print("Error during phone number verification: $e");
    }
  }

  Future<void> _signInWithCredential(
      PhoneAuthCredential credential, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      print("User signed in: ${_user?.uid}");

      await _saveUserDataToFirestore();

      Provider.of<logProvider>(context, listen: false).setLoginStatus(true);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', true); // Update login status

      // Notify listeners if necessary
      notifyListeners();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => MyHomePage()));
    } catch (e) {
      print("Error signing in with credential: $e");
    }
  }

  Future<void> _saveUserDataToFirestore() async {
    if (_user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      await userRef.set({
        'email': '',
        'phoneNumber': _user!.phoneNumber ?? '',
        'profilePicture': '',
        'username': '',
      }, SetOptions(merge: true));
    }
  }

  void _handleVerificationError(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    } else {
      print('Verification failed. Error: ${e.message}');
    }
    // Show an error message to the user
  }

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
