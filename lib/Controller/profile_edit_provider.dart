import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:quick_o_deals/Controller/user_data_service.dart';

class ProfileEditProvider with ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ProfileEditProvider(BuildContext context) {
    _loadUserData(context);
  }

  Future<void> _loadUserData(BuildContext context) async {
    final userData = await UserDataService.getUserDetails(context);
    if (userData != null) {
      usernameController.text = userData['username'] ?? '';
      phoneNumberController.text = userData['phoneNumber'] ?? '';
      emailController.text = userData['email'] ?? '';
      _imagePath = userData['profilePicture'] ?? "";
      notifyListeners();
    }
  }

  String? _imagePath;

  String? get imagePath => _imagePath;

  void selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      
      _imagePath = pickedFile.path;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(BuildContext context,image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateEmail(emailController.text.trim());

        if (image != null) {
          File imagefile = File(image.toString());
          String fileName = basename(imagefile.path);
          Reference firebaseStorageRef =
              FirebaseStorage.instance.ref().child('uploads/$fileName');
          
          UploadTask uploadTask = firebaseStorageRef.putFile(imagefile);
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();


          final userRef =
              FirebaseFirestore.instance.collection('users').doc(user.uid);

          await userRef.set({
            'username': usernameController.text.trim(),
            'phoneNumber': phoneNumberController.text.trim(),
            'email': emailController.text.trim(),
            'profilePicture': downloadUrl,
          }, SetOptions(merge: true));
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        _loadUserData(context);
      }
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    }
  }
}
