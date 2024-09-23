import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';
import 'package:quick_o_deals/Controller/auth/provider/login_.dart';
import 'package:quick_o_deals/View/Pages/user_profile/user_profile_edite.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';

class ViewEditButton extends StatelessWidget {
   ViewEditButton({super.key});
  
  @override
  Widget build(BuildContext context) {
   
    return ElevatedButton(
      onPressed: () {
        //userData.userData =

        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileEditPage()),
              );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('View and Edit Profile'),
    );
  }
}



class SignoutButton extends StatelessWidget {
  const SignoutButton({super.key});

  Future<void> confirmSignOut(BuildContext context) async {
    // Show a confirmation dialog before signing out
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog without logging out
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await signOutAndNavigate(context); // Proceed to sign out
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signOutAndNavigate(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();

      // Update login status and navigate to home page
      final logProvide = Provider.of<logProvider>(context, listen: false);
      logProvide.setLoginStatus(false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Show an error dialog if sign-out fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Sign out failed: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the error dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => confirmSignOut(context), // Show confirmation dialog
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('Sign Out'),
    );
  }
}
