import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Utils/format_price.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

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
    await Get.find<AccountViewModel>().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel(
      model: Get.find<AccountViewModel>(),
      child: Scaffold(
        backgroundColor: kBackgroundGrey[0],
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
            ],
          );

        return SingleChildScrollView(
          child: Column(
            children: [
              account(),
              userAccount(model),
              SizedBox(
                height: 4,
              ),
              systemInfo(model)
            ],
          ),
        );
      },
    );
  }

  Widget account() {
    return ScopedModelDescendant<AccountViewModel>(
        builder: (context, child, model) {
      return Container(
        //color: Color(0xFFddf1ed),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: Get.width * 0.3,
              width: Get.width * 0.3,
              decoration:
                  BoxDecoration(color: kPrimary, shape: BoxShape.circle),
              child: ClipOval(child: Image.asset('assets/images/avatar.png')),
            ),
            SizedBox(
              width: 16,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.currentUser.name,
                    style: Get.theme.textTheme.headline1
                        .copyWith(color: Colors.orange),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  infoDetail("Số xu: ", color: Colors.grey, list: [
                    TextSpan(
                        text:
                            formatPriceWithoutUnit(model.currentUser.balance) +
                                " xu",
                        style: Get.theme.textTheme.headline4)
                  ]),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      infoDetail("Số bean: ", color: Colors.grey, list: [
                        TextSpan(
                            text:
                                formatPriceWithoutUnit(model.currentUser.point),
                            style: Get.theme.textTheme.headline4),
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Image(
                              image: AssetImage(
                                  "assets/images/icons/bean_coin.png"),
                              width: 20,
                              height: 20,
                            ))
                      ]),
                      Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: InkWell(
                          onTap: () async {
                            showLoadingDialog();
                            await model.fetchUser(isRefetch: true);
                            hideDialog();
                          },
                          child: Icon(
                            Icons.replay,
                            color: kPrimary,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  infoDetail("Mã giới thiệu: ", color: Colors.grey, list: [
                    TextSpan(
                        text: model.currentUser.referalCode ?? "-",
                        style: Get.theme.textTheme.headline4)
                  ]),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget userAccount(AccountViewModel model) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Divider(),
            section(
                icon: Icon(Icons.person, color: Colors.black54),
                title: Text("Cập nhật thông tin",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.black54)),
                function: () async {
                  bool result = await Get.toNamed(RouteHandler.UPDATE,
                      arguments: model.currentUser);
                  if (result != null) {
                    if (result) {
                      await model.fetchUser();
                    }
                  }
                }),
            Divider(),
            section(
                icon: Icon(Icons.shopping_bag, color: Colors.black54),
                title: Text("Đơn hàng",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.black54)),
                function: () {
                  Get.toNamed(RouteHandler.ORDER_HISTORY);
                }),
            Divider(),
            section(
                icon: Icon(Icons.history, color: Colors.black54),
                title: Text("Lịch sử giao dịch",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.black54)),
                function: () {
                  Get.toNamed(RouteHandler.TRANSACTION);
                }),
            Divider(),
            section(
                icon: Icon(Icons.credit_card_outlined, color: Colors.black54),
                title: Text("Nhập mã giới thiệu",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.black54)),
                function: () async {
                  await model.showRefferalMessage();
                }),
            Divider(),
            section(
                icon: Icon(
                  AntDesign.facebook_square,
                  color: Colors.black54,
                ),
                title: Text("Theo dõi BeanOi",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.black54)),
                function: () {
                  _launchUrl(
                      "https://www.facebook.com/Bean-%C6%A0i-103238875095890",
                      isFB: true);
                }),
            Divider(),
            section(
                icon: Icon(Icons.feedback_outlined, color: Colors.black54),
                title: Text("Góp ý",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.black54)),
                function: () async {
                  await model.sendFeedback();
                }),
            Divider(),
            section(
                icon: Icon(Icons.help_outline, color: Colors.black54),
                title: Text("Hỗ trợ",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.black54)),
                function: () async {
                  int option = await showOptionDialog(
                      "Vui lòng liên hệ FanPage",
                      firstOption: "Quay lại",
                      secondOption: "Liên hệ");
                  if (option == 1) {
                    _launchUrl(
                        "https://www.facebook.com/Bean-%C6%A0i-103238875095890",
                        isFB: true);
                  }
                }),
            Divider(),
            section(
                icon: Icon(Icons.logout, color: Colors.black54),
                title: Text(
                  "Đăng xuất",
                  style:
                      Get.theme.textTheme.headline4.copyWith(color: Colors.red),
                ),
                function: () async {
                  await model.processSignout();
                }),
          ],
        ),
      ),
    );
  }

  Widget infoDetail(String title,
      {int size, Color color, List<InlineSpan> list}) {
    return RichText(
        text: TextSpan(
            text: title,
            style: Get.theme.textTheme.headline4,
            children: list ?? []));
  }

  Widget section({Icon icon, Text title, Function function}) {
    return InkWell(
      onTap: function ?? () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon ?? SizedBox.shrink(),
                SizedBox(
                  width: 8,
                ),
                title ?? Text("Mặc định"),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget systemInfo(AccountViewModel model) {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 32, bottom: 0, top: 8),
      padding: EdgeInsets.only(left: 32, right: 32),
      // decoration: BoxDecoration(
      //   border: Border(top: BorderSide(color: kBackgroundGrey[3], width: 1)),
      // ),

      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Version ${model.version} by UniTeam",
              style:
                  Get.theme.textTheme.headline4.copyWith(color: Colors.black54),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              // height: 40,
              child: RichText(
                text: TextSpan(
                  text: "Bean delivery ",
                  style: Get.theme.textTheme.headline3,
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

  void _launchUrl(String url, {bool isFB = false, forceWebView = false}) {
    // if(isFB){
    //   String fbProtocolUrl;
    //   if (Platform.isIOS) {
    //     fbProtocolUrl = 'fb://profile/Bean-Ơi-103238875095890';
    //   } else {
    //     fbProtocolUrl = 'fb://page/Bean-Ơi-103238875095890';
    //   }
    //   try {
    //     bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
    //
    //     if (!launched) {
    //       await launch(url, forceSafariVC: false);
    //     }
    //   } catch (e) {
    //     await launch(url, forceSafariVC: false);
    //   }
    // }else
    Get.toNamed(RouteHandler.WEBVIEW, arguments: url);
  }
}
