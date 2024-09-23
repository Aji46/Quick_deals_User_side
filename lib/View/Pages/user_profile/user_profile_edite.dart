import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/profile_image_check.dart';
import 'package:quick_o_deals/Controller/profile_edit_provider.dart';
import 'package:quick_o_deals/View/widget/user_profile/contact_section.dart';
import 'package:quick_o_deals/View/widget/user_profile/top_part_profile.dart';

class ProfileEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final image=Provider.of<ImageEditProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ProfileEditProvider(context),
      child: Consumer<ProfileEditProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text("Edit Profile"),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileAvatarSection(userDetails: {'profilePicture': provider.imagePath,},),
                    UsernameSection(), 
                    const SizedBox(height: 50),
                    ContactSection(), 
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => provider.updateUserProfile(context,image.imagePath),
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
