import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/startup_viewModel.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<StartUpViewModel>(
      model: StartUpViewModel.getInstance(),
      child: ScopedModelDescendant<StartUpViewModel>(
          builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: LoadingScreen(),
          ),
        );
      }),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          // width: 250.0,
          child: Center(
            child: LoadingBean(),

            // TextLiquidFill(
            //   text: 'UniDelivery',
            //   waveColor: kPrimary,
            //   boxBackgroundColor: Colors.white,
            //   textStyle: TextStyle(
            //     fontSize: 45.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   boxHeight: 300.0,
            // ),
          ),
        ),
      ),
    );
  }
}