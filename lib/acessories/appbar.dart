import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;


  DefaultAppBar({Key key, this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(100);

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10) )
      ),
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