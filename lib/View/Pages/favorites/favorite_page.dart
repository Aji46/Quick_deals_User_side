import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/like_button.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liked Products")),
      body: Consumer<LikedHiveProvider>(
        builder: (context, likedProductsProvider, child) {
          final likedProducts = likedProductsProvider.getLikedProducts();
          // Get liked products from Hive

          if (likedProducts.isEmpty) {
            return const Center(child: Text("No liked products."));
          }

          return ListView.builder(
            itemCount: likedProducts.length,
            itemBuilder: (context, index) {
              final productId = likedProducts[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('user_products')
                    .doc(productId) // Fetch the product by its document ID
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Return shimmer effect while loading
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                        ),
                        title: Container(
                          width: double.infinity,
                          height: 10,
                          color: Colors.white,
                        ),
                        subtitle: Container(
                          width: double.infinity,
                          height: 10,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    // If the product doesn't exist in Firestore, show a placeholder or message
                    return const ListTile(
                      title: Text('Product not found'),
                      subtitle: Text('This product may no longer be available.'),
                    );
                  }

                  final productData = snapshot.data!.data() as Map<String, dynamic>;
                  String productName = productData['productName'] ?? 'Unnamed product';
                  String productPrice = productData['productPrice'] ?? 'N/A';
                  List<dynamic> images = productData['images'] ?? [];
                  String imageUrl = images.isNotEmpty ? images[0] : 'assets/placeholder.png';

                  bool isLiked = likedProductsProvider.isProductLiked(productId);

                  return ListTile(
                    leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(productName),
                    subtitle: Text('Rs $productPrice'),
                    trailing: IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        likedProductsProvider.toggleLike(productId);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
