import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/SupplierDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/acessories/fixed_app_bar.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: Get.height,
        child: ScopedModel(
          model: HomeViewModel.getInstance(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FixedAppBar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: Container(
                        // height: Get.height * 0.8 - 16,
                        color: kBackgroundGrey[2],
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: 8),
                            banner(),
                            // location(),
                            // timeRecieve(),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Danh sách nhà hàng',
                                  style: kTitleTextStyle),
                            ),
                            Container(child: storeList()),
                            // Container(child: storeList()),
                            // SizedBox(height: 16),
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

  Widget location() {
    return ScopedModel(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, root) {
          String text = "Đợi tý đang load...";
          if (root.changeAddress) {
            text = "Đang thay đổi...";
          } else {
            if (root.currentStore != null) {
              text = "${root.currentStore.name}";
            }
          }

          if (root.status == ViewStatus.Error) {
            text = "Có lỗi xảy ra...";
          }

          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: Get.width * 0.75,
                        child: Text(
                          text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: kPrimary),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.orange,
                    size: 24,
                  ),
                ],
              ),
            ),
            onTap: () async {
              await root.processChangeLocation();
            },
          );
        },
      ),
    );
  }

  Widget timeRecieve() {
    return ScopedModel(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
          if (model.currentStore != null) {
            return InkWell(
              onTap: () async {
                if (model.currentStore.selectedTimeSlot != null) {
                  await showTimeDialog(model);
                }
              },
              child: Column(
                children: [
                  Container(
                      height: 30,
                      width: Get.width,
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          Text(
                            "Nhận đơn lúc",
                            style:
                                TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                width: 4,
                              ),
                              itemBuilder: (context, index) {
                                DateTime arrive = DateFormat("HH:mm:ss").parse(
                                    model.currentStore.timeSlots[0].arrive);
                                return Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: kPrimary)),
                                  child: Text(
                                    "${DateFormat("HH:mm").format(arrive)} - ${DateFormat("HH:mm").format(arrive.add(Duration(minutes: 30)))}",
                                    style: TextStyle(
                                        color: kPrimary, fontSize: 12),
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      width: Get.width,
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          Text(
                            "Khung giờ",
                            style:
                                TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "${model.currentStore.selectedTimeSlot.from.substring(0, 5)} - ${model.currentStore.selectedTimeSlot.to.substring(0, 5)}",
                            style: TextStyle(color: kPrimary, fontSize: 12),
                          ),
                        ],
                      )),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget storeList() {
    return ScopedModelDescendant<HomeViewModel>(
      builder: (context, child, model) {
        ViewStatus status = model.status;
        print(model.suppliers);
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
          default:
            if (model.suppliers == null || model.suppliers.isEmpty) {
              return Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                        "Aaa, hiện tại chưa có nhà hàng nào, bạn vui lòng quay lại sau nhé",
                        textAlign: TextAlign.center,
                        style:
                            kSubtitleTextSyule.copyWith(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: model.suppliers
                  .where((supplier) => supplier.available)
                  .map((supplier) => InkWell(
                      onTap: () {
                        model.selectSupplier(supplier);
                      },
                      child: buildSupplier(supplier)))
                  .toList(),
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

  Widget buildSupplier(SupplierDTO dto) {
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
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: ScopedModelDescendant<HomeViewModel>(
        builder: (context, child, model) {
          ViewStatus status = model.status;
          switch (status) {
            case ViewStatus.Loading:
              return Shimmer.fromColors(
                baseColor: kBackgroundGrey[0],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Container(
                  height: Get.width * (747 / 1914),
                  width: Get.width,
                  color: Colors.grey,
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
                // padding: EdgeInsets.only(top: 8, bottom: 8),
                // padding: EdgeInsets.only(top: 8, bottom: 16),
                height: (Get.width) * (747 / 1914),
                width: (Get.width),
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
                            margin: EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                              //borderRadius: BorderRadius.circular(8),
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
