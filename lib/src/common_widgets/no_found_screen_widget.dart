import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class NotFoundScreenWidget extends StatelessWidget {
  const NotFoundScreenWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.widget,
    required this.subWidget,
  });

  final String title;
  final String subtitle;
  final Widget widget;
  final Widget subWidget;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(hAppDefaultPadding),
          child: Column(children: [
            gapH40,
            Container(
              width: HAppSize.deviceWidth * 0.4,
              height: HAppSize.deviceWidth * 0.4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/other/not_found.jpg'),
                      fit: BoxFit.cover)),
            ),
            gapH24,
            Text(
              title,
              style: HAppStyle.label2Bold,
              textAlign: TextAlign.center,
            ),
            gapH10,
            Text(
              subtitle,
              style: HAppStyle.paragraph2Regular
                  .copyWith(color: HAppColor.hGreyColorShade600),
              textAlign: TextAlign.center,
            ),
            gapH24,
            widget,
            gapH40,
            subWidget,
          ]),
        )
      ],
    );
  }
}
