import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/profile_image_check.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';
import 'package:quick_o_deals/Controller/profile_edit_provider.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/user_profile/edite_circleavathar.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';

class ProfileAvatarSection extends StatelessWidget {
    final Map<String, dynamic> userDetails;

  ProfileAvatarSection({required this.userDetails});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageEditProvider>(context);
    Provider.of<AuthProvider>(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Stack(
            children: [
             ProfileEditAvatar (
                      avatarUrl: userDetails['profilePicture'],
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    provider.selectImage();
                  },
                  icon: const Icon(
                    Icons.add_a_photo_rounded,
                    size: 24,
                  ),
                  color: const Color.fromARGB(255, 0, 119, 255),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class UsernameSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileEditProvider>(context);
    
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: CustomTextFormField(
          labelText: "Username",
          validator: ValidationUtils.validateUsername,
          controller: provider.usernameController,
        ),
      ),
    );
  }
}

