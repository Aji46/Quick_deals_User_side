import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/location_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/loding_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/product_location_provider.dart';
import 'package:quick_o_deals/Model/add_product/product.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';

class ProductProvider with ChangeNotifier {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // TextEditingControllers for managing form inputs
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDetailsController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productAdditionalInfoController = TextEditingController();

  // List to store selected images
  List<XFile> _selectedImages = [];
  List<XFile> get selectedImages => _selectedImages;

  // List to store image URLs after upload
  List<String> _imageUrls = [];

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Selected category
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  void setSelectedCategory(String? categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  // Select images from gallery
  void selectImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      _selectedImages = images;
      notifyListeners();
    }
  }

Future<void> saveProduct(BuildContext context, LatLng? selectedLocation) async {
  final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  final locationProvider = Provider.of<LocationProvider>(context, listen: false);
  final productLocationProvider = Provider.of<ProductLocationProvider>(context, listen: false);
  
  loadingProvider.setLoading(true);

  try {
    if (_selectedImages.isNotEmpty && _selectedCategory != null) {
      // Fetch current location (optional; not needed if only saving address)
      await locationProvider.fetchCurrentLocation();
      final Position? currentPosition = locationProvider.currentPosition;

      // Upload images concurrently
      List<Future<String>> uploadTasks = _selectedImages.map((image) => _uploadImageToFirebase(image)).toList();
      _imageUrls = await Future.wait(uploadTasks);

      // Create Product object with address only
      Product newProduct = Product(
        name: productNameController.text,
        details: productDetailsController.text,
        price: productPriceController.text,
        additionalInfo: productAdditionalInfoController.text,
        images: _imageUrls,
        // Remove latitude and longitude
          // Leave this empty or remove it if not needed
        address: productLocationProvider.selectedAddress ?? '', // Add the address from the provider
      );

      // Save product with address only
      await _saveProductToFirestore(newProduct);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Product added successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to MyHomePage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
          ],
        ),
      );

      // Clear form fields
      _clearForm();
    } else {
      // Show error if no category or no images uploaded
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and upload at least one image.')),
      );
    }
  } finally {
    loadingProvider.setLoading(false);
  }
}


  // Helper function to upload image to Firebase Storage and get download URL
  Future<String> _uploadImageToFirebase(XFile image) async {
    try {
      Reference storageRef = _storage.ref().child('product_images/${image.name}');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Helper function to save product to Firestore
  Future<void> _saveProductToFirestore(Product product) async {
    try {
      await _firestore.collection('user_products').add({
        'categoryId': _selectedCategory,
        'productName': product.name,
        'productDetails': product.details,
        'productPrice': product.price,
        'productAdditionalInfo': product.additionalInfo,
        'images': product.images,
        'address': product.address, 
      });
    } catch (e) {
      print('Error saving product: $e');
    }
  }

  void _clearForm() {
    productNameController.clear();
    productDetailsController.clear();
    productPriceController.clear();
    productAdditionalInfoController.clear();
    _selectedImages.clear();
    _imageUrls.clear();
    _selectedCategory = null;
    notifyListeners();
  }
}
