import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

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
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Chọn nơi nhận",
                        style: Get.theme.textTheme.headline1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                          children: widget.selectedCampus != null
                              ? [_buildPanel(widget.selectedCampus)]
                              : model.campuses
                                  .asMap()
                                  .map((index, campus) => MapEntry(
                                      campus, _buildPanel(campus, index)))
                                  .values
                                  .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildPanel(CampusDTO campus, [int index]) {
    return ExpandablePanel(
      theme: const ExpandableThemeData(
        tapBodyToCollapse: true,
        iconColor: kPrimary,
      ),
      collapsed: SizedBox.shrink(),
      header: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: kPrimary),
            SizedBox(width: 8),
            Flexible(
              child: Text(campus.name,
                  style: campus.available
                      ? Get.theme.textTheme.headline4
                      : Get.theme.textTheme.headline4
                          .copyWith(color: Colors.grey)),
            ),
          ],
        ),
      ),
      expanded: Container(
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
      ),
    );
  }

  Widget _buildLocationItem(LocationDTO location, CampusDTO campus) {
    return ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            model.setLocation(location, campus);
          },
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200], width: 1),
              ),
            ),
            margin: EdgeInsets.only(left: 16),
            padding: EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.panorama_fisheye_outlined,
                    color: kPrimary, size: 12),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    location.address,
                    style: Get.theme.textTheme.headline6
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
