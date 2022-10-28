import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/button.dart';

import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';

class BeanOiButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool onHover;
  final double padding;
  final BeanOiButtonType type;
  final BeanOiButtonSize size;
  final Color bgColor;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final bool isDisabled;

  BeanOiButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.padding,
    this.type = BeanOiButtonType.gradient,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = BeanOiButtonSize.medium,
    this.onHover,
    this.isDisabled = false,
  }) : super(key: key);

  BeanOiButton.solid({
    @required this.onPressed,
    @required this.child,
    this.padding,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = BeanOiButtonSize.medium,
    this.onHover,
    this.isDisabled = false,
  }) : type = BeanOiButtonType.solid;
  BeanOiButton.outlined({
    @required this.onPressed,
    @required this.child,
    this.padding,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = BeanOiButtonSize.medium,
    this.onHover,
    this.isDisabled = false,
  }) : type = BeanOiButtonType.outlined;
  BeanOiButton.gradient({
    @required this.onPressed,
    @required this.child,
    this.padding,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = BeanOiButtonSize.medium,
    this.onHover,
    this.isDisabled = false,
  }) : type = BeanOiButtonType.gradient;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BeanOiButtonType.solid:
        return InkWell(
          onHover: (onHover) {},
          onTap: isDisabled ? null : onPressed,
          child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(padding ??
                  (size == BeanOiButtonSize.large
                      ? 10
                      : size == BeanOiButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                color: isDisabled
                    ? BeanOiTheme.palettes.neutral500
                    : bgColor ?? BeanOiTheme.palettes.primary300,
                borderRadius: BorderRadius.circular(borderRadius ??
                    (size == BeanOiButtonSize.large
                        ? 10
                        : size == BeanOiButtonSize.medium
                            ? 8
                            : 6)),
                border: Border.all(
                  color: BeanOiTheme.palettes.primary300,
                  width: 1,
                  style: isDisabled ? BorderStyle.none : BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(21, 126, 52, 0.8),
                    offset: isDisabled ? Offset(0, 0) : Offset(0, 3),
                  ),
                ],
              ),
              child: child),
        );
      case BeanOiButtonType.gradient:
        return InkWell(
          onTap: onPressed,
          child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(padding ??
                  (size == BeanOiButtonSize.large
                      ? 10
                      : size == BeanOiButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    isDisabled
                        ? BeanOiTheme.palettes.neutral500
                        : Color(0xff4BAA67),
                    isDisabled
                        ? BeanOiTheme.palettes.neutral500
                        : Color(0xff94C9A3),
                  ],
                ),
                borderRadius: BorderRadius.circular(borderRadius ??
                    (size == BeanOiButtonSize.large
                        ? 10
                        : size == BeanOiButtonSize.medium
                            ? 8
                            : 6)),
                border: Border.all(
                  color: BeanOiTheme.palettes.primary300,
                  width: 1,
                  style: isDisabled ? BorderStyle.none : BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(21, 126, 52, 0.8),
                    offset: isDisabled ? Offset(0, 0) : Offset(0, 3),
                  ),
                ],
              ),
              child: child),
        );
      case BeanOiButtonType.outlined:
        return InkWell(
          onTap: () {},
          child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(padding ??
                  (size == BeanOiButtonSize.large
                      ? 10
                      : size == BeanOiButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                color: isDisabled
                    ? BeanOiTheme.palettes.neutral300
                    : bgColor ?? Colors.white,
                borderRadius: BorderRadius.circular(borderRadius ??
                    (size == BeanOiButtonSize.large
                        ? 10
                        : size == BeanOiButtonSize.medium
                            ? 8
                            : 6)),
                border: Border.all(
                  color: isDisabled
                      ? BeanOiTheme.palettes.neutral500
                      : BeanOiTheme.palettes.primary500,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(21, 126, 52, 0.8),
                    offset: isDisabled ? Offset(0, 0) : Offset(0, 3),
                  ),
                ],
              ),
              child: child),
        );
      default:
        return InkWell(
          onTap: onPressed,
          child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(padding ??
                  (size == BeanOiButtonSize.large
                      ? 10
                      : size == BeanOiButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                color: isDisabled
                    ? BeanOiTheme.palettes.neutral500
                    : bgColor ?? BeanOiTheme.palettes.primary300,
                borderRadius: BorderRadius.circular(borderRadius ??
                    (size == BeanOiButtonSize.large
                        ? 10
                        : size == BeanOiButtonSize.medium
                            ? 8
                            : 6)),
                border: Border.all(
                  color: BeanOiTheme.palettes.primary300,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(21, 126, 52, 0.8),
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: child),
        );
    }
  }
}
