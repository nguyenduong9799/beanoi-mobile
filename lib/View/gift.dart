import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/acessories/product_promotion.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

class GiftScreen extends StatefulWidget {
  const GiftScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GiftScreenState();
  }
}

class _GiftScreenState extends State<GiftScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    await RootViewModel.getInstance().getGifts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.12),
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Danh sách quà tặng",
                      style: TextStyle(
                        fontSize: 24,
                        color: kPrimary,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ScopedModelDescendant<RootViewModel>(
                      builder: (context, child, model) {
                        switch (model.status) {
                          case ViewStatus.Error:
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                Center(
                                  child: Text(
                                    "Có gì đó sai sai..\n Vui lòng thử lại.",
                                    // style: kTextPrimary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Image.asset(
                                  'assets/images/global_error.png',
                                  fit: BoxFit.contain,
                                ),
                              ],
                            );
                          case ViewStatus.Loading:
                            return AspectRatio(
                                aspectRatio: 1,
                                child: Center(
                                  child: LoadingBean(),
                                ));
                          default:
                            if (model.gifts.isEmpty || model.gifts == null) {
                              return Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  color: Colors.black45,
                                  child: ListView(
                                    children: [
                                      Container(
                                        child: AspectRatio(
                                          aspectRatio: 1.5,
                                          child: Image.asset(
                                            'assets/images/empty-product.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Hmm, hiện tại chưa có quà nào hết á",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              controller: model.giftScrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: model.gifts.length,
                              itemBuilder: (context, index) => Container(
                                  padding: EdgeInsets.all(8.0),
                                  height: Get.width * 0.25 + 32,
                                  child: StorePromotion(
                                    model.gifts[index],
                                  )), // -> Text widget.
                              //viewportFraction: 1,
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            HomeAppBar(),
          ],
        ),
      ),
    );
  }
}
