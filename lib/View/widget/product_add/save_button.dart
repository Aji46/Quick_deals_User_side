import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/product_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/loding_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/product_location_provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final productLocationProvider = Provider.of<ProductLocationProvider>(context);
    final loadingProvider = Provider.of<LoadingProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loadingProvider.isLoading
            ? null
            : () {
                productProvider.saveProduct(
                  context,
                  productLocationProvider.selectedLocation,
                );
              },
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
