import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/google_auth.dart';
import 'package:quick_o_deals/Controller/auth/provider/register.dart';
import 'package:quick_o_deals/View/widget/logos/logo.dart';
import 'package:quick_o_deals/View/widget/register/loin_buttons.dart';
import 'package:quick_o_deals/View/widget/register/policy_text.dart';
import 'package:quick_o_deals/View/widget/register/sigh_up_button.dart';
import 'package:quick_o_deals/View/widget/register/textfiled.dart';

class UserRegister extends StatefulWidget {
  UserRegister({Key? key}) : super(key: key);

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: Consumer2<GoogleSignInProvider, TermsProvider>(
        builder: (context, googleSignInProvider, termsProvider, child) {
          if (googleSignInProvider.user != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {

            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Logo(),
                  ),
                  UserFormPage(
                    usernameController: usernameController,
                    emailController: emailController,
                    passwordController: passwordController,
                    phoneController: phoneController,
                    formKey: _formKey,
                  ),
                  const TermsPolicyWidget(), 
                  const SizedBox(height: 16.0),
                 SignUpButton(
                    formKey: _formKey,
                    usernameController: usernameController,
                    emailController: emailController,
                    phoneController: phoneController,
                    passwordController: passwordController,
                    acceptedTerms: termsProvider.acceptedTerms,
                  ),
                  const SizedBox(height: 16.0),
                  LoginButtonsWidget(),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Sign In"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
