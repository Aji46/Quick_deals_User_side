import 'package:flutter/material.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
       
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/quick_o_deal.png',
              width: 500,
              height: 500,
            ),
          ),
     const SizedBox(height: 40,),
          Image.asset(
            'assets/OIG1 (1).jpeg',
            height: 303,

          ),
        
        ],
      ),
    );
  }
}
