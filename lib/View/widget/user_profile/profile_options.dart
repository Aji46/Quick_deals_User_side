import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: const Color.fromARGB(255, 2, 112, 247),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
