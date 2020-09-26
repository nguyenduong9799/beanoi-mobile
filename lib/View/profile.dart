import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';

import '../constraints.dart';

class ProfileScreen extends StatefulWidget {
  AccountDTO dto;

  ProfileScreen(this.dto);

  @override
  _UpdateAccountState createState() {
    // TODO: implement createState
    return new _UpdateAccountState();
  }
}

class _UpdateAccountState extends State<ProfileScreen> {
  Image _userImage;

  @override
  void initState() {
    super.initState();
    _userImage = Image(
      image: NetworkImage(defaultImage),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: userInfo(widget.dto),
    );
  }

  Widget userInfo(AccountDTO dto) {
    return Container(
      color: kBackgroundGrey[0],
      child: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                backButton(),
                userImage(),
                SizedBox(
                  height: 8,
                ),
                userAccount(),
                SizedBox(
                  height: 8,
                ),
                userButton("Cập nhật"),
                // SizedBox(
                //   height: 8,
                // ),
                // userButton("Đánh giá"),
                // SizedBox(
                //   height: 8,
                // ),
                // userButton("Hỏi đáp"),
                // SizedBox(
                //   height: 8,
                // ),
                // userButton("Giới thiệu"),
                SizedBox(
                  height: 8,
                ),
                signoutButton()
              ],
            ),
          ),
          systemInfo()
        ],
      ),
    );
  }

  Widget backButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimary.withOpacity(0.8),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget userImage() {
    return Center(
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
            border: Border.all(width: 5.0, color: kPrimary),
            shape: BoxShape.circle),
        child: ClipOval(child: _userImage),
      ),
    );
  }

  Widget userAccount() {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              widget.dto != null ? widget.dto.name : "Bean",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text("Bạn có 100.000 đ trong ví", style: TextStyle(fontSize: 15)),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget userButton(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 80.0, right: 80.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        textColor: kBackgroundGrey[0],
        color: kPrimary,
        splashColor: kSecondary,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget signoutButton() {
    return Container(
      margin: const EdgeInsets.only(left: 80.0, right: 80.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        textColor: kBackgroundGrey[0],
        color: kBackgroundGrey[0],
        splashColor: kBackgroundGrey[3],
        child: Text(
          "Đăng xuất",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: kFail),
        ),
        onPressed: () async {
          int choice = await getOption(context, "Bạn có chắc không?");
          if (choice == 1) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false);
          }
        },
      ),
    );
  }

  Widget systemInfo() {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 32, bottom: 0, top: 16),
      padding: EdgeInsets.only(left: 32, right: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: kBackgroundGrey[3], width: 1)),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Version $VERSION",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Container(
              // height: 40,
              child: RichText(
                text: TextSpan(
                  text: "By - ",
                  style: TextStyle(
                    fontSize: 12,
                    color: kBackgroundGrey[5],
                    // fontStyle: FontStyle.italic,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "UniTeam",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
