import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/user_provider.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';

class SignUpButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool acceptedTerms;

  SignUpButton({
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.acceptedTerms,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: acceptedTerms
          ? () async {
              if (formKey.currentState!.validate()) {
                try {
                  await Provider.of<UserProvider>(context, listen: false).registerUser(
                    username: usernameController.text,
                    email: emailController.text,
                    phoneNumber: phoneController.text,
                    password: passwordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User registered successfully')),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const MyHomePage()));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text("Sign Up"),
    );
  }
}
