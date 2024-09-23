import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class User_ProductController extends ChangeNotifier {
  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      selectedImages.clear();
      for (var pickedFile in pickedFiles) {
        selectedImages.add(File(pickedFile.path));
      }
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  Future<void> updateProduct({
    required BuildContext context,
    required String productId,
    required String name,
    required String price,
    required String details,
    required List<File> newImages,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Circular progress indicator
        );
      },
    );

    try {
      List<String> imageUrls = [];
      for (File image in newImages) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child(productId)
            .child(DateTime.now().toString());
        final uploadTask = storageRef.putFile(image);
        final snapshot = await uploadTask.whenComplete(() => {});
        final imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Update Firestore document with new image URLs
      await FirebaseFirestore.instance
          .collection('user_products')
          .doc(productId)
          .update({
        'productName': name,
        'productPrice': price,
        'productDetails': details,
        'images': imageUrls, // or merge with existing images
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (error) {
      // Dismiss the progress indicator if there's an error
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: $error')),
      );
    }

    notifyListeners();
  }
}
