import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/View/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class RootScreen extends StatefulWidget {
  final int initScreenIndex;

  const RootScreen({Key key, this.initScreenIndex}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    GiftScreen(),
    ProfileScreen(),
  ];
  final List<IconData> _icons = const [
    MaterialCommunityIcons.food,
    Icons.card_giftcard,
    MaterialCommunityIcons.face_outline,
  ];
  int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initScreenIndex;
    Get.find<HomeViewModel>().getSuppliers();
    Get.find<GiftViewModel>().getGifts();
    Get.find<AccountViewModel>().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _icons.length,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: (e) {},
        onLongPress: () {},
        onTap: () {
          // TODO:
          // FEATURE: HIEN GOI Y KHI USER KHONG TAP VAO SCREEN MOT KHOANG THOI GIAN
        },
        child: Scaffold(
            floatingActionButton: CartButton(),
            body: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            bottomNavigationBar: Container(
              // padding: const EdgeInsets.only(bottom: 12.0),
              color: Colors.white,
              child: CustomTabBar(
                icons: _icons,
                selectedIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
              ),
            )),
      ),
    );
  }
}
