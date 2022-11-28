import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class InitiationPage extends StatefulWidget {
  const InitiationPage({Key key}) : super(key: key);
  @override
  _InitiationPageState createState() => _InitiationPageState();
}

class _InitiationPageState extends State<InitiationPage> {
  @override
  void initState() {
    Get.find<RootViewModel>().getStores();
    super.initState();
    // _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: BeanOiTheme.palettes.neutral100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 50, left: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage('assets/images/logo.png'),
                      height: 150,
                      width: 150,
                    ),
                  ],
                )),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16),
                  alignment: Alignment.center,
                  child: Text(
                    'CHỌN KHU VỰC ĐẶT ĐƠN',
                    style: BeanOiTheme.typography.h2.copyWith(
                        color: BeanOiTheme.palettes.primary400,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ScopedModel(
                  model: Get.find<RootViewModel>(),
                  child: ScopedModelDescendant<RootViewModel>(
                      builder: (context, child, model) {
                    final status = model.status;
                    final stores = model.listStore;

                    if (status == ViewStatus.Loading)
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: CircularProgressIndicator())),
                      );

                    if (stores == null)
                      return Center(
                        child: Text('Không có cửa khu vực nào'),
                      );

                    return Container(
                        margin: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: BeanOiTheme.palettes.neutral300,
                                blurRadius: 6.0, // soften the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  5.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]),
                        child: Column(
                          children: stores
                              .map((store) => buildStoreSelect(store))
                              .toList(),
                        ));
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('Không có trong khu vực bạn muốn?'),
                      ),
                      Container(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  print('Gợi ý is tapped');
                                },
                                child: Text(
                                  'Gợi ý',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: BeanOiTheme.palettes.primary400,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Text(' cho chúng mình nhé')
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Container(
            //       child: Image(
            //         image: AssetImage('assets/images/logo.png'),
            //         height: 200,
            //         width: 200,
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildStoreSelect(CampusDTO area) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Get.find<RootViewModel>().setCurrentStore(area);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: BeanOiTheme.palettes.secondary800,
                ),
                Text(
                  area.name,
                  style: BeanOiTheme.typography.body2,
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: BeanOiTheme.palettes.secondary800,
            )
          ],
        ),
      ),
    );
  }
}
