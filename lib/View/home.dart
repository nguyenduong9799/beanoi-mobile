import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switcher = false;
  DateTime now = DateTime.now();

  // int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    RootViewModel.getInstance().getSuppliers();
  }

  Future<void> _refresh() async {
    await RootViewModel.getInstance().getSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return ScopedModelDescendant<RootViewModel>(
      builder:
          (BuildContext context, Widget child, RootViewModel rootViewModel) {
        return ScopedModel(
          model: HomeViewModel.getInstance(),
          child: Scaffold(
            floatingActionButton: buildCartButton(),
            backgroundColor: Colors.white,
            //bottomNavigationBar: bottomBar(),
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.12),
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _refresh,
                        child: Column(
                          children: [
                            banner(),
                            location(),
                            Expanded(child: storeList()),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  HomeAppBar(),
                  buildCountDown(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget location() {
    return ScopedModel(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, root) {
          String text = "Đợi tý đang load...";
          if (root.changeAddress) {
            text = "Đang thay đổi...";
          } else {
            if (root.dto != null) {
              text = "${root.dto.name} - ${root.dto.location}";
            }
          }

          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      text,
                      style: kTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              await root.processChangeAddress();
            },
          );
        },
      ),
    );
  }

  Widget buildCartButton() {
    return ScopedModelDescendant(
        rebuildOnChange: true,
        builder: (context, child, HomeViewModel model) {
          return FutureBuilder(
              future: model.cart,
              builder: (context, snapshot) {
                Cart cart = snapshot.data;
                if (cart == null) return SizedBox.shrink();
                int quantity = cart?.itemQuantity();
                return Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    elevation: 8,
                    heroTag: CART_TAG,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // side: BorderSide(color: Colors.red),
                    ),
                    onPressed: () async {
                      print('Tap order');
                      await model.openCart();
                    },
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            AntDesign.shoppingcart,
                            color: kPrimary,
                          ),
                        ),
                        Positioned(
                          top: -10,
                          left: 32,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red,
                              //border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: kTextPrimary.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Positioned buildCountDown() {
    return Positioned(
      top: 150,
      left: 0,
      child: RotatedBox(
        quarterTurns: 1,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          decoration: BoxDecoration(
            color: const Color(0xFFE8581C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Column(
            children: [
              Text(
                RootViewModel.getInstance().endOrderTime ? "Hết giờ" : "Còn lại",
                style: kTextPrimary.copyWith(fontWeight: FontWeight.bold),
              ),
              CountdownTimer(
                emptyWidget: Container(),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                endTime: RootViewModel.getInstance().orderTime.millisecondsSinceEpoch,
                onEnd: () {
                  RootViewModel.getInstance().endOrderTime = true;
                  RootViewModel.getInstance().notifyListeners();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget storeList() {
    return ScopedModelDescendant<RootViewModel>(
      builder: (context, child, model) {
        ViewStatus status = model.status;
        switch (status) {
          case ViewStatus.Error:
            return ListView(
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
          case ViewStatus.Completed:
            return ListView.separated(
              itemBuilder: (context, index) {
                return buildStore(model.suppliers[index]);
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.suppliers.length,
            );
          default:
            return Text("Some thing wrong");
        }
      },
    );
  }

  Widget buildStore(StoreDTO dto) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHandler.HOME_DETAIL, arguments: dto);
      },
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Opacity(
              opacity: 1,
              child: (dto.imageUrl == null || dto.imageUrl == "")
                  ? Icon(
                      MaterialIcons.broken_image,
                      color: kPrimary.withOpacity(0.5),
                    )
                  : CachedNetworkImage(
                      imageUrl: dto.imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        MaterialIcons.broken_image,
                        color: kPrimary.withOpacity(0.5),
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Text(dto.name)
        ],
      ),
    );
  }

  List<String> imgList = [
    "https://dichvuquantriweb.com/wp-content/uploads/2016/02/banner-noel.jpg",
    "https://previews.123rf.com/images/limbi007/limbi0072003/limbi007200300143/151208245-happy-new-year-2021-banner-with-golden-sand-and-ornaments-eps-10-vector-file-.jpg",
    "https://i.pinimg.com/originals/aa/72/58/aa72583fa16497aa429bb483fcf77ee9.jpg"
  ];

  Widget banner() {
    return Container(
      //padding: EdgeInsets.only(top: 8, bottom: 8),
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Swiper(
          onTap: (index) async {
            await _launchURL(
                "https://kenh14.vn/hoa-ra-cang-bi-crush-phu-ban-cang-lao-vao-nhu-thieu-than-la-vi-ly-do-nay-day-20180308123837012.chn");
          },
          autoplay: true,
          autoplayDelay: 2000,
          pagination: new SwiperPagination(alignment: Alignment.bottomCenter),
          itemCount: imgList.length,
          itemBuilder: (context, index) {
            if (imgList[index] == null || imgList[index] == "")
              return Icon(
                MaterialIcons.broken_image,
                color: kPrimary.withOpacity(0.5),
              );

            return CachedNetworkImage(
              imageUrl: imgList[index],
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                MaterialIcons.broken_image,
                color: kPrimary.withOpacity(0.5),
              ),
            );
          }),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
