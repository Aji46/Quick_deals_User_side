import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: labelText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
