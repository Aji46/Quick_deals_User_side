import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/Serach_provider.dart';
import 'package:quick_o_deals/View/Pages/product_detailes/product_detailes.dart';
import 'package:shimmer/shimmer.dart'; 

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch categories when the page is built
    final provider = Provider.of<ProductSearchProvider>(context, listen: false);
    provider.listenToCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Consumer<ProductSearchProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
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
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        _showFilterModal(context, provider);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
                                  return const Center(child: Icon(Icons.error));
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

  void _showFilterModal(BuildContext context, ProductSearchProvider provider) {
     provider.fetchMaxProductPrice();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        double _minPrice = 0;
        double _maxPrice = provider.maxProductPrice;
        bool _recentlyAdded = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Filter by:'),
                   DropdownButton<String>(
                    hint: const Text('Select Category'),
                    value: provider.selectedCategory.isEmpty ? null : provider.selectedCategory,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.selectCategory(newValue); // Use the Provider method to update category
                      }
                    },
                    items: provider.categories.map<DropdownMenuItem<String>>(
                      (category) {
                        return DropdownMenuItem<String>(
                          value: category.id, // Use the category ID as the value
                          child: Text(category.name),
                        );
                      },
                    ).toList(),
                  ),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: provider.maxProductPrice,
                    divisions: 100,
                    labels: RangeLabels(
                      _minPrice.round().toString(),
                      _maxPrice.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Recently Added'),
                    value: _recentlyAdded,
                    onChanged: (bool value) {
                      setState(() {
                        _recentlyAdded = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      provider.filterProducts(
                        categoryId: provider.selectedCategory, // Use selected category from provider
                        minPrice: _minPrice,
                        maxPrice: _maxPrice,
                        recentlyAdded: _recentlyAdded,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
