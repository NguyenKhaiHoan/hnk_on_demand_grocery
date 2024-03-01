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
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: HAppColor.hWhiteColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: CircleAvatar(
            backgroundColor: HAppColor.hWhiteColor,
            radius: 90.0,
            child: Image.network(
              model.image,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
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
