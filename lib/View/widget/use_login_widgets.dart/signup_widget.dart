// lib/View/widget/login_widgets/sign_up_link.dart
import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/Pages/user_register/user_register.dart';

class SignUpLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => UserRegister()));
            },
            child: const Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
