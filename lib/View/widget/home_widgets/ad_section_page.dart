import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/Model/Product_featch/productMOodel.dart';
import 'package:shimmer/shimmer.dart';
class AdSectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user_products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Ads Available"));
        }

        final ads = snapshot.data!.docs.map((doc) => ProductModel.fromDocument(doc)).toList();

        return _buildAdCarousel(ads);
      },
    );
  }

  Widget _buildShimmerEffect() {
    return SizedBox(
      height: 200,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            width: 200,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAdCarousel(List<ProductModel> ads) {
    final PageController pageController = PageController();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (pageController.hasClients) {
        int nextPage = pageController.page!.toInt() + 1;
        if (nextPage >= ads.length) {
          nextPage = 0;
        }
        pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: pageController,
        itemCount: ads.length,
        itemBuilder: (context, index) {
          var ad = ads[index];
          String imageUrl = ad.images.isNotEmpty ? ad.images[0] : 'assets/placeholder.png';

          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: imageUrl,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      ),
                    ),
                    Text(
                      'Rs ${ad.productPrice}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
