import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<dynamic> images;

  const ImageCarousel({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: images.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                String imageUrl = images[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: 300,
                    child: Stack(
                      children: [
                        const Center(child: CircularProgressIndicator()),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 300,
                              color: Colors.grey[300],
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Image.asset(''),
    );
  }
}
