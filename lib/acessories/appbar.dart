import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;


  DefaultAppBar({Key key, this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  _AppBarSate createState() {
    // TODO: implement createState
    return new _AppBarSate();
  }

}

class _AppBarSate extends State<DefaultAppBar>{

  Icon actionIcon = Icon(Icons.search);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      elevation: 5.0,
      centerTitle: true,
      title: Text(widget.title, style: TextStyle(color: Colors.white),),
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {},
        )
      ],
    );
  }



}


class HomeAppBar extends StatefulWidget{

  @override
  _HomeAppBarSate createState() {
    // TODO: implement createState
    return new _HomeAppBarSate();
  }


}

class _HomeAppBarSate extends State<HomeAppBar>{

  String _timeString;
  double _appBarRadius = 10;
  double _imageRadius = 5;
  double _elevation = 5;
  Color _appBarColor = Color(0xFF438029);
  Color _primeColor = Color(0xFF619a46);
  TextStyle _title = TextStyle(fontSize: 20, fontWeight: FontWeight.w100, color: Colors.white);
  TextStyle _heading = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle _content = TextStyle(fontSize: 15, fontWeight: FontWeight.w100, color: Colors.white);
  TextStyle _time = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);


  @override
  void initState() {
    if(DateTime.now().hour > 11){
      _timeString = DateTime.now().add(Duration(days: 1)) - DateTime.now();
    }
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(minutes: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: _appBarColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(_appBarRadius),
              bottomRight: Radius.circular(_appBarRadius)
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 25),
            child: Row(
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: _primeColor,
                          borderRadius: BorderRadius.all(Radius.circular(_imageRadius),)
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                          image: AssetImage("assets/images/avatar.png"),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: -5,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),
                      ),
                    )
                  ],

                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 230,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: Text("Chào Bean! bạn đã đói bụng chưa?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,),)),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Image(
                            image: AssetImage("assets/images/balance.png"),
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(child: Text("Bạn đang có 100 bean trong ví", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100, color: Colors.white),)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10, top: 15),
            height: 90,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              color: Color(0xFF619a46),
            ),
            child: Center(
              child: Text(_timeString, style: _time, textAlign: TextAlign.center,),
            ),

          )
        ],
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

}