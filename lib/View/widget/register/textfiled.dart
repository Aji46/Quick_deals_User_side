import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';

class UserFormPage extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;  

  UserFormPage({
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey, 
      child: Column(
        children: [
          CustomTextFormField(
            controller: usernameController,
            labelText: "User Name",
            validator: (value) =>
                ValidationUtils.validate(value, 'Username'),
          ),
          CustomTextFormField(
            controller: emailController,
            labelText: "Email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) => ValidationUtils.validateemail(value),
          ),
          CustomTextFormField(
            controller: passwordController,
            labelText: "Password",
            validator: (value) =>
                ValidationUtils.validate(value, 'Password'),
            isPassword: true,
          ),
          CustomTextFormField(
            controller: phoneController,
            labelText: "Phone Number",
            keyboardType: TextInputType.phone,
            validator: (value) =>
                ValidationUtils.validatePhoneNumber(value),
          ),
        ],
      ),
    );
  }
}
