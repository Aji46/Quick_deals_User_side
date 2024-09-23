// lib/View/widget/login_widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';
import 'package:quick_o_deals/View/widget/custom_bottons/custom_button.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CustomTextFormField(
              controller: emailController,
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
              validator: (value) => ValidationUtils.validateemail(value),
            ),
            CustomTextFormField(
              controller: passwordController,
              labelText: "Password",
              validator: (value) => ValidationUtils.validate(value, 'Password'),
              isPassword: true,
            ),
            const SizedBox(height: 24.0),
            CustomButton(
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  try {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.signInWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                    );

                    if (authProvider.user != null) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('userEmail', emailController.text);
                      await prefs.setBool('isLoggedIn', true);
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              buttonText: 'Sign In',
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
