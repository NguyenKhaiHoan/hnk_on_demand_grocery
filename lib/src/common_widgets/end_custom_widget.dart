import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class EndCustomWidget extends StatelessWidget {
  const EndCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: HAppSize.deviceWidth * 0.3, right: HAppSize.deviceWidth * 0.3),
      child: const Row(children: [
        Expanded(child: Divider()),
        Text(" Hết "),
        Expanded(child: Divider()),
        gapH100
      ]),
    );
  }
}
