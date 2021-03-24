import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/SupplierDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/acessories/home_appbar.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';

import 'package:flutter/material.dart';

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    double appBarExtraHeight = 70;
    return Scaffold(
      backgroundColor: Colors.white,
      //bottomNavigationBar: bottomBar(),
      body: ScopedModel(
        model: HomeViewModel.getInstance(),
        child: Container(
          child: SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  //backgroundColor: Colors.blueGrey,
                  title: SABT(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bean Oi!!!',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text.rich(TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          children: <InlineSpan>[
                            TextSpan(text: 'Giao đơn cho'),
                            WidgetSpan(child: FieldTag(content: 'Hung Bui')),
                            TextSpan(text: ' tại '),
                            WidgetSpan(child: FieldTag(content: 'DH FPT')),
                            TextSpan(text: ' vào lúc '),
                            WidgetSpan(child: FieldTag(content: '12h30')),
                            TextSpan(text: ' ở '),
                            WidgetSpan(child: FieldTag(content: 'Khu cờ vua')),
                            TextSpan(text: ' nhé..'),
                          ],
                        )),
                      ],
                    ),
                  ),
                  // Allows the user to reveal the app bar if they begin scrolling back
                  // up the list of items.
                  pinned: true,
                  floating: false,

                  // Display a placeholder widget to visualize the shrinking size.
                  expandedHeight: Get.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      margin: EdgeInsets.only(
                        top: 25,
                      ),
                      color: Colors.white,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          Container(
                            height: Get.height * 0.2,
                            width: Get.width,
                            color: kPrimary,
                          ),
                          Container(
                            width: Get.width - 20,
                            height: 100,
                            padding: EdgeInsets.all(8),
                            // margin: EdgeInsets.only(bottom: 150),
                            color: kPrimary,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bean Oi!!!',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text.rich(TextSpan(
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                  children: <InlineSpan>[
                                    TextSpan(text: 'Giao đơn cho'),
                                    WidgetSpan(
                                        child: FieldTag(content: 'Hung Bui')),
                                    TextSpan(text: ' tại '),
                                    WidgetSpan(
                                        child: FieldTag(content: 'DH FPT')),
                                    TextSpan(text: ' vào lúc '),
                                    WidgetSpan(
                                        child:
                                            FieldTag(content: '12h30 Hôm nay')),
                                    TextSpan(text: ' ở '),
                                    WidgetSpan(
                                        child:
                                            FieldTag(content: 'Khu cowf vua')),
                                    TextSpan(text: ' nhé..'),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 100,
                            child: banner(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Make the initial height of the SliverAppBar larger than normal.
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                  <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height * 0),
                        child: RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _refresh,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Stack(
                              //   overflow: Overflow.visible,
                              //   children: [
                              //     Container(height: 150, width: Get.width),
                              //   ],
                              // ),
                              // (),
                              // timeRecieve(),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 16, 0),
                                child: Text('Danh sánh nhà hàng',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[850])),
                              ),
                              storeList(),
                              storeList(),
                              storeList(),
                              // stor

                              //loadMoreButton(),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell _location() {
    return InkWell(
      onTap: () async {
        // await root.processChangeLocation();
        print('Tap');
      },
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Colors.red[400],
            size: 30,
          ),
          SizedBox(
            width: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "KHU VỰC",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'Unibean',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
            return Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: InkWell(
                onTap: () async {
                  if (model.currentStore.selectedTimeSlot != null) {
                    await showTimeDialog(model);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Khung giờ: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.yellow),
                          children: [
                            TextSpan(
                                text: model.currentStore.selectedTimeSlot !=
                                        null
                                    ? "${model.currentStore.selectedTimeSlot.from.substring(0, 5)} - ${model.currentStore.selectedTimeSlot.to.substring(0, 5)}"
                                    : "Hôm nay Bean tạm nghỉ 😓",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))
                          ]),
                    ),
                    model.currentStore.selectedTimeSlot != null
                        ? model.currentStore.selectedTimeSlot.available
                            ? Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 24,
                              )
                            : Text(
                                "Hết giờ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              )
                        : SizedBox.shrink()
                    //Text("Thay đổi", style: TextStyle(color: Colors.grey[200]),)
                  ],
                ),
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
                color: Colors.black45,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
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
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () async {
                      await model.selectSupplier(model.suppliers[index]);
                    },
                    child: buildSupplier(model.suppliers[index]));
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.suppliers.length,
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
    return Row(
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
                        (context, url, downloadProgress) => Shimmer.fromColors(
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
          style: TextStyle(color: dto.available ? Colors.black : Colors.grey),
        )
      ],
    );
  }

  Widget banner() {
    return Container(
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
                //padding: EdgeInsets.only(top: 8, bottom: 8),
                height: (Get.width) * (747 / 1914),
                width: (Get.width),
                child: Swiper(
                    onTap: (index) async {},
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
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              //borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: Offset(
                                      0,
                                      3,
                                    ) // changes position of shadow
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

class FieldTag extends StatelessWidget {
  final String content;

  const FieldTag({
    Key key,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(0),
        width: 100.0,
        height: 30,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 5) // changes position of shadow
                ),
          ],
        ),
        child: Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: kPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
