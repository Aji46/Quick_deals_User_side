import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/profile_image_check.dart';

class ProfileEditAvatar extends StatelessWidget {
  final String avatarUrl;

  const ProfileEditAvatar({
    Key? key,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageEditProvider>(
      builder: (context, profileEditProvider, child) {
        final imagePath = profileEditProvider.imagePath;
        final backgroundImage = imagePath != null && imagePath.isNotEmpty
            ? FileImage(File(imagePath))
            : avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : AssetImage('assets/ava.png') as ImageProvider;

        return CircleAvatar(
          backgroundImage: backgroundImage,
          radius: 60,
        );
      },
    );
  }
}
