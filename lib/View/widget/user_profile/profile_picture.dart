import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/ava.png'),
        radius: 60,
      ),
    );
  }
}
