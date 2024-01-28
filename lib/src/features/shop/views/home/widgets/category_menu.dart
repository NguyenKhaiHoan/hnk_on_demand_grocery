import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/category_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key, this.onTap, required this.model});

  final void Function()? onTap;

  final CategoryModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: HAppColor.hWhiteColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
              child: Image.asset(
            model.image,
            width: 40,
            height: 40,
          )),
        ),
        gapH4,
        Text(
          model.title,
          style: HAppStyle.paragraph3Regular,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
