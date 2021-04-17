import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/CampusDTO.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/acessories/my_tooltip.dart';
import 'package:unidelivery_mobile/acessories/shimmer_block.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../route_constraint.dart';

class FixedAppBar extends StatefulWidget {
  FixedAppBar({Key key}) : super(key: key);

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
          _buildTimeAlert(),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return ScopedModel(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
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
      ),
    );
  }

  Widget _buildTimeSection([bool loading = false]) {
    if (loading) {
      return Container(
        width: Get.width,
        height: 48,
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerBlock(width: 96, height: 48, borderRadius: 16),
            );
          },
          itemCount: 3,
        ),
      );
    }

    return Container(
      width: Get.width,
      height: 48,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                timeSection = 1;
              });
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: timeSection == 1 ? kPrimary : Colors.transparent,
                ),
                child: Text(
                  'Sáng 🌄',
                  style: TextStyle(
                    color:
                        timeSection == 1 ? Colors.white : kDescriptionTextColor,
                    fontWeight:
                        timeSection == 1 ? FontWeight.w800 : FontWeight.w100,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                timeSection = 2;
              });
            },
            child: Ink(
              color: kPrimary,
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: timeSection == 2 ? kPrimary : Colors.transparent,
                ),
                child: Text(
                  'Trưa 🌤',
                  style: kDescriptionTextSyle.copyWith(
                    fontWeight:
                        timeSection == 1 ? FontWeight.w800 : FontWeight.w100,
                    color:
                        timeSection == 2 ? Colors.white : kDescriptionTextColor,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                timeSection = 3;
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: timeSection == 3 ? kPrimary : Colors.transparent,
              ),
              child: Text(
                'Chiều 🌇',
                style: kDescriptionTextSyle.copyWith(
                  fontWeight:
                      timeSection == 1 ? FontWeight.w800 : FontWeight.w100,
                  color:
                      timeSection == 3 ? Colors.white : kDescriptionTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeRecieve() {
    return ScopedModel(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
          if (model.currentStore != null) {
            final status = model.status;

            if (status == ViewStatus.Loading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShimmerBlock(width: 150, height: 32),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 24,
                    width: Get.width,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ShimmerBlock(
                            width: 80,
                            height: 24,
                            borderRadius: 16,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Giờ giao hàng ",
                        style: kDescriptionTextSyle.copyWith(
                          fontSize: 12,
                        ),
                        children: [
                          // WidgetSpan(
                          //   child: MyTooltip(
                          //     message:
                          //         "Thời gian bạn muốn nhận đơn của mình. Lưu ý thời gian chốt đơn thường sớm hơn 1 tiếng",
                          //     child: Icon(Icons.info_outline, size: 16),
                          //     height: 48,
                          //   ),
                          // ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                    height: 24,
                    width: Get.width,
                    child: ListView.builder(
                      // separatorBuilder: (context, index) => SizedBox(
                      //   width: 4,
                      // ),
                      itemBuilder: (context, index) {
                        DateTime arrive = DateFormat("HH:mm:ss")
                            .parse(model.currentStore.timeSlots[index].arrive);
                        bool isSelect =
                            model.currentStore.selectedTimeSlot.arrive ==
                                model.currentStore.timeSlots[index].arrive;
                        return AnimatedContainer(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(isSelect ? 16 : 0),
                            color: isSelect ? kPrimary : Colors.transparent,
                          ),
                          duration: Duration(milliseconds: 300),
                          child: InkWell(
                            onTap: () async {
                              if (model.currentStore.selectedTimeSlot != null) {
                                model.confirmTimeSlot(
                                    model.currentStore.timeSlots[index]);
                              }
                            },
                            child: Center(
                              child: Text(
                                "${DateFormat("HH:mm").format(arrive)} - ${DateFormat("HH:mm").format(arrive.add(Duration(minutes: 30)))}",
                                style: isSelect
                                    ? kTitleTextStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                      )
                                    : kDescriptionTextSyle.copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: model.currentStore.timeSlots.length,
                    )),
                SizedBox(height: 8),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  String _getTimeFrame([int time = 0]) {
    if (time > 4 && time <= 11) {
      return '🌄';
    } else if (time > 11 && time <= 15) {
      return '🌤';
    } else if (time > 15 && time <= 18) {
      return '🌇';
    } else if (time > 18 && time <= 24 || time >= 0 && time <= 4) {
      return '🌙';
    } else {
      return '⌚';
    }
  }

  Widget location([bool loading = false]) {
    return ScopedModel(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, root) {
          LocationDTO location = root.currentStore?.locations?.firstWhere(
            (element) => element.isSelected,
            orElse: () => null,
          );
          String text = "Đợi tý đang load...";
          final status = root.status;
          if (root.changeAddress) {
            text = "Đang thay đổi...";
          } else if (location != null) {
            text = location.address;
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
              children: [
                Text(
                  "📌 Nơi nhận: ",
                  style: kDescriptionTextSyle.copyWith(
                    fontWeight: FontWeight.w200,
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
                Flexible(
                  child: Text(
                    text,
                    style: kTitleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
      ),
    );
  }

  Widget _buildTimeAlert() {
    return ScopedModel(
        model: RootViewModel.getInstance(),
        child: ScopedModelDescendant<RootViewModel>(
            builder: (context, child, model) {
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
          TimeSlot selectedTimeSlot = model.currentStore?.selectedTimeSlot;
          if (selectedTimeSlot == null) {
            return SizedBox();
          }
          String currentTimeSlot = selectedTimeSlot?.to;
          var beanTime = new DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            double.parse(currentTimeSlot.split(':')[0]).round(),
            double.parse(currentTimeSlot.split(':')[1]).round(),
          );
          int differentTime = beanTime.difference(currentDate).inMilliseconds;
          bool isAvailableMenu = selectedTimeSlot.available;
          TimeSlot nextTimeSlot = model.currentStore.timeSlots
              ?.firstWhere((time) => time.available, orElse: () => null);

          DateTime arrive =
              DateFormat("HH:mm:ss").parse(selectedTimeSlot.arrive);

          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            // margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
            width: Get.width,
            height: 48,
            child: Align(
              alignment: Alignment.centerLeft,
              child: isAvailableMenu
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Text.rich(
                            TextSpan(
                              text: "Chốt đơn: ",
                              style: kSubtitleTextSyule.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                              ),
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
                            nextTimeSlot != null
                                ? "Khung giờ đã đóng bạn vui lòng xem chuyến hàng kế tiếp nha 😉."
                                : "Hiện tại các khung giờ đều đã đóng. Hẹn gặp bạn hôm sau nhé 😥.",
                            style: kTitleTextStyle.copyWith(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: nextTimeSlot != null
                                ? TextAlign.left
                                : TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 8),
                        nextTimeSlot != null
                            ? InkWell(
                                onTap: () {
                                  if (model.currentStore.selectedTimeSlot !=
                                      null) {
                                    model.confirmTimeSlot(nextTimeSlot);
                                  }
                                },
                                child: Text(
                                  "Xem ngay",
                                  style:
                                      TextStyle(color: kPrimary, fontSize: 12),
                                ),
                              )
                            : SizedBox(),
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
          );
        }));
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
    print("differentTime " + widget.differentTime.toString());

    return ScopedModel<RootViewModel>(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
          rebuildOnChange: false,
          builder: (context, child, model) {
            if (widget.differentTime <= 0) {
              return Text(
                "Hết giờ",
                style: TextStyle(color: Colors.red, fontSize: 12),
              );
            }
            return CountdownTimer(
              endTime:
                  DateTime.now().millisecondsSinceEpoch + widget.differentTime,
              onEnd: () async {
                await showStatusDialog(
                  "assets/images/global_error.png",
                  "Khung giờ đã kết thúc",
                  "Đã hết giờ chốt đơn cho khung giờ ${DateFormat("HH:mm").format(widget.arriveTime)} - ${DateFormat("HH:mm").format(widget.arriveTime.add(Duration(minutes: 30)))}. \n Hẹn gặp bạn ở khung giờ khác nhé 😢.",
                );
                // remove cart
                await model.clearCart();
              },
              widgetBuilder: (_, CurrentRemainingTime time) {
                if (time == null) {
                  return Text('Hết giờ',
                      style: TextStyle(color: Colors.red, fontSize: 12));
                }
                return Text(
                  "Còn lại ${time.hours ?? '0'}h : ${time.min ?? '0'}ph ",
                  style: TextStyle(color: kPrimary, fontSize: 12),
                );
              },
            );
          }),
    );
  }
}
