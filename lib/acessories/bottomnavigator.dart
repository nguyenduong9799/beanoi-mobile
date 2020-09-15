import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/constraints.dart';

class DefaultNavigatorBar extends StatefulWidget {
  final int selectedIndex;

  DefaultNavigatorBar({Key key, @required this.selectedIndex})
      : super(key: key);

  @override
  _NavBarSate createState() {
    return new _NavBarSate();
  }
}

class _NavBarSate extends State<DefaultNavigatorBar> {
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomeScreen(),
    HomeScreen()
  ];

  void _onItemTapped(int index) {
    if (index != widget.selectedIndex) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => _widgetOptions[index],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.0 * 7,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 16,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(color: kPrimary, size: 24),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 10),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Gift', style: TextStyle(fontSize: 10)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile', style: TextStyle(fontSize: 10)),
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
