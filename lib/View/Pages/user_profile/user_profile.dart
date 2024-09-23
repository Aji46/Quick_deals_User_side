import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';
import 'package:quick_o_deals/View/Pages/user_product/user_product.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';
import 'package:quick_o_deals/View/widget/user_profile/circle_avathar.dart';
import 'package:quick_o_deals/View/widget/user_profile/profile_edite_button.dart';
import 'package:quick_o_deals/View/widget/user_profile/profile_options.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.user == null) {
          // Redirect to the login page or show a message
          WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyHomePage()),
                                );// Adjust the route name as needed
          });
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<Map<String, dynamic>?>(
          future: authProvider.getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No user details found'));
            }

            var userDetails = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: const Text('User Profile'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: ProfileAvatar(
                      avatarUrl: userDetails['profilePicture'],
                    )),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '${userDetails['username'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(child: ViewEditButton()),
                    const SizedBox(height: 30),
                    Column(
                      children: [

                         ProfileOption(
                          icon: Icons.production_quantity_limits_outlined,
                          title: 'Your products',
                          onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UserProduct()),
                                );
                          },
                        ),
                          const SizedBox(height: 16),
                       
                        ProfileOption(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            // Action for Settings
                          },
                        ),
                        const SizedBox(height: 16),
                        ProfileOption(
                          icon: Icons.report_outlined,
                          title: 'Report Accounts',
                          onTap: () {
                            // Action for Report Accounts
                          },
                        ),
                        const SizedBox(height: 16),
                        ProfileOption(
                          icon: Icons.help_outline_sharp,
                          title: 'Help and Support',
                          onTap: () {
                            // Action for Help and Support
                          },
                        ),
                        const Center(child: SignoutButton()),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
