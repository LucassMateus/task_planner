import 'package:flutter/material.dart';
import 'package:task_planner/theme/colors/light_colors.dart';

class TopContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  const TopContainer({
    required this.child,
    this.height,
    this.width,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: const BoxDecoration(
          color: LightColors.kDarkYellow,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
