import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/CampusDTO.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/acessories/shimmer_block.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

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
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
          _buildTopHeader(),
          timeRecieve(),
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
              SizedBox(width: 8),
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
            final currentDate = DateTime.now();
            final status = model.status;
            TimeSlot seleectedTimeSlot = model.currentStore.selectedTimeSlot;
            String currentTimeSlot = seleectedTimeSlot.to;
            var beanTime = new DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
              int.parse(currentTimeSlot.split(':')[0]),
              int.parse(currentTimeSlot.split(':')[1]),
            );
            int diffentTime = beanTime.difference(currentDate).inMilliseconds;

            if (status == ViewStatus.Loading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShimmerBlock(width: 150, height: 32),
                      ShimmerBlock(width: 75, height: 32),
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
                        text:
                            "${_getTimeFrame(int.parse(seleectedTimeSlot.from.split(':')[0]))} Giờ nhận đơn ",
                        style: kDescriptionTextSyle.copyWith(
                          fontSize: 12,
                        ),
                        children: [
                          WidgetSpan(
                            child: Tooltip(
                              message:
                                  "Thời gian bạn muốn nhận đơn của mình. Lưu ý thời gian chốt đơn thường sớm hơn 1 tiếng",
                              child: Icon(Icons.info_outline, size: 16),
                              height: 48,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    BeanTimeCountdown(
                      differentTime: diffentTime,
                      arriveTime: model.currentStore.selectedTimeSlot.arrive,
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
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(isSelect ? 16 : 0),
                            color: isSelect ? kPrimary : Colors.transparent,
                          ),
                          duration: Duration(milliseconds: 300),
                          child: InkWell(
                            onTap: () async {
                              if (model.currentStore.selectedTimeSlot != null) {
                                if (model.selectTimeSlot(model
                                    .currentStore.timeSlots[index].menuId)) {
                                  model.confirmTimeSlot();
                                } else {
                                  showStatusDialog(
                                      "assets/images/global_error.png",
                                      "Khung giờ đã qua rồi",
                                      "Đừng nối tiếc quá khứ, hãy hướng về tương lai");
                                }
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
          String text = "Đợi tý đang load...";
          final status = root.status;
          if (root.changeAddress) {
            text = "Đang thay đổi...";
          } else {
            if (root.currentStore != null) {
              text = "${root.currentStore.name}";
            }
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
                  "🗺 Khu vực: ",
                  style: kDescriptionTextSyle.copyWith(
                    fontWeight: FontWeight.w200,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  text,
                  style: kTitleTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
}

class BeanTimeCountdown extends StatefulWidget {
  const BeanTimeCountdown({
    Key key,
    @required this.differentTime,
    @required this.arriveTime,
  }) : super(key: key);

  final int differentTime;
  final String arriveTime;

  @override
  _BeanTimeCountdownState createState() => _BeanTimeCountdownState();
}

class _BeanTimeCountdownState extends State<BeanTimeCountdown> {
  @override
  Widget build(BuildContext context) {
    print("differentTime " + widget.differentTime.toString());
    if (widget.differentTime <= 0) {
      return Text(
        'Hết giờ',
        style: TextStyle(color: Colors.red, fontSize: 12),
      );
    }
    return CountdownTimer(
      endTime: DateTime.now().millisecondsSinceEpoch + widget.differentTime,
      onEnd: () {
        showStatusDialog(
          "assets/images/global_error.png",
          "Hết giờ",
          "Đã hết giờ chốt đơn cho khung giờ ${widget.arriveTime}. \n Bạn quay lại sau nhé 😢",
        );
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
  }
}
