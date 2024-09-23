// lib/View/widget/logos/logo_widget.dart
import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/widget/logos/logo.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Logo(),
    );
  }
}
