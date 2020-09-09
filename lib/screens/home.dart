import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/services/firebase.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget?.user.uid);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello ${widget.user.displayName}"),
              Text("Home screen ${widget.user?.uid}"),
              RaisedButton(
                onPressed: () {
                  AuthService().signOut();
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
