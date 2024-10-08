import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/product_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/loding_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/product_location_provider.dart';
import 'package:quick_o_deals/View/widget/product_add/dropdown.dart';
import 'package:quick_o_deals/View/widget/product_add/image_selector.dart';
import 'package:quick_o_deals/View/widget/product_add/location_selector.dart';
import 'package:quick_o_deals/View/widget/product_add/save_button.dart';
import 'package:quick_o_deals/View/widget/product_add/text_field.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';

class ProductAdd extends StatelessWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer3<ProductProvider, ProductLocationProvider, LoadingProvider>(
          builder: (context, productProvider, productLocationProvider, loadingProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text(
                    "Add Product",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const ImageSelector(),
                  const SizedBox(height: 16),
                  const CategoryDropdown(),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: productProvider.productNameController,
                    labelText: "Product Name",
                    keyboardType: TextInputType.text,
                    validator: ValidationUtils.validateProductName,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: productProvider.productDetailsController,
                    labelText: "Product Details",
                    keyboardType: TextInputType.multiline,
                    validator: ValidationUtils.validateProductDetails,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: productProvider.productPriceController,
                    labelText: "Product Price",
                    keyboardType: TextInputType.number,
                    validator: ValidationUtils.validateProductPrice,
                  ),
                     const SizedBox(height: 16),
                  CustomTextField(
                    controller: productProvider.productAdditionalInfoController,
                    labelText: "More (damage, features, extra fitting information)",
                    keyboardType: TextInputType.multiline,
                    validator: ValidationUtils.validateAdditionalInfo,
                  ),
                  const SizedBox(height: 16),
                  const LocationSelector(),
                  const SizedBox(height: 16),
                  const SaveButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
