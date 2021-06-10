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
import 'package:unidelivery_mobile/ViewModel/index.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  OrderHistoryViewModel orderModel = Get.find<OrderHistoryViewModel>();
  final double HEIGHT = 48;
  final ValueNotifier<double> notifier = ValueNotifier(0);

  Future<void> _refresh() async {
    await Get.find<HomeViewModel>().getSuppliers();
    await orderModel.getNewOrder();
    await Get.find<HomeViewModel>().getNearlyGiftExchange();
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
                          child: Container(
                            color: kBackgroundGrey[2],
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (n) {
                                if (n.metrics.pixels <= HEIGHT) {
                                  notifier.value = n.metrics.pixels;
                                }
                                return false;
                              },
                              child: ListView(
                                children: [
                                  SizedBox(height: 8),
                                  banner(),
                                  // CATEGORY
                                  Section(child: HomeCategorySection()),
                                  // END CATEGORY
                                  SizedBox(height: 8),
                                  // GITF EXCHANGE
                                  Section(child: buildGiftCanExchangeSection()),
                                  // END GITF EXCHANGE
                                  SizedBox(height: 8),
                                  Section(child: HomeCollection()),
                                  SizedBox(height: 8),
                                  Container(child: HomeStoreSection()),
                                  SizedBox(height: 46),
                                ],
                              ),
                            ),
                          ),
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

  Widget buildGiftCanExchangeSection() {
    return ScopedModelDescendant<HomeViewModel>(
      builder: (context, child, model) {
        if (model.nearlyGift == null) return SizedBox.shrink();
        final accountModel = Get.find<AccountViewModel>();

        final gift = model.nearlyGift;
        final userBean = accountModel.currentUser.point;

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
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          canExchangeGift
                              ? "Đổi ngay 1 ${gift.name}"
                              : "Bạn sắp nhận được ${gift.name} rồi đấy",
                          style: kDescriptionTextStyle.copyWith(fontSize: 14),
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
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                        style: kDescriptionTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
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
    await Get.toNamed(RouteHandler.ORDER_HISTORY_DETAIL, arguments: order);
  }

  Widget buildNewOrder() {
    return ScopedModel<OrderHistoryViewModel>(
      model: orderModel,
      child: ScopedModelDescendant<OrderHistoryViewModel>(
          builder: (context, child, model) {
        if (model.status == ViewStatus.Loading || model.newTodayOrder == null) {
          return SizedBox();
        }
        final order = model.newTodayOrder;
        return Card(
          // width: Get.width,
          // color: Color(0xff9dd1ad),
          // padding: EdgeInsets.all(8),
          // height: 40,
          margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
          elevation: 3,
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  order.invoiceId,
                                  style: Get.theme.textTheme.headline3,
                                ),
                                SizedBox(height: 8),
                                Text('Đơn hàng mới',
                                    style: Get.theme.textTheme.headline6)
                              ],
                            ),
                            SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    order.address,
                                    style: Get.theme.textTheme.headline3,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Nhận đơn tại',
                                      style: Get.theme.textTheme.headline6)
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
                      orderModel.closeNewOrder();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget banner() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
      // padding: EdgeInsets.only(bottom: 8),
      child: ScopedModelDescendant<HomeViewModel>(
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
                    pagination:
                        new SwiperPagination(alignment: Alignment.bottomCenter),
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
    );
  }

  // TODO: Implement category section
  _launchURL(String url) async {}
}
