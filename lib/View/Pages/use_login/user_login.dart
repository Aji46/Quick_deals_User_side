import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';
import 'package:quick_o_deals/Controller/auth/provider/google_auth.dart';
import 'package:quick_o_deals/View/widget/register/loin_buttons.dart';
import 'package:quick_o_deals/View/widget/use_login_widgets.dart/image_widget.dart';
import 'package:quick_o_deals/View/widget/use_login_widgets.dart/login_forms.dart';
import 'package:quick_o_deals/View/widget/use_login_widgets.dart/logo_widget.dart';
import 'package:quick_o_deals/View/widget/use_login_widgets.dart/signup_widget.dart';

class UserLogin extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  UserLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer2<AuthProvider, GoogleSignInProvider>(
        builder: (context, authProvider, googleSignInProvider, child) {
          if (authProvider.user != null || googleSignInProvider.user != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
          }
          return ListView(
            children: [
              LogoWidget(),
              ImageWidget(
                imagePath: "assets/OIG1 (1).jpeg",
                height: 200,
                width: 400,
              ),
              LoginForm(
                formKey: _formKey,
                emailController: emailController,
                passwordController: passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              LoginButtonsWidget(),
              const SizedBox(
                height: 10,
              ),
              SignUpLink(),
            ],
          );
        },
      ),
    );
  }
}
