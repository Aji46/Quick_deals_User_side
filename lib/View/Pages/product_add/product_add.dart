import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/product_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/loding_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/product_location_provider.dart';
import 'package:quick_o_deals/View/Pages/product_add/location.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';
import 'package:quick_o_deals/contants/color.dart';

class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer3<ProductProvider, ProductLocationProvider, LoadingProvider>(
          builder: (context, productProvider, productLocationProvider, loadingProvider, child) {
            if (productProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const SizedBox(height: 20),
                  _buildImageSelector(productProvider),
                  const SizedBox(height: 20),
                  _buildCategoryDropdown(productProvider),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: productProvider.productNameController,
                    labelText: "Product Name",
                    validator: ValidationUtils.validateProductName,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: productProvider.productDetailsController,
                    labelText: "Details",
                    validator: ValidationUtils.validateProductDetails,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: productProvider.productPriceController,
                    labelText: "Price",
                    keyboardType: TextInputType.number,
                    validator: ValidationUtils.validateProductPrice,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: productProvider.productAdditionalInfoController,
                    labelText: "More (damage, features, extra fitting information)",
                    validator: ValidationUtils.validateAdditionalInfo,
                  ),
                  const SizedBox(height: 20),
                  _buildLocationSelector(productLocationProvider),
                  const SizedBox(height: 20),
                  _buildSaveButton(productProvider, productLocationProvider, loadingProvider),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildImageSelector(ProductProvider productProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2),
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
    );
  }

  Widget _buildCategoryDropdown(ProductProvider productProvider) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('category').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent));
        }

        var categories = snapshot.data!.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'image': doc['image'],
          };
        }).toList();

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            isExpanded: true,
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return CustomTextFormField(
      controller: controller,
      labelText: labelText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildLocationSelector(ProductLocationProvider productLocationProvider) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.location_on),
          color: MyColors.mycolor4,
          iconSize: 35.0,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OpenStreetMapExample()),
            );

            if (result != null) {
              productLocationProvider.setSelectedLocation(result['location']);
              productLocationProvider.setSelectedAddress(result['address']);
            }
          },
        ),
        const SizedBox(width: 10),
        productLocationProvider.selectedAddress != null
            ? Flexible(
                child: Text(
                  productLocationProvider.selectedAddress!,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : const Text("No address selected", style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildSaveButton(
      ProductProvider productProvider,
      ProductLocationProvider productLocationProvider,
      LoadingProvider loadingProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loadingProvider.isLoading
            ? null
            :  () {
              productProvider.saveProduct(
                context, 
                productLocationProvider.selectedLocation, 
              );
            },// Pass the address here
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
      ),
    );
  }
}
