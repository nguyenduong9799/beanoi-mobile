import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/acessories/bottomnavigator.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    Scaffold(),
    Scaffold(),
  ];
  final List<IconData> _icons = const [
    Icons.home,
    Icons.card_giftcard,
    Icons.person,
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            // padding: const EdgeInsets.only(bottom: 12.0),
            color: Colors.white,
            child: CustomTabBar(
              icons: _icons,
              selectedIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
          )),
    );
  }
}
