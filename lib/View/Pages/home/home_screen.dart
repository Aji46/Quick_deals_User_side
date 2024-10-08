import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/like_button.dart';
import 'package:quick_o_deals/Controller/auth/provider/Serach_provider.dart';
import 'package:quick_o_deals/View/Pages/home/product_list_page.dart';
import 'package:quick_o_deals/View/Pages/home/search_page.dart';
import 'package:quick_o_deals/View/widget/home_widgets/ad_section_page.dart';
import 'package:quick_o_deals/View/widget/home_widgets/category_layout.dart';
import 'package:quick_o_deals/View/widget/home_widgets/horizondal_product.dart';
import 'package:quick_o_deals/View/widget/home_widgets/location_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LikedProductsProvider(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const SizedBox(height: 20),
                  const LocationWidget(),
                  const SizedBox(height: 20),
                 _buildSearchBar(context),
                  const SizedBox(height: 20),
                  const Text('Browse Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const CategoryListView(),
                  const SizedBox(height: 20),
                  _sectionTitle('Featured',context),
                  const HorizontalProductList(),
                  const SizedBox(height: 20),
                  AdSectionPage(),
                  const SizedBox(height: 20),
                  _sectionTitle('Most Viewed',context),
                  const HorizontalProductList(),
                  const SizedBox(height: 20),
                  _sectionTitle('MotorBikes',context),
                  HorizontalProductList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
  final productSearchProvider = Provider.of<ProductSearchProvider>(context);

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: productSearchProvider.isSearchExpanded ? 60 : 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: productSearchProvider.isSearchExpanded
          ? TextField(
              decoration: const InputDecoration(
                hintText: 'Search products',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                productSearchProvider.searchProducts(query);
              },
            )
          : const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Text(
                  'Search products',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
    ),
  );
}

  Widget _sectionTitle(String title,BuildContext context) {
 return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    GestureDetector(
      onTap: () {
         Navigator.push( context, MaterialPageRoute(builder: (context) =>  ProductListPage()),
      );
      },
      child: Text('See more', style: TextStyle(color: Colors.blue)),
    ),
  ],
);

  }
}
