import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:unidelivery_mobile/Services/firebase.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/View/orderHistory.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;

  DefaultAppBar({Key key, this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  _AppBarSate createState() {
    return new _AppBarSate();
  }
}

class _AppBarSate extends State<DefaultAppBar> {
  Icon actionIcon = Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5.0,
      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {},
        )
      ],
    );
  }
}

class HomeAppBar extends StatefulWidget {
  @override
  _HomeAppBarSate createState() {
    return new _HomeAppBarSate();
  }
}

class _HomeAppBarSate extends State<HomeAppBar> {
  String _timeString = "";
  double _appBarRadius = 10;
  double _imageRadius = 5;
  double _elevation = 5;
  Color _appBarColor = Color(0xFF438029);
  Color _primeColor = Color(0xFF619a46);
  TextStyle _title =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w100, color: Colors.white);
  TextStyle _heading =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle _content =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w100, color: Colors.white);
  TextStyle _time =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Container(
      height: 70,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        color: _primeColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(_imageRadius),
                        )),
                    child: GestureDetector(
                      onTap: () async {
                        await AuthService().signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false);
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                          image: AssetImage("assets/images/avatar.png"),
                          width: 40,
                          height: 40,
                        ),
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
                          shape: BoxShape.circle, color: Colors.red),
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
                    Flexible(
                        child: Text(
                      "Chào Bean, Đừng để bụng đói nha!",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )),
                    SizedBox(
                      height: 5,
                    ),
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
                        Flexible(
                            child: Text(
                          "Bạn có 100.000đ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: Colors.black),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.history,
                    size: 30,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderHistoryScreen(),
                  ));
                },
              ),
            ),
          )
          // Container(
          //   margin: const EdgeInsets.only(right: 10, top: 15),
          //   height: 90,
          //   width: 55,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(
          //       bottomRight: Radius.circular(30),
          //       bottomLeft: Radius.circular(30),
          //     ),
          //     color: Color(0xFF619a46),
          //   ),
          //   child: Center(
          //     child: Text(
          //       _timeString,
          //       style: _time,
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void _getTime() {
    final now = DateTime.now();
    final orderTime = DateTime(now.year, now.month, now.day, 11);
    int milisecond;
    if (now.isAfter(orderTime)) {
      milisecond = -1;
    } else {
      milisecond =
          orderTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
    }

    setState(() {
      if (milisecond == -1) {
        _timeString = "Hết giờ";
      } else {
        final String formattedDateTime = _formatDateTime(milisecond);
        print(milisecond);
        _timeString = formattedDateTime;
      }
    });
  }

  String _formatDateTime(int mili) {
    int min = ((mili / (1000 * 60)) % 60).toInt();
    int hr = ((mili / (1000 * 60 * 60)) % 24).toInt();
    return hr.toString() + ":" + min.toString();
  }
}
