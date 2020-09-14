import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/ViewModel/login_viewModel.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/bottomnavigator.dart';
import 'package:unidelivery_mobile/services/firebase.dart';

class HomeScreen extends StatefulWidget {
  final AccountDTO user;
  const HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool switcher = false;


  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return Scaffold(
      bottomNavigationBar: DefaultNavigatorBar(selectedIndex: 0,),
      backgroundColor: Colors.grey[300],
      //bottomNavigationBar: bottomBar(),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  banner(),
                  swipeLayout(),
                  tag()
                ],
              ),
            ),
          ),
          HomeAppBar(),
        ],
      ),
    );
  }

  Widget banner(){
    return Container(
      height: 90,
      color: Colors.red,
    );
  }

  Widget swipeLayout(){
    List<Widget> listContents = new List();
    for(int i = 0; i < 9; i++){
      listContents.add(homeContent());
    }
    return Expanded(
      child: Swiper(
        loop: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) => listContents[index],
        itemCount: listContents.length,
        pagination: new SwiperPagination(),

      ),
    );
  }

  Widget homeContent(){
      return GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        childAspectRatio: MediaQuery.of(context).size.width * 0.25 /
            (30 + MediaQuery.of(context).size.width * 0.25),
        crossAxisCount: 3,
        children: List.generate(9, (index) => cardDetail()),
      );
  }

  Widget cardDetail(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.25,
                color: Colors.grey[300],
                child: Center(
                  child: Image(
                    image: NetworkImage("https://celebratingsweets.com/wp-content/uploads/2018/06/Strawberry-Shortcake-Cake-1-1.jpg"),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.width * 0.25,
                  ),
                ),
              ),
              Text("Bánh Gato", style: TextStyle(fontSize: 14)),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Widget tag(){
    double screenWidth = MediaQuery.of(context).size.width;
    return Animator(
      tween: Tween<Offset>(begin: Offset(0, -50), end: Offset(0, 50)),
      duration: Duration(seconds: 2),
      cycles: 2,
      builder: (context, animatorState, child) {
        return Transform.translate(
          offset: animatorState.value,
          child: Container(
            height: 50,
            color: Colors.amber,
            child: !switcher ? Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Colors.blue,
                    child: Text("Tất cả"),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text("Gần đây"),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text("Mới"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        switcher = true;
                      });
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ):
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        switcher = false;
                      });
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text("Món nước"),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text("Món cơm"),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text("Thức uống"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
