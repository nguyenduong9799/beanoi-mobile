import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/startup_viewModel.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/constraints.dart';

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
            child: LoadingScreen(
              title: "Batch Delivery",
            ),
          ),
        );
      }),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final String title;
  const LoadingScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // width: 250.0,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingBean(),
              SizedBox(height: 16),
              Text(
                this.title,
                style: kHeadingextStyle.copyWith(color: kPrimary, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
