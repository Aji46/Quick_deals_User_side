







// class ProfileAvatar extends StatelessWidget {
//   final String imagePath;
//   final String avatarUrl;

//   const ProfileAvatar({
//     Key? key,
//     this.imagePath = 'assets/ava.png',
//     required this.avatarUrl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProfileEditProvider>(
//       builder: (context, profileEditProvider, child) {
//         return CircleAvatar(
//           backgroundImage: profileEditProvider.imagePath!.isNotEmpty
//               ? FileImage(File(profileEditProvider.imagePath.toString()))
//               : avatarUrl.isNotEmpty
//                   ? NetworkImage(avatarUrl)
//                   : AssetImage(imagePath) as ImageProvider,
//           radius: 60,
//         );
//       },
//     );
//   }
// }


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






// class ProfileAvatar_edite extends StatelessWidget {
//   final String imagePath;
//   final String avatarUrl;

//   const ProfileAvatar_edite({
//     Key? key,
//     this.imagePath = 'assets/ava.png',
//     required this.avatarUrl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print(".........................");
//     return CircleAvatar( 
//       backgroundImage: avatarUrl.isNotEmpty
//           ? NetworkImage(avatarUrl)
//           : AssetImage(imagePath) ,
//       radius: 60,
//     );
//   }
// }