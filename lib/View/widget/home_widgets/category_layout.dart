
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/Pages/category/catogery_poduct_list.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('category').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Categories Available"));
        }

        final categories = snapshot.data!.docs;

        return SizedBox(
          height: 100, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var categoryData = categories[index].data() as Map<String, dynamic>;
              String categoryName = categories[index].id; 
              String? imageUrl = categoryData['image']; 

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child:Column(
  children: [
    GestureDetector(
      onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductList(categoryId: categoryName,
             
            ),
          ),
        );
      },
      child: CircleAvatar(
  radius: 30,
  backgroundImage: imageUrl != null
    ? CachedNetworkImageProvider(imageUrl)
    : const AssetImage('assets/placeholder.png') as ImageProvider,
),
    ),
    const SizedBox(height: 8),
    Text(
      categoryName,
      style: const TextStyle(fontSize: 12),
    ),
  ],
)

              );
            },
          ),
        );
      },
    );
  }
}