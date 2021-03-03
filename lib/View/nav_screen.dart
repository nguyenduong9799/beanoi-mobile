import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/View/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/bottomnavigator.dart';
import 'package:unidelivery_mobile/acessories/cart_button.dart';

class RootScreen extends StatefulWidget {
  final int initScreenIndex;

  const RootScreen({Key key, this.initScreenIndex = 0}) : super(key: key);

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
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initScreenIndex;
    RootViewModel.getInstance().fetchStore().then((value) {
      RootViewModel.getInstance().getSuppliers();
      RootViewModel.getInstance().getGifts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<RootViewModel>(
      model: RootViewModel.getInstance(),
      child: DefaultTabController(
        length: _icons.length,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (e) {
            print("On Drag");
          },
          onLongPress: () {
            print("Press screen");
          },
          onTap: () {
            print("Tap screen");
            // TODO:
            // FEATURE: HIEN GOI Y KHI USER KHONG TAP VAO SCREEN MOT KHOANG THOI GIAN
          },
          child: Scaffold(
              floatingActionButton: buildCartButton(),
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
      ),
    );
  }
}
