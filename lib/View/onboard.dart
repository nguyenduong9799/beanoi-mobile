import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class OnBoardScreen extends StatefulWidget {
  OnBoardScreen({Key key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

const pageDecoration = const PageDecoration(
  titleTextStyle: const TextStyle(
      fontSize: 28.0, fontWeight: FontWeight.w700, color: kPrimary),
  bodyTextStyle: const TextStyle(fontSize: 19.0, color: kPrimary),
  descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
  pageColor: Colors.white,
  imagePadding: EdgeInsets.zero,
);

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final pages = [
      PageViewModel(
        title: "Chọn món từ nhiều cửa hàng",
        body:
            "Đặt được nhiều đơn hàng từ nhiều cửa hàng khác nhau mà chi phí lại rẻ đến bất ngờ.",
        image: _buildImage('onboard_1.png'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Ăn đúng bữa",
        body:
            "Đặt hàng theo khung giờ và Bean sẽ nhắc bạn ăn cơm đúng bữa để tránh chiếc bụng đói.",
        image: _buildImage('onboard_2.png'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Tích thật nhiều đậu",
        body: "Tích góp thật nhiều đậu và đổi được những phần quà hay ho nhá.",
        image: _buildImage('onboard_3.png'),
        decoration: pageDecoration,
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: IntroductionScreen(
          pages: pages,
          onDone: () => _onIntroEnd(),
          onSkip: () => _onIntroEnd(), // You can override onSkip callback
          showSkipButton: true,
          next: const Icon(
            Icons.arrow_forward,
            color: kPrimary,
          ),
          skip: const Text(
            'Bỏ qua',
            style: TextStyle(color: Colors.grey),
          ),
          done: const Text('Xong',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: kPrimary, fontSize: 14)),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Colors.grey,
            activeColor: kPrimary,
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }

  void _onIntroEnd() async {
    // set pref that first onboard is false
    AccountDAO _accountDAO = AccountDAO();
    var hasLoggedInUser = await _accountDAO.isUserLoggedIn();
    await setIsFirstOnboard(false);
    if (hasLoggedInUser) {
      Get.offAndToNamed(RouteHandler.NAV);
    } else {
      Get.offAndToNamed(RouteHandler.LOGIN);
    }
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }
}
