import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';


class OtpVerificationProvider extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();
  String phoneNumber = '';
  String verificationId = '';
  User? _user;

  Future<void> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) {
       
        // Save user data to Firestore
        await _saveUserDataToFirestore();

        // Navigate to the home page or the desired route
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>  const MyHomePage())); // Replace with your desired route
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
      print("Verification ID: $verificationId");
      print("OTP: $otp");
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
        'createdAt': FieldValue.serverTimestamp(), // Only set this if the document is being created for the first time
      }, SetOptions(merge: true));
    }
  }

  void setVerificationDetails(String phoneNumber, String verificationId) {
    this.phoneNumber = phoneNumber;
    this.verificationId = verificationId;
    notifyListeners();
  }
}
