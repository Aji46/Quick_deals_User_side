
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatar extends StatelessWidget {
  final String imagePath;
  final String avatarUrl;

  const ProfileAvatar({
    Key? key,
    this.imagePath = 'assets/ava.png',
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(".........................");
    return CircleAvatar(
  radius: 60,
  backgroundColor: Colors.grey[200], // Optional: Add background color to give a base color
  child: ClipOval(
    child: CachedNetworkImage(
      imageUrl: avatarUrl.isNotEmpty ? avatarUrl : '', // Use empty URL if avatarUrl is empty
      fit: BoxFit.cover,
      width: 120,
      height: 120,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 120,
          height: 120,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        imagePath, // Display asset image if network image fails
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      ),
    ),
  ),
);
  }
}
