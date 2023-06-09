import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/button.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/Widgets/beanoi_button.dart';
// import 'package:unidelivery_mobile/Widgets/button.dart';

class HomeLocationSelect extends StatefulWidget {
  final CampusDTO selectedCampus;
  HomeLocationSelect({Key key, this.selectedCampus}) : super(key: key);

  @override
  _HomeLocationSelectState createState() => _HomeLocationSelectState();
}

class _HomeLocationSelectState extends State<HomeLocationSelect> {
  @override
  void initState() {
    super.initState();
    Get.find<RootViewModel>().getStores();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<RootViewModel>(),
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
          switch (model.status) {
            case ViewStatus.Loading:
              return Container(
                height: Get.height * 0.55,
                decoration: BoxDecoration(
                  color: kBackgroundGrey[3],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case ViewStatus.Error:
              return Container(
                height: Get.height * 0.55,
                decoration: BoxDecoration(
                  color: kBackgroundGrey[3],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: Image.asset(
                    'assets/images/global_error.png',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            default:
              return Container(
                height: Get.height * 0.55,
                decoration: BoxDecoration(
                  color: kBackgroundGrey[3],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Chọn nơi nhận",
                              style: BeanOiTheme.typography.h2),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BeanOiButton.outlined(
                                onPressed: () {
                                  Get.offAndToNamed(RouteHandler.SELECT_STORE);
                                },
                                size: BeanOiButtonSize.small,
                                child: Text(
                                  "Đổi khu vực",
                                ))),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                            children: widget.selectedCampus != null
                                ? [_buildPanel(widget.selectedCampus)]
                                : _buildPanel(widget.selectedCampus)),
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     color: Colors.white,
                    //     child: ListView(
                    //       children: widget.selectedCampus != null
                    //           ? [_buildPanel(widget.selectedCampus)]
                    //           : model.listStore
                    //               .asMap()
                    //               .map((index, campus) => MapEntry(
                    //                   campus, _buildPanel(campus, index)))
                    //               .values
                    //               .toList(),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildPanel(CampusDTO campus) {
    // return ExpandablePanel(
    //   theme: const ExpandableThemeData(
    //     tapBodyToCollapse: true,
    //     iconColor: kPrimary,
    //   ),
    //   collapsed: SizedBox.shrink(),
    //   header: Container(
    //     padding: EdgeInsets.only(top: 8, bottom: 8),
    //     child: Row(
    //       children: [
    //         Icon(Icons.location_on_outlined, color: kPrimary),
    //         SizedBox(width: 8),
    //         Flexible(
    //           child: Text(campus.name,
    //               style: campus.available
    //                   ? Get.theme.textTheme.headline3
    //                   : Get.theme.textTheme.headline3
    //                       .copyWith(color: Colors.grey)),
    //         ),
    //       ],
    //     ),
    //   ),
    //   expanded: Container(
    //     width: double.infinity,
    //     padding: EdgeInsets.only(bottom: 8),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         ...campus.locations
    //             .map(
    //               (location) => _buildLocationItem(location, campus),
    //             )
    //             .toList(),
    //       ],
    //     ),
    //   ),
    // );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...campus.locations
              .map(
                (location) => _buildLocationItem(location, campus),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildLocationItem(LocationDTO location, CampusDTO campus) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200], width: 1),
        ),
      ),
      padding: EdgeInsets.only(left: 16, bottom: 8, right: 16, top: 8),
      child: ScopedModelDescendant<RootViewModel>(
          builder: (context, child, model) {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.do_disturb_on, color: kPrimary, size: 12),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    location.address,
                    style: Get.theme.textTheme.headline3
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            ...location.destinations?.map((e) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        model.setLocation(
                          e,
                          location,
                          campus,
                        );
                      },
                      child: buildDestinationItem(e)),
                ))
          ],
        );
      }),
    );
  }

  Widget buildDestinationItem(DestinationDTO dto) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 16, bottom: 8, right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
              dto.isSelected
                  ? Icons.radio_button_checked_outlined
                  : Icons.panorama_fisheye_outlined,
              color: kPrimary,
              size: 12),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              dto.name,
              style: Get.theme.textTheme.headline3
                  .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
