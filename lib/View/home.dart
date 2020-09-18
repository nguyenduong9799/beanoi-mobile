import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/View/product_detail.dart';
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
      print("Page: " + i.toString());
      listContents.add(homeContent(i));
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

  Widget homeContent(int page){
      return GridView.count(
        childAspectRatio: 0.7,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        children: List.generate(9, (index) => cardDetail(page, index)),
      );
  }

  Widget cardDetail(int page, int index){
    print("Index: " + (index + page * 10).toString());
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(new ProductDTO(uid: "P003", type: 5, description: "Trà sữa là loại thức uống đa dạng được tìm thấy ở nhiều nền văn hóa, bao gồm một vài cách kết hợp giữa trà và sữa. Các loại thức uống khác nhau tùy thuộc vào lượng thành phần chính của mỗi loại, phương pháp pha chế, và các thành phần khác được thêm vào. Bột trà sữa pha sẵn là một sản phẩm được sản xuất hàng loạt.",
                name: "Trà sữa",
                price: 20000,
                quantity: 1,
                size: "Size M",
                topping: ["Trân châu", "bánh flan", "thạch phô mai"],
                atrributes: {
                  "size": ["Size M", "Size L", "Size S"],
                  "đá" : ["0%" ,"50%", "70%", "100%"],
                  "đường" : ["0%" ,"50%", "70%", "100%"]
                },
                ), index + page * 10),));
          },

          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.25,
                color: Colors.grey[300],
                child: Center(
                  child: Hero(
                    tag: (index + page * 10).toString(),
                    child: Image(
                      image: NetworkImage("https://celebratingsweets.com/wp-content/uploads/2018/06/Strawberry-Shortcake-Cake-1-1.jpg"),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.width * 0.25,
                    ),
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
