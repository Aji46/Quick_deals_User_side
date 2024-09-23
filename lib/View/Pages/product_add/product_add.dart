import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/product_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/loding_provider.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';

class ProductAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const SizedBox(height: 20),
                  
                  // Category Dropdown
                 

                  const SizedBox(height: 20),

                  // Image selection and other form fields...
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        width: 2,
                      ),
                      color: Colors.grey[200],
                    ),
                    width: double.infinity,
                    height: 140,
                    child: Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: productProvider.selectImages,
                            icon: const Icon(Icons.add_a_photo_outlined, size: 60),
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: productProvider.selectedImages.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productProvider.selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(productProvider.selectedImages[index].path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                )
                              : const Center(child: Text("No images selected")),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                // ... (previous code remains the same)

StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('category').snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }

    var categories = snapshot.data!.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
        'image': doc['image'],
      };
    }).toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      child: DropdownButtonFormField<String>(
        value: productProvider.selectedCategory,
        hint: const Text("Select a Category"),
        items: categories.map((category) {
          return DropdownMenuItem<String>(
            value: category['id'] as String,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(category['image'] as String),
                  radius: 20,
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Text(
                    category['name'] as String,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          productProvider.setSelectedCategory(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        isExpanded: true,
      ),
    );
  },
),

// ... (rest of the code remains the same)
                  
                  // Other form fields (Product Name, Details, etc.)
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: productProvider.productNameController,
                    labelText: "Product Name",
                    keyboardType: TextInputType.text,
                    validator: (value) => ValidationUtils.validateProductName(value),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: productProvider.productDetailsController,
                    labelText: "Details",
                    keyboardType: TextInputType.text,
                    validator: (value) => ValidationUtils.validateProductDetails(value),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: productProvider.productPriceController,
                    labelText: "Price",
                    keyboardType: TextInputType.number,
                    validator: (value) => ValidationUtils.validateProductPrice(value),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: productProvider.productAdditionalInfoController,
                    labelText: "More (damage, features, extra fitting information)",
                    keyboardType: TextInputType.text,
                    validator: (value) => ValidationUtils.validateAdditionalInfo(value),
                  ),
                  
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<LoadingProvider>(
                      builder: (context, loadingProvider, child) {
                        return ElevatedButton(
                          onPressed: loadingProvider.isLoading
                              ? null 
                              : () => productProvider.saveProduct(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: loadingProvider.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Save"),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}