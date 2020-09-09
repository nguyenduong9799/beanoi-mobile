import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/services/firebase.dart';

class HomeScreen extends StatefulWidget {
  final AccountDTO user;
  const HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home screen"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello ${widget.user.name}"),
              Text("Home screen ${widget.user?.uid}"),
              RaisedButton(
                onPressed: () {
                  AuthService().signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                },
                child: Text("Sign out"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
