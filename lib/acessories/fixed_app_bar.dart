import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

import '../route_constraint.dart';

class FixedAppBar extends StatefulWidget {
  FixedAppBar({Key key}) : super(key: key);

  @override
  _FixedAppBarState createState() => _FixedAppBarState();
}

class _FixedAppBarState extends State<FixedAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      width: Get.width,
      // height: Get.height * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    location(),
                    Container(
                      width: Get.width,
                      height: 48,
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: kPrimary,
                                ),
                                child: Text(
                                  'Sáng 🌄',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Ink(
                              color: kPrimary,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // color: kPrimary,
                                ),
                                child: Text(
                                  'Trưa 🌤',
                                  style: kDescriptionTextSyle.copyWith(
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                // color: kPrimary,
                              ),
                              child: Text(
                                'Chiều 🌇',
                                style: kDescriptionTextSyle.copyWith(
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        )
                        // Icon(
                        //   Foundation.clipboard_notes,
                        //   size: 30,
                        //   color: Colors.white,
                        // ),
                        ),
                    onTap: () {
                      Get.toNamed(RouteHandler.ORDER_HISTORY);
                    },
                  ),
                ),
              )
            ],
          ),
          timeRecieve(),
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
            String currentTimeSlot = model.currentStore.selectedTimeSlot.to;
            // var beanTime = DateFormat("HH:mm:ss").parse(
            //     "${currentDate.year}-${currentDate.month}-${currentDate.day} ${model.currentStore.selectedTimeSlot.to}");
            var beanTime = new DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
              int.parse(currentTimeSlot.split(':')[0]),
              int.parse(currentTimeSlot.split(':')[1]),
            );
            print(beanTime.toString());
            final differenceHour = beanTime.difference(currentDate).inHours;
            final differenceMinute = beanTime.difference(currentDate).inMinutes;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("⌚ Giờ nhận đơn: "),
                    CountdownTimer(
                      endTime:
                          DateTime.now().millisecondsSinceEpoch + 3800 * 1000,
                      onEnd: () {
                        showStatusDialog(
                          "assets/images/global_error.png",
                          "Hết giờ",
                          "Đã hết giờ chốt đơn cho khung giờ ${model.currentStore.selectedTimeSlot.arrive}",
                        );
                      },
                      widgetBuilder: (_, CurrentRemainingTime time) {
                        if (time == null) {
                          return Text('Hết giờ',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12));
                        }
                        return Text(
                          "Còn lại ${time.hours ?? '0'}h : ${time.min ?? '0'}ph ",
                          style: TextStyle(color: kPrimary, fontSize: 12),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                    height: 32,
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
                        return InkWell(
                          onTap: () async {
                            if (model.currentStore.selectedTimeSlot != null) {
                              if (model.selectTimeSlot(
                                  model.currentStore.timeSlots[index].menuId)) {
                                model.confirmTimeSlot();
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(8),
                              border: Border(
                                bottom: BorderSide(
                                    color: kPrimary, width: isSelect ? 2 : 0),
                              ),
                            ),
                            child: Text(
                              "${DateFormat("HH:mm").format(arrive)} - ${DateFormat("HH:mm").format(arrive.add(Duration(minutes: 30)))}",
                              style: isSelect
                                  ? kTitleTextStyle.copyWith(
                                      color: kPrimary,
                                      fontSize: 14,
                                    )
                                  : kDescriptionTextSyle.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: model.currentStore.timeSlots.length,
                    )),
              ],
            );
          }
          return Container();
        },
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
