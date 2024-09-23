import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ImageButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {
        // Default action when onPressed is not provided
        print('Image button tapped!');
      },
      child: Image.asset(
        'assets/google.png',
        width: 50,
        height: 50,
      ),
    );
  }
}