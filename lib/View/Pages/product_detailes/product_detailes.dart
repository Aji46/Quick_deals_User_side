import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/login_.dart';
import 'package:quick_o_deals/View/Pages/chat/chatscreen.dart';
import 'package:quick_o_deals/View/Pages/product_detailes/imagecarosal.dart';
import 'package:quick_o_deals/View/Pages/use_login/user_login.dart';
import 'package:quick_o_deals/contants/color.dart';


class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('user_products')
            .doc(productId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Product not found"));
          }

          var productData = snapshot.data!.data() as Map<String, dynamic>;
          String productName = productData['productName'];
          String productPrice = productData['productPrice'];
          String productDetails = productData['productDetails'];
          String productAdditionalInfo = productData['productAdditionalInfo'];
          String location = productData['address'];
          List<dynamic> images = productData['images'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCarousel(images: images), // Use the new widget here
                const SizedBox(height: 16),
                Text(productName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Rs $productPrice', style: const TextStyle(fontSize: 20, color: MyColors.mycolor6)),
                const SizedBox(height: 16),
                _buildSectionTitle('Details:'),
                Text(productDetails),
                const SizedBox(height: 16),
                _buildSectionTitle('Additional Info:'),
                Text(productAdditionalInfo),
                const SizedBox(height: 16),
                _buildSectionTitle('Location:'),
                Text(location),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final logedProvider = Provider.of<logProvider>(context, listen: false);
                      if (logedProvider.isLoggedIn) {
                        String userId = productData['userId'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen(userId: userId)),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserLogin()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.mycolor3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Make enquiry", style: TextStyle(color: MyColors.mycolor2)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }
}
