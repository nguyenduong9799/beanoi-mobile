import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/MenuDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'index.dart';

class FixedAppBar extends StatefulWidget {
  final double height;
  final ValueNotifier<double> notifier;
  FixedAppBar({Key key, this.height, this.notifier}) : super(key: key);

  @override
  _FixedAppBarState createState() => _FixedAppBarState();
}

class _FixedAppBarState extends State<FixedAppBar> {
  int timeSection = 1;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    return AnimatedContainer(
      width: Get.width,
      // height: Get.height * 0.15,
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              // blurRadius: 6,
              offset: Offset(0, 25) // changes position of shadow
              ),
        ],
        color: Colors.white,
      ),
      child: ScopedModel(
        model: Get.find<RootViewModel>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: _buildTopHeader(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: timeRecieve(),
            ),
            // _buildTimeAlert(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return ScopedModelDescendant<RootViewModel>(
      builder: (context, child, root) {
        final status = root.status;
        if (status == ViewStatus.Loading) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    location(true),
                    // _buildTimeSection(true),
                  ],
                ),
              ),
              SizedBox(width: 8),
              ShimmerBlock(
                width: 32,
                height: 32,
                borderRadius: 16,
              ),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  location(),
                  // _buildTimeSection(),
                ],
              ),
            ),
            SizedBox(width: 16),
            Container(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                      padding: EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/images/history.png',
                        width: 24,
                      )),
                  onTap: () {
                    Get.toNamed(RouteHandler.ORDER_HISTORY);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget _buildTimeSection([bool loading = false]) {
  //   if (loading) {
  //     return Container(
  //       width: Get.width,
  //       height: 48,
  //       padding: const EdgeInsets.only(top: 8, bottom: 16),
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemBuilder: (BuildContext context, int index) {
  //           return Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: ShimmerBlock(width: 96, height: 48, borderRadius: 16),
  //           );
  //         },
  //         itemCount: 3,
  //       ),
  //     );
  //   }
  //
  //   return Container(
  //     width: Get.width,
  //     height: 48,
  //     padding: const EdgeInsets.only(top: 8, bottom: 16),
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: [
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               timeSection = 1;
  //             });
  //           },
  //           child: Material(
  //             color: Colors.transparent,
  //             child: Container(
  //               padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(16),
  //                 color: timeSection == 1 ? kPrimary : Colors.transparent,
  //               ),
  //               child: Text(
  //                 'Sáng 🌄',
  //                 style: TextStyle(
  //                   color:
  //                       timeSection == 1 ? Colors.white : kDescriptionTextColor,
  //                   fontWeight:
  //                       timeSection == 1 ? FontWeight.w800 : FontWeight.w100,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               timeSection = 2;
  //             });
  //           },
  //           child: Ink(
  //             color: kPrimary,
  //             child: Container(
  //               padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(16),
  //                 color: timeSection == 2 ? kPrimary : Colors.transparent,
  //               ),
  //               child: Text(
  //                 'Trưa 🌤',
  //                 style: kDescriptionTextSyle.copyWith(
  //                   fontWeight:
  //                       timeSection == 1 ? FontWeight.w800 : FontWeight.w100,
  //                   color:
  //                       timeSection == 2 ? Colors.white : kDescriptionTextColor,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               timeSection = 3;
  //             });
  //           },
  //           child: Container(
  //             padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(16),
  //               color: timeSection == 3 ? kPrimary : Colors.transparent,
  //             ),
  //             child: Text(
  //               'Chiều 🌇',
  //               style: kDescriptionTextSyle.copyWith(
  //                 fontWeight:
  //                     timeSection == 1 ? FontWeight.w800 : FontWeight.w100,
  //                 color:
  //                     timeSection == 3 ? Colors.white : kDescriptionTextColor,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget timeRecieve() {
    return ScopedModelDescendant<RootViewModel>(
      builder: (context, child, model) {
        if (model.currentStore != null) {
          final status = model.status;

          if (status == ViewStatus.Loading) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     ShimmerBlock(width: 150, height: 28),
                //   ],
                // ),
                Container(
                  height: 32,
                  width: Get.width,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ShimmerBlock(
                          width: 80,
                          height: 32,
                          borderRadius: 8,
                        ),
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                  ),
                ),
                SizedBox(height: 8),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text.rich(
              //       TextSpan(
              //         text: "Khung giờ đặt đơn",
              //         style: Get.theme.textTheme.headline5,
              //         children: [
              //           // WidgetSpan(
              //           //   child: MyTooltip(
              //           //     message:
              //           //         "Thời gian bạn muốn nhận đơn của mình. Lưu ý thời gian chốt đơn thường sớm hơn 1 tiếng",
              //           //     child: Icon(Icons.info_outline, size: 16),
              //           //     height: 48,
              //           //   ),
              //           // ),
              //         ],
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ],
              // ),
              // SizedBox(height: 8),
              Container(
                  alignment: Alignment.center,
                  height: 32,
                  width: Get.width,
                  child: ListView.builder(
                    // separatorBuilder: (context, index) => SizedBox(
                    //   width: 4,
                    // ),
                    itemBuilder: (context, index) {
                      // DateTime timeFromTo = DateFormat("HH:mm:ss").parse(
                      //     model.listMenu[index].timeSlots[index].arriveFrom);
                      // DateTime arriveFrom = timeFromTo;
                      // DateTime arrive = DateFormat("HH:mm:ss")
                      //     .parse(model.currentStore.timeSlots[index].arrive);
                      // DateTime arriveRangeFrom = arrive;
                      // DateTime arriveRangeTo =
                      //     arrive.add(Duration(minutes: 30));
                      // if (model.currentStore.timeSlots[index].arriveRange
                      //         .length ==
                      //     2) {
                      //   arriveRangeFrom = DateFormat("HH:mm:ss").parse(
                      //       model.currentStore.timeSlots[index].arriveRange[0]);
                      //   arriveRangeTo = DateFormat("HH:mm:ss").parse(
                      //       model.currentStore.timeSlots[index].arriveRange[1]);
                      // }

                      bool isSelect = model.selectedMenu.menuId ==
                          model.listMenu[index].menuId;
                      return AnimatedContainer(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(isSelect ? 8 : 0),
                          color: isSelect ? kPrimary : Colors.transparent,
                        ),
                        duration: Duration(milliseconds: 300),
                        child: InkWell(
                          onTap: () async {
                            if (model.selectedMenu != null) {
                              model.confirmMenu(model.listMenu[index]);
                            }
                          },
                          child: Center(
                            child: Text(model.listMenu[index].menuName,
                                style: isSelect
                                    ? Get.theme.textTheme.headline4
                                        .copyWith(color: Colors.white)
                                    : Get.theme.textTheme.headline4),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: model.listMenu.length,
                  )),
              SizedBox(height: 8),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget location([bool loading = false]) {
    return ScopedModelDescendant<RootViewModel>(
      builder: (context, child, root) {
        LocationDTO location = root.currentStore?.locations?.firstWhere(
          (element) => element.isSelected,
          orElse: () => null,
        );
        DestinationDTO destinationDTO = location?.destinations
            ?.firstWhere((element) => element.isSelected, orElse: () => null);
        String text = "Đợi tý đang load...";
        final status = root.status;
        if (root.changeAddress) {
          text = "Đang thay đổi...";
        } else if (location != null) {
          text = destinationDTO.name + " - " + location.address;
        } else {
          text = "Chưa chọn";
        }

        if (status == ViewStatus.Error) {
          text = "Có lỗi xảy ra...";
        }

        if (loading) {
          return Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  ShimmerBlock(width: 64, height: 24),
                  SizedBox(width: 8),
                  ShimmerBlock(width: 150, height: 24),
                ],
              ),
            ],
          );
        }

        return InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.orange[400], size: 20),
                ],
              ),
              // Text(
              //   "📌 Nơi nhận: ",
              //   style:
              //       Get.theme.textTheme.headline6.copyWith(color: Colors.black),
              // ),
              Flexible(
                child: Text(
                  text,
                  style: Get.theme.textTheme.headline4,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: kPrimary,
              )
            ],
          ),
          onTap: () async {
            await root.processChangeLocation();
          },
        );
      },
    );
  }

  Widget _buildTimeAlert() {
    return ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
      MenuDTO currentMenu = model.selectedMenu;
      final currentDate = DateTime.now();
      final status = model.status;
      if (status == ViewStatus.Loading) {
        return Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          // margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
          width: Get.width,
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBlock(width: Get.width * 0.6, height: 24),
              ShimmerBlock(width: Get.width * 0.2, height: 24),
            ],
          ),
        );
      }
      if (currentMenu == null) {
        return SizedBox();
      }
      String currentTimeSlot = currentMenu.timeFromTo[1];
      var beanTime = new DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        double.parse(currentTimeSlot.split(':')[0]).round(),
        double.parse(currentTimeSlot.split(':')[1]).round(),
      );

      int differentTime = beanTime.difference(currentDate).inMilliseconds;

      // MenuDTO nextMenu = model.listMenu
      //     ?.firstWhere((item) => item.isAvailable, orElse: () => null);

      DateTime arrive = DateFormat("HH:mm:ss").parse(currentMenu.timeFromTo[1]);
      return ValueListenableBuilder<double>(
        valueListenable: this.widget.notifier,
        builder: (context, value, child) {
          // print("value: ${1 - (value) / this.widget.height}");
          return Opacity(
            // opacity: 1 - (value) / this.widget.height <= 0
            //     ? 0
            //     : 1 - (value) / this.widget.height,
            opacity: 1,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              // margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
              width: Get.width,
              height: 48,
              child: Align(
                alignment: Alignment.centerLeft,
                child: model.isCurrentMenuAvailable()
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text.rich(
                              TextSpan(
                                text: "Kết thúc : ",
                                style: Get.theme.textTheme.headline5,
                                children: [
                                  TextSpan(
                                    text: "$currentTimeSlot",
                                    style: kTitleTextStyle.copyWith(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            BeanTimeCountdown(
                              differentTime: differentTime,
                              arriveTime: arrive,
                            ),
                          ])
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            // width: Get.width * 0.7,
                            child: Text(
                                "Khung giờ hiện tại đã đóng, bạn vui lòng xem khung giờ kế tiếp nha 😉.",
                                style: kTitleTextStyle.copyWith(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100,
                                ),
                                textAlign: TextAlign.left),
                          ),
                          SizedBox(width: 8),
                          // nextMenu != null
                          //     ? InkWell(
                          //         onTap: () {
                          //           if (model.selectedMenu != null) {
                          //             model.confirmMenu(nextMenu);
                          //           }
                          //         },
                          //         child: Text(
                          //           "Xem ngay",
                          //           style: TextStyle(
                          //               color: kPrimary, fontSize: 12),
                          //         ),
                          //       )
                          //     : SizedBox(),
                        ],
                      ),
              ),
              decoration: BoxDecoration(
                color: Color(0xfffffbe6),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Color(0xffffe58f),
                  width: 1.0,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class BeanTimeCountdown extends StatefulWidget {
  const BeanTimeCountdown({
    Key key,
    @required this.differentTime,
    @required this.arriveTime,
  }) : super(key: key);

  final int differentTime;
  final DateTime arriveTime;

  @override
  _BeanTimeCountdownState createState() => _BeanTimeCountdownState();
}

class _BeanTimeCountdownState extends State<BeanTimeCountdown> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RootViewModel>(
        rebuildOnChange: false,
        builder: (context, child, model) {
          if (widget.differentTime <= 0) {
            return Text(
              "Hết giờ",
              style: Get.theme.textTheme.headline6.copyWith(color: Colors.red),
            );
          }
          return CountdownTimer(
            endTime:
                DateTime.now().millisecondsSinceEpoch + widget.differentTime,
            onEnd: () async {
              await showStatusDialog(
                "assets/images/global_error.png",
                "Khung giờ đã kết thúc",
                "Đã hết giờ chốt đơn cho khung giờ hiện tại. \n Hẹn gặp bạn ở khung giờ khác nhé 😢.",
              );
              // remove cart
              await model.clearCart();
              await model.fetchStore();
            },
            widgetBuilder: (_, CurrentRemainingTime time) {
              if (time == null) {
                return Text(
                  'Hết giờ',
                  style:
                      Get.theme.textTheme.headline6.copyWith(color: Colors.red),
                );
              }
              return Row(
                children: [
                  buildTimeBlock(
                      "${(time.hours ?? 0) < 10 ? "0" : ""}${time.hours ?? "0"}"),
                  Text(
                    ":",
                    style: Get.theme.textTheme.headline6
                        .copyWith(color: Colors.black),
                  ),
                  buildTimeBlock(
                      "${(time.min ?? 0) < 10 ? "0" : ""}${time.min ?? "0"}"),
                  Text(
                    ":",
                    style: Get.theme.textTheme.headline6
                        .copyWith(color: Colors.black),
                  ),
                  buildTimeBlock(
                      "${(time.sec ?? 0) < 10 ? "0" : ""}${time.sec ?? "0"}"),
                ],
              );
            },
          );
        });
  }

  Widget buildTimeBlock(String text) {
    return Container(
        width: 27,
        height: 27,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Color(0xFFF2994A)),
        padding: EdgeInsets.all(4),
        child: Center(
          child: Text(
            text,
            style: Get.theme.textTheme.headline6.copyWith(
              color: Colors.white,
            ),
          ),
        ));
  }
}
