import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Accessories/Home/HomeCategorySection.dart';
import 'package:unidelivery_mobile/Accessories/Home/HomeCollection.dart';
import 'package:unidelivery_mobile/Accessories/Home/HomeStoreSection.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/section.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/collection_viewmodel.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
// import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  OrderHistoryViewModel orderModel = Get.find<OrderHistoryViewModel>();
  BlogsViewModel blogsModel = BlogsViewModel();
  final double HEIGHT = 48;
  final ValueNotifier<double> notifier = ValueNotifier(0);
  final PageController controller = PageController();
  Future<void> _refresh() async {
    await Get.find<RootViewModel>().fetchStore();
    await Get.find<HomeViewModel>().getSuppliers();
    // await Get.find<HomeViewModel>().getNearlyGiftExchange();
    await blogsModel.getBlogs();
    await Get.find<HomeViewModel>().getCollections();
    orderModel.getNewOrder();
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  bool isDarkModeOn =
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //     statusBarColor: Colors.white, // Color for Android
    //     statusBarBrightness:
    //         Brightness.dark // Dark == white status bar -- for IOS.
    //     ));
    return Scaffold(
      backgroundColor: kBackgroundGrey[2],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: Get.height,
          child: ScopedModel(
            model: Get.find<HomeViewModel>(),
            child: Stack(
              children: [
                Column(
                  children: [
                    FixedAppBar(
                      notifier: notifier,
                      height: HEIGHT,
                    ),
                    Expanded(
                      child: Container(
                        color: kBackgroundGrey[2],
                        padding: EdgeInsets.only(top: 0),
                        child: RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _refresh,
                          child: ScopedModelDescendant<HomeViewModel>(
                              builder: (context, child, model) {
                            if (model.status == ViewStatus.Error) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "BeanOi đã cố gắng hết sức ..\nNhưng vẫn bị con quỷ Bug đánh bại.",
                                      textAlign: TextAlign.center,
                                      style: Get.theme.textTheme.headline3,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: 300,
                                    height: 300,
                                    child: Image.asset(
                                      'assets/images/global_error.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Center(
                                    child: Text(
                                      "Bạn vui lòng thử một số cách sau nhé!",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Center(
                                    child: Text(
                                      "1. Tắt ứng dụng và mở lại",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Center(
                                    child: InkWell(
                                      child: Text(
                                        "2. Đặt hàng qua Fanpage ",
                                        textAlign: TextAlign.center,
                                      ),
                                      // onTap: () =>
                                      //     launch('fb://page/103238875095890'),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                color: kBackgroundGrey[2],
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (n) {
                                    if (n.metrics.pixels <= HEIGHT) {
                                      notifier.value = n.metrics.pixels;
                                    }
                                    return false;
                                  },
                                  child: SingleChildScrollView(
                                    child: Column(
                                      // addAutomaticKeepAlives: true,
                                      children: [
                                        SizedBox(height: 8),
                                        ...renderHomeSections().toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: buildNewOrder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> renderHomeSections() {
    return [
      banner(),
      // buildLinkBtns(),
      Section(child: HomeCategorySection()),
      SizedBox(height: 16),
      // Section(child: buildGiftCanExchangeSection()),
      HomeCollection(),
      SizedBox(height: 8),
      Container(child: HomeStoreSection()),
      SizedBox(height: 46)
    ];
  }

  Widget buildLinkBtns() {
    return ScopedModel(
      model: Get.find<RootViewModel>(),
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
          return Container(
            color: Colors.white,
            width: Get.width,
            padding: EdgeInsets.all(8),
            height: 72,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TouchOpacity(
                  onTap: () {
                    Get.toNamed(RouteHandler.BEAN_MART);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFF5F5F5),
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFF5F5F5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(
                                0,
                                0,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              ClipOval(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CacheImage(
                                    imageUrl:
                                        "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/mart.png?alt=media&token=44198698-8bd1-4493-84fa-78e1877e5f1f",
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "BEAN MART",
                                style: Get.theme.textTheme.headline3
                                    .copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // COUNTER MART
                      Positioned(
                        right: -6,
                        top: -6,
                        child: FutureBuilder(
                          future: model.mart,
                          builder: (context, snapshot) {
                            Cart cart = snapshot.data;
                            if (cart == null) return SizedBox.shrink();
                            return ClipOval(
                              child: Container(
                                  width: 24,
                                  height: 24,
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      "${cart.itemQuantity()}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildGiftCanExchangeSection() {
    return ScopedModelDescendant<HomeViewModel>(
      builder: (context, child, model) {
        if (model.nearlyGift == null) return SizedBox.shrink();
        final accountModel = Get.find<AccountViewModel>();

        final gift = model.nearlyGift;
        final userBean = accountModel.currentUser.point ?? 0;

        final canExchangeGift = userBean > gift.price;

        return TouchOpacity(
          onTap: () async {
            final rootModel = Get.find<RootViewModel>();
            await rootModel.openProductDetail(gift);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                child: Text(
                  "BEAN ĐÃ LỚN 🎁",
                  style: kTitleTextStyle,
                ),
              ),
              SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          canExchangeGift
                              ? "Đổi ngay 1 ${gift.name}"
                              : "Bạn sắp nhận được ${gift.name} rồi đấy",
                          style: Get.theme.textTheme.headline3
                              .copyWith(color: kDescriptionTextColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),
                          width: Get.width,
                          height: 16,
                          decoration: BoxDecoration(
                            color: kBackgroundGrey[2],
                            borderRadius: BorderRadius.circular((8)),
                          ),
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              FractionallySizedBox(
                                widthFactor: userBean / gift.price > 1
                                    ? 1
                                    : userBean / gift.price,
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 2),
                                  decoration: BoxDecoration(
                                    color: kPrimary,
                                    borderRadius: BorderRadius.circular((8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
                            child: canExchangeGift
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Đổi ngay",
                                      style: TextStyle(
                                        color: kPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                        text: "",
                                        style: Get.theme.textTheme.headline3
                                            .copyWith(
                                                color: kDescriptionTextColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "${userBean.ceil()}",
                                            style: TextStyle(
                                              color: kPrimary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "/${gift.price.ceil()}",
                                          ),
                                        ]),
                                  ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: 50,
                          height: 75,
                          // fit: BoxFit.fitWidth,
                          child: CacheImage(
                            imageUrl: gift.imageURL,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTapOrderHistory(order) async {
    // get orderDetail
    await Get.find<OrderHistoryViewModel>().getOrders();
    await Get.toNamed(RouteHandler.ORDER_HISTORY_DETAIL, arguments: order);
  }

  Widget buildNewOrder() {
    return ScopedModel<OrderHistoryViewModel>(
      model: orderModel,
      child: ScopedModelDescendant<OrderHistoryViewModel>(
          builder: (context, child, model) {
        if (model.status == ViewStatus.Loading ||
            model.newTodayOrders == null) {
          return SizedBox();
        }
        return Container(
          width: Get.width,
          height: 80,
          child: PageView(
            children: model.newTodayOrders
                .map((order) => Card(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                      elevation: 3,
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(color: kPrimary, width: 3))),
                        width: Get.width * 0.95,
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    _onTapOrderHistory(order);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              order.invoiceId,
                                              style:
                                                  Get.theme.textTheme.headline3,
                                            ),
                                            SizedBox(height: 8),
                                            Text('Đơn hàng mới',
                                                style: Get
                                                    .theme.textTheme.headline6)
                                          ],
                                        ),
                                        SizedBox(width: 24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                order.address,
                                                style: Get
                                                    .theme.textTheme.headline3,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Text('Nhận đơn tại',
                                                  style: Get.theme.textTheme
                                                      .headline6)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  orderModel.closeNewOrder(order.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
            scrollDirection: Axis.horizontal,
            controller: controller,
          ),
        );
      }),
    );
  }

  Widget banner() {
    return ScopedModel<BlogsViewModel>(
        model: blogsModel,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
          // padding: EdgeInsets.only(bottom: 8),
          child: ScopedModelDescendant<BlogsViewModel>(
            builder: (context, child, model) {
              ViewStatus status = model.status;
              switch (status) {
                case ViewStatus.Loading:
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerBlock(
                      height: (Get.width) * (747 / 1914),
                      width: (Get.width),
                    ),
                  );
                case ViewStatus.Empty:
                case ViewStatus.Error:
                  return SizedBox.shrink();
                default:
                  if (model.blogs == null || model.blogs.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return Container(
                    height: (Get.width) * (747 / 1914),
                    width: (Get.width),
                    margin: EdgeInsets.only(bottom: 8),
                    child: Swiper(
                        onTap: (index) async {
                          await _launchURL(
                              "https://www.youtube.com/embed/wu32Wj_Uix4");
                        },
                        autoplay: model.blogs.length > 1 ? true : false,
                        autoplayDelay: 5000,
                        viewportFraction: 0.9,
                        pagination: new SwiperPagination(
                            alignment: Alignment.bottomCenter),
                        itemCount: model.blogs.length,
                        itemBuilder: (context, index) {
                          if (model.blogs[index].imageUrl == null ||
                              model.blogs[index].imageUrl == "")
                            return Icon(
                              MaterialIcons.broken_image,
                              color: kPrimary.withOpacity(0.5),
                            );

                          return CachedNetworkImage(
                            imageUrl: model.blogs[index].imageUrl,
                            imageBuilder: (context, imageProvider) => InkWell(
                              onTap: () {
                                Get.toNamed(RouteHandler.BANNER_DETAIL,
                                    arguments: model.blogs[index]);
                              },
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
            },
          ),
        ));
  }

  // TODO: Implement category section
  _launchURL(String url) async {}
}
