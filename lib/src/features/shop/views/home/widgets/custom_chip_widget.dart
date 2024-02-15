import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CustomChipWidget extends StatelessWidget {
  final String title;
  final bool active;
  final Function() onTap;

  const CustomChipWidget(
      {super.key,
      required this.title,
      required this.active,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: active
                  ? Border.all(
                      color: HAppColor.hBluePrimaryColor,
                      width: 1.5,
                    )
                  : Border.all(
                      color: HAppColor.hGreyColorShade300,
                      width: 1.5,
                    ),
              color: active
                  ? HAppColor.hBluePrimaryColor
                  : HAppColor.hBackgroundColor),
          child: Center(
              child: active
                  ? Text(title,
                      style: HAppStyle.label3Regular
                          .copyWith(color: HAppColor.hWhiteColor))
                  : Text(title, style: HAppStyle.label3Regular)),
        ));
  }
}
