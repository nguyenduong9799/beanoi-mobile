import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import '../constraints.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen();

  @override
  _UpdateAccountState createState() {
    // TODO: implement createState
    return new _UpdateAccountState();
  }
}

class _UpdateAccountState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    await AccountViewModel.getInstance().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel(
      model: AccountViewModel.getInstance(),
      child: Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: userInfo())),
      ),
    );
  }

  Widget userInfo() {
    return ScopedModelDescendant<AccountViewModel>(
      builder: (context, child, model) {
        final status = model.status;
        if (status == ViewStatus.Loading)
          return Center(child: LoadingBean());
        else if (status == ViewStatus.Error)
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/global_error.png',
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Có gì đó sai sai..\n Vui lòng thử lại.",
                        // style: kTextPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              signoutButton(),
            ],
          );

        return Container(
          color: kBackgroundGrey[0],
          padding: EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    userImage(),
                    SizedBox(
                      height: 8,
                    ),
                    userAccount(model.currentUser),
                    SizedBox(
                      height: 8,
                    ),
                    userButton("Cập nhật", model),
                    SizedBox(
                      height: 4,
                    ),
                    signoutButton()
                  ],
                ),
              ),
              systemInfo(model)
            ],
          ),
        );
      },
    );
  }

  Widget userImage() {
    return Center(
      child: Container(
        height: Get.width * 0.5,
        width: Get.width * 0.5,
        decoration: BoxDecoration(
            border: Border.all(width: 5.0, color: kPrimary),
            shape: BoxShape.circle),
        child: ClipOval(child: Image.asset('assets/images/avatar.png')),
      ),
    );
  }

  Widget userAccount(AccountDTO user) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Text(
              user.name.toUpperCase(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoDetail("Số tiền trong ví: ", list: [
                  WidgetSpan(
                      child: SizedBox(
                    width: 8,
                  )),
                  TextSpan(
                      text: "${user.balance} xu",
                      style: TextStyle(fontWeight: FontWeight.normal))
                ]),
                infoDetail("Số bean trong ví: ", list: [
                  WidgetSpan(
                      child: SizedBox(
                    width: 8,
                  )),
                  TextSpan(
                      text: "${user.point} ",
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  WidgetSpan(
                      alignment: PlaceholderAlignment.bottom,
                      child: Image(
                        image: AssetImage("assets/images/icons/bean_coin.png"),
                        width: 20,
                        height: 20,
                      ))
                ]),
                infoDetail("Ngày sinh: ", list: [
                  WidgetSpan(
                      child: SizedBox(
                    width: 8,
                  )),
                  TextSpan(
                      text:
                          "${DateFormat('dd/MM/yyyy').format(user.birthdate)}",
                      style: TextStyle(fontWeight: FontWeight.normal))
                ]),
                infoDetail("Giới tính: ", list: [
                  WidgetSpan(
                      child: SizedBox(
                    width: 8,
                  )),
                  TextSpan(
                      text: "${user.gender}",
                      style: TextStyle(fontWeight: FontWeight.normal))
                ]),
                infoDetail("Email: ", list: [
                  WidgetSpan(
                      child: SizedBox(
                    width: 8,
                  )),
                  TextSpan(
                      text: "${user.email}",
                      style: TextStyle(fontWeight: FontWeight.normal))
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoDetail(String title,
      {int size, Color color, List<InlineSpan> list}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                  color: color ?? Colors.black,
                  fontSize: size ?? 16,
                  fontWeight: FontWeight.bold),
              children: list ?? [])),
    );
  }

  Widget userButton(String text, AccountViewModel model) {
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
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () async {
          bool result = await Get.toNamed(RouteHandler.SIGN_UP,
              arguments: model.currentUser);
          if (result != null) {
            if (result) {
              await model.fetchUser();
            }
          }
        },
      ),
    );
  }

  Widget signoutButton() {
    return ScopedModelDescendant<AccountViewModel>(
        builder: (context, child, model) {
      return Container(
        margin: const EdgeInsets.only(left: 80.0, right: 80.0),
        child: OutlineButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          textColor: kBackgroundGrey[0],
          color: kBackgroundGrey[0],
          borderSide: BorderSide(color: Colors.red),
          splashColor: kBackgroundGrey[3],
          child: Text(
            "Đăng xuất",
            style: TextStyle(fontSize: 16, color: kFail),
          ),
          onPressed: () async {
            await model.processSignout();
          },
        ),
      );
    });
  }

  Widget systemInfo(AccountViewModel model) {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 32, bottom: 0, top: 16),
      padding: EdgeInsets.only(left: 32, right: 32),
      // decoration: BoxDecoration(
      //   border: Border(top: BorderSide(color: kBackgroundGrey[3], width: 1)),
      // ),

      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Version ${model.version} by UniTeam",
              style: TextStyle(fontSize: 13, color: kBackgroundGrey[5]),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              // height: 40,
              child: RichText(
                text: TextSpan(
                  text: "Bean delivery ",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                      // fontStyle: FontStyle.italic,
                      ),
                  // children: <TextSpan>[
                  //   TextSpan(
                  //     text: "UniTeam",
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontStyle: FontStyle.italic,
                  //     ),
                  //   )
                  // ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
