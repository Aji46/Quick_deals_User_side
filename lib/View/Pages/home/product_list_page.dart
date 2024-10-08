import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/Model/Product_featch/productMOodel.dart';
import 'package:quick_o_deals/View/Pages/product_detailes/product_detailes.dart';
import 'package:quick_o_deals/contants/color.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: FutureBuilder<List<ProductModel>>(
        future: fetchUserProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(product.images[0]), // Display the first image
                  title: Text(product.productName),
                  subtitle: Text(product.productPrice,style: const TextStyle(color: MyColors.mycolor6),),
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(productId: product.id),
                    ),
                  );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<List<ProductModel>> fetchUserProducts() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('user_products').get();
  
  return querySnapshot.docs.map((doc) => ProductModel.fromDocument(doc)).toList();
}

