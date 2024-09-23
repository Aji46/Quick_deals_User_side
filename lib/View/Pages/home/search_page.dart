import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/Serach_provider.dart';
import 'package:quick_o_deals/View/Pages/product_detailes/product_detailes.dart';
import 'package:shimmer/shimmer.dart'; 

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Consumer<ProductSearchProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding:  const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    provider.searchProducts(query);
                  },
                ),
              ),
              Expanded(
                child: provider.filteredProducts.isEmpty
                    ? const Center(child: Text('No products found'))
                    : ListView.builder(
                        itemCount: provider.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = provider.filteredProducts[index];
                          return ListTile(
                            leading: SizedBox(
                              width: 50,
                              child: Image.network(
                                product.images.isNotEmpty ? product.images[0] : '',
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Icon(Icons.error));
                                },
                              ),
                            ),
                            title: Text(product.productName),
                            subtitle: Text('Price: ${product.productPrice}'),
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

}
