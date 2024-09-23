import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';
import 'package:quick_o_deals/Controller/auth/provider/loding_provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/login_.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';
import 'package:quick_o_deals/View/widget/custom_bottons/custom_button.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {

    final pref =Provider.of<logProvider>(context);
    return Consumer<LoadingProvider>(
      builder: (context, loadingProvider, child) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                            loadingProvider.setLoading(true);
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
                                pref.setLoginStatus(true);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            } finally {
                              loadingProvider.setLoading(false);
                            }
                          }
                        },
                        buttonText: 'Sign In',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (loadingProvider.isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
