import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  ProductDetailsPage({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('user_products').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Product not found"));
          }

          var productData = snapshot.data!.data() as Map<String, dynamic>;
          String productName = productData['productName'];
          String productPrice = productData['productPrice'];
          String productDetails = productData['productDetails'];
          String productAdditionalInfo = productData['productAdditionalInfo'];
          List<dynamic> images = productData['images'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display all images in a horizontal ListView
                SizedBox(
                  height: 300,
                  child: images.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            String imageUrl = images[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 300,
                                child: Stack(
                                  children: [
                                    // Placeholder while loading the image
                                    Center(child: CircularProgressIndicator()),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/imge place holder.jpg', // Local placeholder image
                                        image: imageUrl,
                                        fit: BoxFit.cover,
                                        width: 300,
                                        height: 300,
                                        fadeInDuration: const Duration(milliseconds: 500),
                                        fadeOutDuration: const Duration(milliseconds: 500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Image.asset('assets/imge place holder.jpg', height: 300, width: 300),
                ),
                const SizedBox(height: 16),
                Text(
                  productName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rs $productPrice',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                const SizedBox(height: 16),
                Text(
                  'Details:',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(productDetails),
                const SizedBox(height: 16),
                Text(
                  'Additional Info:',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(productAdditionalInfo),
              ],
            ),
          );
        },
      ),
    );
  }
}
