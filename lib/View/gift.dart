import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/gift_viewModel.dart';
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
  GitfViewModel model;

  Future<void> _refresh() async {
    await model.getGifts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel(
      model: model,
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
                      ScopedModelDescendant<GitfViewModel>(
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
                            case ViewStatus.Empty:
                              return Container(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                color: Colors.black45,
                                height: 400,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        "Aaa, hiện tại chưa có nhà hàng nào tại địa chỉ này, bạn vui lòng quay lại sau nhé",
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
                            default:
                              return ListView.builder(
                                controller: model.scrollController,
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    model = GitfViewModel.getInstance();
    model.getGifts();
  }
}
