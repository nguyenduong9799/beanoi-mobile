import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

class LoadingDialog extends StatefulWidget{

  @override
  _LoadingSate createState() {
    // TODO: implement createState
    return new _LoadingSate();
  }

}

class _LoadingSate extends State<LoadingDialog>{

  Widget pr;


  @override
  void initState() {
    setState(() {
      pr = Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(width: 8.0),
            SpinKitDualRing(
              color: Colors.blue[400],
              size: 40,
            ),
            const SizedBox(width: 20.0),
            Text(
              "Loading...",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      );
    });
    setState(() {
      pr = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 60,),
          Center(child: Text("Thành công", style: TextStyle(fontWeight: FontWeight.bold),)),
          SizedBox(height: 10,),
          Text("Đơn hàng của bạn sẽ được giao trong vòng 20 phút nữa"),
          SizedBox(height: 20,),
          ButtonTheme(
            minWidth: double.infinity,
            child: FlatButton(
              color: Hexcolor("ffc500"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("OK"),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                //Navigator.of(context).pop();
              },
            ),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
        backgroundColor: Colors.white,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0))),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pr,
            ],
          ),
        ));

    void waiting(){

    };
  }



}