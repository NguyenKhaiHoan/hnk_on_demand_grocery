import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
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
          alignment: Alignment.bottomCenter,
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: HAppColor.hWhiteColor,
            shape: BoxShape.circle,
          ),
          child: Image.network(
            model.image,
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
        ),
        gapH4,
        Text(
          model.name,
          style: HAppStyle.paragraph3Regular,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
