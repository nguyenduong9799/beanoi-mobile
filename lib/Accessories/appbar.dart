import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Accessories/dialog.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  Widget backButton;
  DefaultAppBar({Key key, @required this.title, this.backButton})
      : super(key: key);

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
      backgroundColor: Colors.white,
      elevation: 2.0,
      centerTitle: true,
      leading: widget.backButton != null
          ? widget.backButton
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child:
                      Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                ),
              ),
            ),
      title: Text(widget.title, style: Get.theme.textTheme.headline2),
    );
  }
}

class VoucherAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  Widget backButton;
  VoucherAppBar({Key key, @required this.title, this.backButton})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  _VoucherAppBarState createState() {
    return new _VoucherAppBarState();
  }
}

class _VoucherAppBarState extends State<VoucherAppBar> {
  Icon actionIcon = Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2.0,
      centerTitle: true,
      leading: widget.backButton != null
          ? widget.backButton
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child:
                      Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                ),
              ),
            ),
      title: Text(widget.title, style: Get.theme.textTheme.headline2),
      // iconTheme: Icons.plus_one,
      actions: <Widget>[
        InkWell(
          onTap: () {
            inputDialog('Thêm Mã Khuyến Mãi', 'Xác nhận');
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Icon(
              Icons.wallet_giftcard_outlined,
              color: kPrimary,
            ),
          ),
        )
      ],
    );
  }
}

class GiftAppBar extends StatefulWidget {
  @override
  _GiftAppBarSate createState() {
    return new _GiftAppBarSate();
  }
}

class _GiftAppBarSate extends State<GiftAppBar> {
  @override
  void initState() {
    super.initState();
  }

  Color _primeColor = Color(0xFF619a46);

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<AccountViewModel>(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.11,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  buildAvatar(),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: _buildWelcome()),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Image(
                                image: AssetImage("assets/images/balance.png"),
                                width: 18,
                                height: 18,
                              ),
                              SizedBox(width: 8),
                              Flexible(child: _buildBalance()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                      padding: EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/images/history.png',
                        width: 24,
                      )
                      // Icon(
                      //   Foundation.clipboard_notes,
                      //   size: 30,
                      //   color: Colors.white,
                      // ),
                      ),
                  onTap: () {
                    Get.toNamed(RouteHandler.ORDER_HISTORY);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              color: _primeColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
          child: ScopedModelDescendant<AccountViewModel>(
            builder: (context, child, model) {
              return GestureDetector(
                onTap: () async {
                  await model.fetchUser();
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("assets/images/avatar.png"),
                    width: 45,
                    height: 45,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 5,
          top: -5,
          child: Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
        )
      ],
    );
  }

  Widget _buildWelcome() {
    return ScopedModelDescendant<AccountViewModel>(
      builder: (context, child, model) {
        final status = model.status;
        final user = model.currentUser;
        if (status == ViewStatus.Loading)
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 20,
              color: Colors.grey,
            ),
          );
        else if (status == ViewStatus.Error) return Text("＞﹏＜");
        return RichText(
          text: TextSpan(
              text: "Chào ",
              style:
                  Get.theme.textTheme.headline4.copyWith(color: Colors.white),
              children: <TextSpan>[
                TextSpan(
                  text: "${user?.name?.toUpperCase() ?? "-"}",
                  style: Get.theme.textTheme.headline3
                      .copyWith(color: Colors.white),
                ),
                TextSpan(text: ", Đừng để bụng đói nha!"),
              ]),
        );
      },
    );
  }

  Widget _buildBalance() {
    return ScopedModelDescendant<AccountViewModel>(
      builder: (context, child, model) {
        final status = model.status;
        final user = model.currentUser;
        if (status == ViewStatus.Loading)
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 20,
              color: Colors.grey,
            ),
          );
        else if (status == ViewStatus.Error) return Text("＞﹏＜");
        return RichText(
          text: TextSpan(
              text: "Bạn có ",
              style:
                  Get.theme.textTheme.headline6.copyWith(color: Colors.white),
              children: [
                TextSpan(
                  text: "${user?.balance?.floor() ?? "-"} xu",
                  style: Get.theme.textTheme.headline5
                      .copyWith(color: Colors.white),
                ),
                TextSpan(text: " và "),
                TextSpan(
                  text: "${user?.point?.floor() ?? "-"} ",
                  style: Get.theme.textTheme.headline5.copyWith(color: kBean),
                ),
                WidgetSpan(
                    alignment: PlaceholderAlignment.bottom,
                    child: Image(
                      image: AssetImage("assets/images/icons/bean_coin.png"),
                      width: 20,
                      height: 20,
                    ))
              ]),
        );
      },
    );
  }
}
