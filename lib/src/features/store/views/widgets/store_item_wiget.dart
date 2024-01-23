import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';
import 'package:on_demand_grocery/src/features/store/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class StoreItemWidget extends StatelessWidget {
  const StoreItemWidget({super.key, required this.model});

  final StoreModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HAppSize.deviceWidth - 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: EdgeInsets.all(10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.name,
              style: HAppStyle.heading4Style,
            ),
            // Text(
            //   model.category.join(', '),
            //   maxLines: 2,
            //   style: HAppStyle.paragraph3Regular.copyWith(
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            Text(
              "Tất cả",
              style: HAppStyle.paragraph3Regular.copyWith(
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  EvaIcons.star,
                  color: HAppColor.hOrangeColor,
                  size: 20,
                ),
                gapW2,
                Text(
                  '4.9 (100+)',
                  style: HAppStyle.paragraph3Regular
                      .copyWith(color: HAppColor.hGreyColor),
                ),
                gapW2,
                Text("|",
                    style: HAppStyle.paragraph3Regular
                        .copyWith(color: HAppColor.hGreyColor)),
                gapW2,
                Text("2.5 Km",
                    style: HAppStyle.paragraph3Regular
                        .copyWith(color: HAppColor.hGreyColor))
              ],
            )
          ],
        ),
        Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(model.imgStore), fit: BoxFit.fill)),
        )
      ]),
    );
  }
}
