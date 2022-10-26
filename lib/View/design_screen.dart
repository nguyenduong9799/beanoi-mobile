import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/spacing.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/typography.dart';
import 'package:unidelivery_mobile/Widgets/button.dart';

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
                  padding: EdgeInsets.only(top: BeanOiSpacing.s),
                  child: Text(
                    'Typography',
                    style: BeanOiTheme.typography.h1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                  padding: EdgeInsets.all(BeanOiSpacing.s),
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
                Padding(
                  padding: EdgeInsets.all(BeanOiSpacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Button Large',
                          style: BeanOiTheme.typography.buttonLg,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.buttonLg,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiSpacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Button Medium',
                          style: BeanOiTheme.typography.buttonMd,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.buttonMd,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BeanOiSpacing.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Button Small',
                          style: BeanOiTheme.typography.buttonSm,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Typography',
                          textAlign: TextAlign.end,
                          style: BeanOiTheme.typography.buttonSm,
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
                padding: EdgeInsets.only(top: BeanOiSpacing.s),
                child: Text(
                  'Button',
                  style: BeanOiTheme.typography.h1,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiSpacing.s),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Button',
                        style: BeanOiTheme.typography.h2,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: BeanOiButton.large(
                        onPressed: () {},
                        child: Text('Button'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiSpacing.s),
                child: BeanOiButton.medium(
                  onPressed: () {},
                  child: Text('Button'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiSpacing.s),
                child: BeanOiButton.small(
                  onPressed: () {},
                  child: Text('Button'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiSpacing.s),
                child: BeanOiButton.outlined(
                  onPressed: () {},
                  child: Text('Button'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiSpacing.s),
                child: BeanOiButton.rounded(
                  onPressed: () {},
                  child: Text('Button'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiSpacing.s),
                child: BeanOiButton.block(
                  onPressed: () {},
                  child: Text('Button'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(BeanOiSpacing.s),
                child: BeanOiButton.text(
                  onPressed: () {},
                  child: Text('Button'),
                ),
              ),
            ],
          )),
          Container(
            height: 100,
            color: BeanOiTheme.palettes.primary300,
          ),
          Container(
            height: 100,
            color: BeanOiTheme.palettes.secondary500,
          ),
          Container(
            height: 100,
            color: BeanOiTheme.palettes.neutral500,
          ),
          Container(height: 100, color: BeanOiTheme.palettes.success300),
          Container(
            height: 100,
            color: BeanOiTheme.palettes.error300,
          ),
          Container(
            height: 100,
            color: BeanOiTheme.palettes.shades200,
          ),
        ]),
      ),
    );
  }
}
