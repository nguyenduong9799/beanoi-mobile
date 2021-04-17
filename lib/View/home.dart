import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/SupplierDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/fixed_app_bar.dart';
import 'package:unidelivery_mobile/acessories/shimmer_block.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    await HomeViewModel.getInstance().getSuppliers();
  }

  bool isDarkModeOn =
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white));
    //
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
            model: HomeViewModel.getInstance(),
            child: Column(
              children: [
                FixedAppBar(),
                Expanded(
                  child: Container(
                    color: kBackgroundGrey[2],
                    padding: EdgeInsets.only(top: 0),
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: Container(
                        // height: Get.height * 0.8 - 16,
                        color: kBackgroundGrey[2],
                        child: ListView(
                          children: [
                            SizedBox(height: 8),
                            banner(),
                            Container(child: storeList()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _suggestRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: "Gợi ý nhà hàng bạn thích cho chúng mình ",
            style: kDescriptionTextSyle.copyWith(
              fontSize: 12,
            ),
            children: [
              WidgetSpan(
                child: ScopedModel<AccountViewModel>(
                  model: AccountViewModel.getInstance(),
                  child: ScopedModelDescendant<AccountViewModel>(
                      builder: (context, child, model) {
                    return InkWell(
                      onTap: () async {
                        await model.sendFeedback(
                            "Nhập nhà hàng mà bạn muốn chúng mình phục vụ nhé");
                      },
                      child: Text(
                        "tại đây",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              TextSpan(text: " 📝 nha."),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget storeList() {
    return ScopedModelDescendant<HomeViewModel>(
      builder: (context, child, model) {
        ViewStatus status = model.status;
        bool isMenuAvailable =
            RootViewModel.getInstance().isCurrentMenuAvailable;
        switch (status) {
          case ViewStatus.Error:
            return Column(
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ShimmerBlock(width: Get.width * 0.4, height: 40),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                ],
              ),
            );
          default:
            if (model.suppliers == null ||
                model.suppliers.isEmpty ||
                model.suppliers
                        .where((supplier) => supplier.available)
                        .length ==
                    0) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                      "Aaa, hiện tại các nhà hàng đang bận, bạn vui lòng quay lại sau nhé",
                      textAlign: TextAlign.center,
                      style:
                          kSubtitleTextSyule.copyWith(color: Colors.orange),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16.0, 8, 16),
                  child:
                      Text('🌟 Danh sách nhà hàng 🌟', style: kTitleTextStyle),
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isMenuAvailable ? Colors.transparent : Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Column(
                    children: [
                      ...model.suppliers
                          .where((supplier) => supplier.available)
                          .map((supplier) => InkWell(
                              onTap: () {
                                model.selectSupplier(supplier);
                              },
                              child: buildSupplier(supplier)))
                          .toList(),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                _suggestRestaurant(),
                SizedBox(height: 8),
              ],
            );
        }
      },
    );
  }

  Widget loadMoreButton() {
    return ScopedModelDescendant<RootViewModel>(
      builder: (context, child, model) {
        switch (model.status) {
          case ViewStatus.LoadMore:
            return CircularProgressIndicator();
          default:
            return SizedBox.shrink();
        }
      },
    );
  }

  Widget buildSupplier(SupplierDTO dto, [bool loading = false]) {
    if (loading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShimmerBlock(
            height: 50,
            width: 50,
            borderRadius: 16,
          ),
          SizedBox(width: 8),
          ShimmerBlock(height: 50, width: Get.width - 80),
        ],
      );
    }
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                            borderRadius: BorderRadius.circular(16),
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
            Text(
              dto.name,
              style:
                  TextStyle(color: dto.available ? Colors.black : Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget banner() {
    return Container(
      margin: EdgeInsets.only(top: 8),
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
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 8, right: 8, bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(
                                        0, 3) // changes position of shadow
                                    ),
                              ],
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

  _launchURL(String url) async {}
}
