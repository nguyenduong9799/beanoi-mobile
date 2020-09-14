

import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/View/home.dart';

class DefaultNavigatorBar extends StatefulWidget{

  int selectedIndex;


  DefaultNavigatorBar({Key key, @required this.selectedIndex}) : super(key: key);

  @override
  _NavBarSate createState() {
    // TODO: implement createState
    return new _NavBarSate();
  }

}

class _NavBarSate extends State<DefaultNavigatorBar>{



  static  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomeScreen(),
    HomeScreen()
  ];

  void _onItemTapped(int index) {
    if(index != widget.selectedIndex){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => _widgetOptions[index],));
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home', style: TextStyle(fontSize: 12),),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          title: Text('Gift', style: TextStyle(fontSize: 12)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile', style: TextStyle(fontSize: 12)),
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

}