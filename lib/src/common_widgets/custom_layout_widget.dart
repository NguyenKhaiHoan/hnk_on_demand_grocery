import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class CustomLayoutWidget extends StatelessWidget {
  const CustomLayoutWidget({
    super.key,
    required this.widget,
    required this.subWidget,
  });

  final Widget widget;
  final Widget subWidget;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(
          hAppDefaultPadding, 0, hAppDefaultPadding, hAppDefaultPadding),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        widget,
        gapH12,
        subWidget,
      ],
    );
  }
}
