import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

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
    await Get.find<GiftViewModel>().getGifts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel(
      model: Get.find<GiftViewModel>(),
      child: Scaffold(
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
                      Material(
                        elevation: 2,
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text("Danh sách quà tặng",
                                style: Get.theme.textTheme.headline1
                                    .copyWith(color: Colors.orange)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ScopedModelDescendant<GiftViewModel>(
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
                                if (model.gifts == null ||
                                    model.gifts.isEmpty) {
                                  return ListView(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 24, 16, 8),
                                        color: Colors.white,
                                        child: Center(
                                          child: Column(
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
                                                  "Hiện các món quà đã Sold out hết rồi. Nhanh tay đổi quà vào hôm sau nhé 😁",
                                                  textAlign: TextAlign.center,
                                                  style: Get
                                                      .theme.textTheme.headline2
                                                      .copyWith(
                                                          color:
                                                              Colors.orange)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Container(
                                  margin: EdgeInsets.only(top: 16),
                                  child: ListView.builder(
                                    controller: model.giftScrollController,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: model.gifts.length,
                                    itemBuilder: (context, index) => Container(
                                        padding: EdgeInsets.all(8.0),
                                        height: Get.width * 0.25 + 32,
                                        child: StorePromotion(
                                          dto: model.gifts[index],
                                        )), // -> Text widget.
                                    //viewportFraction: 1,
                                  ),
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GiftAppBar(),
            ],
          ),
        ),
      ),
    );
  }
}
