import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Center(
            child: Text("Login screen"),
          ),
        ),
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () {},
            child: Text("Login by phone number"),
          )
        ],
      ),
    );
  }
}
