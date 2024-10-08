import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/product_provider.dart';

class ImageSelector extends StatelessWidget {
  const ImageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

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
}
