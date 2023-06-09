import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class OnBoardScreen extends StatefulWidget {
  OnBoardScreen({Key key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

PageDecoration pageDecoration = PageDecoration(
  titleTextStyle: Get.theme.textTheme.subtitle1,
  bodyTextStyle: Get.theme.textTheme.subtitle2,
  descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
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
          globalBackgroundColor: Colors.white,
          pages: pages,
          onDone: () => _onIntroEnd(),
          onSkip: () => _onIntroEnd(), // You can override onSkip callback
          showSkipButton: true,
          next: const Icon(
            Icons.arrow_forward,
            color: kPrimary,
          ),
          skip: Text(
            'Bỏ qua',
            style: Get.theme.textTheme.headline4.copyWith(color: Colors.grey),
          ),
          done: Text('Xong',
              style: Get.theme.textTheme.headline4.copyWith(color: kPrimary)),
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
      await Get.find<RootViewModel>().startUp();
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
