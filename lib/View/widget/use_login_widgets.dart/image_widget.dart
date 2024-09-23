// lib/View/widget/custom_widgets/image_widget.dart
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;

  ImageWidget({
    required this.imagePath,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
    );
  }
}
