import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/button.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Widgets/beanoi_button.dart';

class DesignScreen extends StatefulWidget {
  const DesignScreen({Key key}) : super(key: key);

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Screen'),
      ),
      body: Container(
        child: ListView(children: [
          Container(
            width: Size.infinite.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: BeanOiTheme.spacing.s),
                  child: Text(
                    'Typography',
                    style: BeanOiTheme.typography.h1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'H1',
                          style: BeanOiTheme.typography.h1,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.h1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'H2',
                          style: BeanOiTheme.typography.h2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.h2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Subtitle1',
                          style: BeanOiTheme.typography.subtitle1,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.subtitle1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Subtitle2',
                          style: BeanOiTheme.typography.subtitle2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.subtitle2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Body1',
                          style: BeanOiTheme.typography.body1,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.body1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Body2',
                          style: BeanOiTheme.typography.body2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.body2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Caption',
                          style: BeanOiTheme.typography.caption,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Overline',
                          style: BeanOiTheme.typography.overline,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.overline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: BeanOiTheme.spacing.s),
                child: Text(
                  'Button',
                  style: BeanOiTheme.typography.h1,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BeanOiButton.outlined(
                      onPressed: () {},
                      child: Text(
                        'Outlined Sm',
                        style: BeanOiTheme.typography.buttonOutlinedSm,
                      ),
                      size: BeanOiButtonSize.small,
                    ),
                    BeanOiButton.outlined(
                      onPressed: () {},
                      child: Text(
                        'Outlined Md',
                        style: BeanOiTheme.typography.buttonOutlinedMd,
                      ),
                      size: BeanOiButtonSize.medium,
                    ),
                    BeanOiButton.outlined(
                      onPressed: () {},
                      child: Text(
                        'Outlined Lg',
                        style: BeanOiTheme.typography.buttonOutlinedLg,
                      ),
                      size: BeanOiButtonSize.large,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BeanOiButton.gradient(
                      onPressed: () {},
                      child: Text(
                        'Gradient Sm',
                        style: BeanOiTheme.typography.buttonSm,
                      ),
                      size: BeanOiButtonSize.small,
                    ),
                    BeanOiButton.gradient(
                      onPressed: () {},
                      child: Text(
                        'Gradient Md',
                        style: BeanOiTheme.typography.buttonMd,
                      ),
                    ),
                    BeanOiButton.gradient(
                      onPressed: () {},
                      child: Text(
                        'Gradient Lg',
                        style: BeanOiTheme.typography.buttonLg,
                      ),
                      size: BeanOiButtonSize.large,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiTheme.spacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BeanOiButton.solid(
                      onPressed: () {},
                      child: Text(
                        'Solid Sm',
                        style: BeanOiTheme.typography.buttonSm,
                      ),
                      size: BeanOiButtonSize.small,
                    ),
                    BeanOiButton.solid(
                      onPressed: () {},
                      child: Text(
                        'Solid Md',
                        style: BeanOiTheme.typography.buttonMd,
                      ),
                    ),
                    BeanOiButton.solid(
                      onPressed: () {},
                      child: Text(
                        'Solid Lg',
                        style: BeanOiTheme.typography.buttonLg,
                      ),
                      size: BeanOiButtonSize.large,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ]),
      ),
    );
  }
}
