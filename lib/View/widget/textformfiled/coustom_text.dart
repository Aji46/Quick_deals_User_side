import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/validation/provider.dart';
import 'package:quick_o_deals/contants/color.dart';

// Import the provider class

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
   final String? prefixText; 

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.validator,
    this.isPassword = false,
     this.prefixText, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth > 600 ? 50 : 30;


     
      return  Consumer<TextFieldProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.only(top: 20, right: paddingValue, left: paddingValue),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isPassword && provider.obscureText,
              decoration: InputDecoration(
                 prefixText: prefixText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                fillColor: MyColors.mycolor2,
                filled: true,
                labelText: labelText,
                labelStyle: const TextStyle(color: MyColors.mycolor7),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                            provider.obscureText ? Icons.visibility : Icons.visibility_off),
                        onPressed: provider.toggleObscureText,
                      )
                    : null,
              ),
              validator: validator,
            ),
          );
        },
      );
    
  }
}
