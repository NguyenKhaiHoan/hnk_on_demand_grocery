import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class CustomLayoutWidget extends StatelessWidget {
  const CustomLayoutWidget({
    super.key,
    required this.widget,
    required this.subWidget,
    this.check = false,
  });

  final Widget widget;
  final Widget subWidget;
  final bool check;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(
          hAppDefaultPadding,
          check ? 0 : hAppDefaultPadding,
          hAppDefaultPadding,
          hAppDefaultPadding),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        widget,
        gapH12,
        subWidget,
      ],
    );
  }
}
