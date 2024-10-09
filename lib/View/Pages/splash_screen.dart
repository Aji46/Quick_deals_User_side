// splash_screen_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/splash_screen_provider.dart';
import 'package:quick_o_deals/View/widget/bottom_nav_bar/bottom%20_navigation_bar.dart';


class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  void _navigateToHome(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashScreenProvider(),
      child: Consumer<SplashScreenProvider>(
        builder: (context, provider, _) {
          if (!provider.isNavigating) {
            provider.startNavigation();
            _navigateToHome(context);
          }

          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/quick_o_deal.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/OIG1 (1).jpeg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}