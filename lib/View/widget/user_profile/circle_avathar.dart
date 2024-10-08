
import 'package:flutter/material.dart';

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
      backgroundImage: avatarUrl.isNotEmpty
          ? NetworkImage(avatarUrl)
          : AssetImage(imagePath) ,
      radius: 60,
    );
  }
}
