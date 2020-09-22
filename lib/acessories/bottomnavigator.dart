import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/orderHistory.dart';
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
    OrderHistoryScreen(),
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
      height: 8.0 * 6,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 14,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black45,
        selectedIconTheme: IconThemeData(color: kPrimary, size: 20),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/home.png"),
              // color: Colors.transparent,
            ),
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

class CustomTabBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isBottomIndicator;

  const CustomTabBar({
    Key key,
    @required this.icons,
    @required this.selectedIndex,
    @required this.onTap,
    this.isBottomIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorPadding: EdgeInsets.zero,
      indicator: BoxDecoration(
        border: isBottomIndicator
            ? Border(
                bottom: BorderSide(
                  color: kPrimary,
                  width: 3.0,
                ),
              )
            : Border(
                top: BorderSide(
                  color: kPrimary,
                  width: 3.0,
                ),
              ),
      ),
      tabs: icons
          .asMap()
          .map((i, e) => MapEntry(
                i,
                Tab(
                  icon: Icon(
                    e,
                    color: i == selectedIndex ? kPrimary : Colors.black45,
                    size: i == selectedIndex ? 24.0 : 16.0,
                  ),
                ),
              ))
          .values
          .toList(),
      onTap: onTap,
    );
  }
}
