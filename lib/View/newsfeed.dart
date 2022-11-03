import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Accessories/appbar.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/button.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Widgets/beanoi_button.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({Key key}) : super(key: key);

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "THÔNG TẤN XÃ BEAN ƠI",
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: BeanOiTheme.palettes.primary500,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff4BAA67),
                        Color(0xff94C9A3),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  // height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Tặng quà cho bạn bè",
                                style: BeanOiTheme.typography.h2.copyWith(
                                    color: BeanOiTheme.palettes.secondary200),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  "Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Far far away, behind the word mountains, far",
                                  style: BeanOiTheme.typography.caption
                                      .copyWith(
                                          color: BeanOiTheme
                                              .palettes.secondary100)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("Đã hiểu",
                                  style: BeanOiTheme.typography.subtitle1
                                      .copyWith(
                                          color:
                                              BeanOiTheme.palettes.shades100)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              'assets/images/option.png',
                            )),
                      )
                    ],
                  )),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Hoạt động bạn bè",
                      style: BeanOiTheme.typography.subtitle1
                          .copyWith(color: BeanOiTheme.palettes.neutral800)),
                  BeanOiButton.solid(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage("assets/images/icons/gift.png"),
                            width: 20,
                            height: 20,
                          ),
                        ),
                        // Image.asset("assets/images/icons/gift.png"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Tặng quà',
                            style: BeanOiTheme.typography.buttonMd,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
