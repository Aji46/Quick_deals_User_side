import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quick_o_deals/Controller/user_data_service.dart';

class ProfileEditProvider with ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? _imagePath;
  String? get imagePath => _imagePath;

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



Future<void> updateUserProfile(BuildContext context, String? imagePath, {String? image}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? downloadUrl; 

      if (image != null && image.isNotEmpty) {
        File imageFile = File(image);
        if (!imageFile.existsSync()) {
          print("File does not exist at path: ${imageFile.path}");
          return; // Exit if file doesn't exist
        }

        String fileName = basename(imageFile.path);
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
          
        // Start uploading the file
        UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;

        // Wait for the upload to complete and get the download URL
        downloadUrl = await taskSnapshot.ref.getDownloadURL();

        print("Image uploaded successfully! URL: $downloadUrl");
      } else {
        // Keep the existing profile picture if no new image is selected
        downloadUrl = _imagePath;
      }

      // Update Firestore with new user profile data
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.set({
        'username': usernameController.text.trim(),
        'phoneNumber': phoneNumberController.text.trim(),
        'email': emailController.text.trim(),
        'profilePicture': downloadUrl,
      }, SetOptions(merge: true));

      // Notify user of success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      // Reload user data to reflect changes
      _loadUserData(context);
    }
  } catch (error) {
    // Handle and log the error appropriately
    print("Error updating profile: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update profile: $error')),
    );
  }
}



  Future<String?> _getCurrentProfilePicture(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userSnapshot = await userRef.get();
    return userSnapshot.data()?['profilePicture'] as String?;
  }
}
