import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/login_.dart';
import 'package:quick_o_deals/View/Pages/chat/chatscreen.dart';
import 'package:quick_o_deals/View/Pages/use_login/user_login.dart';
import 'package:quick_o_deals/contants/color.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({required this.productId});

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
          // ignore: non_constant_identifier_names
          String Location = productData['address'];
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
                              child: SizedBox(
                                width: 300,
                                child: Stack(
                                  children: [
                                    // Placeholder while loading the image
                                    const Center(
                                        child: CircularProgressIndicator()),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 300,
                                          color: Colors.grey[300],
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Image.asset(''),
                ),
                const SizedBox(height: 16),
                Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rs $productPrice',
                  style:
                      const TextStyle(fontSize: 20, color: MyColors.mycolor6),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Details:',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(productDetails),
                const SizedBox(height: 16),
                const Text(
                  'Additional Info:',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(productAdditionalInfo),
                const SizedBox(height: 16),
                const Text(
                  'Location:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(Location),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final logedProvider =
                          Provider.of<logProvider>(context, listen: false);
                      if (logedProvider.isLoggedIn) {
                        String userId = productData['userId'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  userId:
                                      userId)),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserLogin()), 
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.mycolor3,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Make enquiry",
                      style: TextStyle(color: MyColors.mycolor2),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
