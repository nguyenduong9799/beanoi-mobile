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
    return Scaffold(
      backgroundColor: Colors.white,
      //bottomNavigationBar: bottomBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.12),
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: Column(
                    children: [
                      banner(),
                      location(),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(child: storeList()),
                      //loadMoreButton(),
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
    );
  }

  Widget location() {
    return ScopedModelDescendant<RootViewModel>(
      builder: (context, child, root) {
        String text = "Đợi tý đang load...";
        if (root.changeAddress) {
          text = "Đang thay đổi...";
        } else {
          if (root.currentStore != null) {
            text = "${root.currentStore.name} - ${root.currentStore.location}";
          }
        }

        if (root.status == ViewStatus.Error) {
          text = "Có lỗi xảy ra...";
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
    );
  }

  Widget buildCountDown() {
    return ScopedModelDescendant<RootViewModel>(
      builder: (context, child, model) {
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
                    model.endOrderTime ? "Hết giờ" : "Còn lại",
                    style: kTextPrimary.copyWith(fontWeight: FontWeight.bold),
                  ),
                  CountdownTimer(
                    emptyWidget: Container(),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    endTime: model.orderTime.millisecondsSinceEpoch,
                    onEnd: () {
                      model.endOrderTime = true;
                      model.notifyListeners();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
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
              physics: AlwaysScrollableScrollPhysics(),
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

  Widget buildStore(StoreDTO dto) {
    return InkWell(
      onTap: () async {
        await Get.toNamed(RouteHandler.HOME_DETAIL, arguments: dto);
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

  Widget banner() {
    return Container(
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
          ViewStatus status = model.status;
          switch (status) {
            case ViewStatus.Loading:
              return Shimmer.fromColors(
                baseColor: kBackgroundGrey[0],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Container(
                  height: Get.height * 0.2,
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
                //padding: EdgeInsets.only(top: 8, bottom: 8),
                height: Get.height * 0.2,
                width: Get.width,
                child: Swiper(
                    onTap: (index) async {
                      await _launchURL(
                          "https://www.youtube.com/embed/wu32Wj_Uix4");
                    },
                    autoplay: model.blogs.length > 1 ? true : false,
                    autoplayDelay: 2000,
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
                        imageBuilder: (context, imageProvider) => Container(
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
