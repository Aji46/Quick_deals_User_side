import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/Pages/product_detailes/product_detailes.dart';

class CategoryProductList extends StatelessWidget {
  final String categoryId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CategoryProductList({super.key, required this.categoryId});

  Future<List<QueryDocumentSnapshot>> getProductsByCategory(String catId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user_products')
          .where('categoryId', isEqualTo: catId) 
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryId),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getProductsByCategory(categoryId), 
        builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),)); 
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching products')); 
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found for this category')); 
          } else {
            List<QueryDocumentSnapshot> products = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10, 
                childAspectRatio: 3 / 3, 
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index].data() as Map<String, dynamic>;
                final documentId = products[index].id; 

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(productId: documentId), 
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: product['images'] != null && product['images'].isNotEmpty
                              ? Image.network(
                                  product['images'][0], 
                                  fit: BoxFit.cover, 
                                  width: double.infinity, 
                                  height: double.infinity,
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['productName'] ?? 'Unnamed Product', 
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Price: \$${product['productPrice']?.toString() ?? 'N/A'}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
