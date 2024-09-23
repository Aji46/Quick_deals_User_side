import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/loding_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/users_product_edite.dart';

class ProductEditPage extends StatelessWidget {
  final QueryDocumentSnapshot product;

  ProductEditPage({required this.product});

  @override
  Widget build(BuildContext context) {
    // Get product details from the passed product document
    final productNameController =
        TextEditingController(text: product.get('productName'));
    final productPriceController =
        TextEditingController(text: product.get('productPrice').toString());
    final productDetailsController =
        TextEditingController(text: product.get('productDetails'));
    final List<String> existingImages =
        List<String>.from(product.get('images') ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: productPriceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: productDetailsController,
                decoration: const InputDecoration(labelText: 'Product Details'),
              ),
              SizedBox(height: 10),
              Text('Existing Images:'),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: existingImages.length,
                  itemBuilder: (context, index) {
                    final imageUrl = existingImages[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        imageUrl,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Consumer<User_ProductController>(
                builder: (context, controller, child) {
                  return controller.selectedImages.isEmpty
                      ? Text('No new images selected.')
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.selectedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  controller.selectedImages[index],
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
              TextButton(
                onPressed: () {
                  Provider.of<User_ProductController>(context, listen: false)
                      .pickImages();
                },
                child: const Text('Pick New Images'),
              ),
              SizedBox(height: 20),
              Consumer<LoadingProvider>(
                builder: (context, loadingProvider, child) {
                  return loadingProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            // Fetch the selected images from the controller
                            final controller = Provider.of<User_ProductController>(
                                context,
                                listen: false);
                                    
                            controller.updateProduct(
                              context: context,
                              productId: product.id,
                              name: productNameController.text,
                              price: productPriceController.text,
                              details: productDetailsController.text,
                              newImages: controller.selectedImages, 
                              // onSuccess: () { Navigator.of(context).pop(); }, 
                            );
                          },
                          child: const Text('Save Changes'),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
