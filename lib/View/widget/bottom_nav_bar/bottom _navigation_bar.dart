import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/login_.dart';
import 'package:quick_o_deals/View/Pages/chat/chatpage.dart';
import 'package:quick_o_deals/View/Pages/favorites/favorite_page.dart';
import 'package:quick_o_deals/View/Pages/home/home_screen.dart';
import 'package:quick_o_deals/View/Pages/product_add/product_add.dart';
import 'package:quick_o_deals/View/Pages/use_login/user_login.dart';
import 'package:quick_o_deals/View/Pages/user_profile/user_profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<logProvider>(
      builder: (context, value, child) => Scaffold(
        body: _getPageForIndex(_currentIndex, value),
        bottomNavigationBar: DotCurvedBottomNav(
          scrollController: ScrollController(),
          hideOnScroll: true,
          indicatorColor: Colors.blue,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.ease,
          selectedIndex: _currentIndex,
          indicatorSize: 5,
          borderRadius: 25,
          height: 70,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home,
              color: _currentIndex == 0
                  ? Colors.blue
                  : const Color.fromARGB(255, 136, 136, 136),
            ),
            Icon(
              Icons.chat,
              color: _currentIndex == 1
                  ? Colors.blue
                  : const Color.fromARGB(255, 161, 161, 161),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  'assets/add icon.png',
                  
                ),
              ),
            ),
            Icon(
              Icons.favorite_border,
              color: _currentIndex == 3
                  ? Colors.blue
                  : const Color.fromARGB(255, 143, 143, 143),
            ),
            Icon(
              Icons.person,
              color: _currentIndex == 4
                  ? Colors.blue
                  : const Color.fromARGB(255, 132, 132, 132),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPageForIndex(int index, logProvider authProvider) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return ChatPage();
      case 2:
        return authProvider.isLoggedIn ? ProductAdd() : UserLogin();
      case 3:
        return FavoritesPage();
      case 4:
        return authProvider.isLoggedIn ? UserProfile() : UserLogin();
      default:
        return HomeScreen();
    }
  }
}
