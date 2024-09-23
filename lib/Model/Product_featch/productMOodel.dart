import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String productName;
  final String productPrice;
  final String productDetails;
  final String productAdditionalInfo;
  final List<dynamic> images;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.productAdditionalInfo,
    required this.images,
  });

  // Factory method to create a ProductModel from Firestore document
  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      productName: data['productName'] ?? '',
      productPrice: data['productPrice'] ?? '',
      productDetails: data['productDetails'] ?? '',
      productAdditionalInfo: data['productAdditionalInfo'] ?? '',
      images: data['images'] ?? [],
    );
  }
}
