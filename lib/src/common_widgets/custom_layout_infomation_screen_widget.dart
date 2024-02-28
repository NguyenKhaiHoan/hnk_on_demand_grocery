import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CustomLayoutInformationScreenWidget extends StatelessWidget {
  const CustomLayoutInformationScreenWidget(
      {super.key,
      required this.lottieImage,
      required this.title,
      required this.widget1,
      required this.widget2,
      required this.subTitle,
      this.action});

  final String lottieImage;
  final String title;
  final String subTitle;
  final Widget widget1;
  final Widget widget2;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: action,
      ),
      body: Padding(
        padding: const EdgeInsets.all(hAppDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(lottieImage, height: 250, fit: BoxFit.cover),
            gapH20,
            Text(
              title,
              style: HAppStyle.heading3Style,
              textAlign: TextAlign.center,
            ),
            gapH10,
            Text(
              subTitle,
              style: HAppStyle.paragraph2Regular
                  .copyWith(color: HAppColor.hGreyColorShade600),
              textAlign: TextAlign.center,
            ),
            gapH40,
            widget1,
            gapH12,
            widget2,
          ],
        ),
      ),
    );
  }
}
