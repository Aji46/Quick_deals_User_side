import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/product_provider.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

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
}
