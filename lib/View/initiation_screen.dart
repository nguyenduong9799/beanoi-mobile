import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';

class InitiationPage extends StatefulWidget {
  @override
  _InitiationPageState createState() => _InitiationPageState();
}

class _InitiationPageState extends State<InitiationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: BeanOiTheme.palettes.neutral100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'CHỌN KHU VỰC ĐẶT ĐƠN',
                    style: TextStyle(
                        color: BeanOiTheme.palettes.primary200,
                        fontWeight: FontWeight.w800,
                        fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 40, right: 40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: BeanOiTheme.palettes.secondary800,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('Khu vực công nghệ cao is tapped');
                                  },
                                  child: Text(
                                    'Khu vực công nghệ cao',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: BeanOiTheme.palettes.secondary800,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 20,
                        endIndent: 20,
                        height: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: BeanOiTheme.palettes.secondary800,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('Vinhomes Grandpark is tapped');
                                  },
                                  child: Text('Vinhomes Grandpark',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: BeanOiTheme.palettes.secondary800,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 200,
                    width: 200,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
