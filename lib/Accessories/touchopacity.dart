import 'package:flutter/material.dart';

class TouchOpacity extends StatefulWidget {
  final Function onTap;
  final Widget child;

  const TouchOpacity({Key key, this.onTap, @required this.child})
      : super(key: key);
  @override
  TouchOpacityState createState() {
    return TouchOpacityState();
  }
}

class TouchOpacityState extends State<TouchOpacity> {
  bool isTappedDown = false;

  @override
  Widget build(BuildContext context) {
    var onTap = this.widget.onTap;
    return GestureDetector(
      onTap: () {
        onTap != null && onTap();
      },
      onTapDown: (_) => setState(() => isTappedDown = true),
      onTapUp: (_) => setState(() => isTappedDown = false),
      onTapCancel: () => setState(() => isTappedDown = false),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: isTappedDown ? 0.6 : 1,
        child: this.widget.child,
      ),
    );
  }
}
