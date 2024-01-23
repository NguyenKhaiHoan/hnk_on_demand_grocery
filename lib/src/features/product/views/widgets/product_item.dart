import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';
import 'package:on_demand_grocery/src/features/product/views/product_item_detail.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget(
      {super.key, required this.model, required this.storeIcon});

  final ProductItem model;
  final bool storeIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 165,
        decoration: BoxDecoration(
            color: HAppColor.hWhiteColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(model.imgPath),
                          fit: BoxFit.fill)),
                ),
              ),
              storeIcon
                  ? Positioned(
                      bottom: 10,
                      right: 10,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: HAppColor.hGreyColorShade300,
                                    image: DecorationImage(
                                        image: NetworkImage(model.imgStore),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HAppColor.hRedColor),
                  child: Text(model.salePersent,
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hWhiteColor)),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: HAppColor.hGreyColorShade300),
                          child: Center(
                            child: model.isFavorite == false
                                ? const Icon(
                                    EvaIcons.heartOutline,
                                    color: HAppColor.hWhiteColor,
                                  )
                                : const Icon(
                                    EvaIcons.heart,
                                    color: HAppColor.hRedColor,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(model.category,
                            style: HAppStyle.paragraph3Regular),
                        Text(model.unit, style: HAppStyle.paragraph3Regular),
                      ],
                    ),
                    gapH4,
                    Text(
                      model.name,
                      style: HAppStyle.label2Bold.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    gapH4,
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
                          style: HAppStyle.paragraph3Regular,
                        )
                      ],
                    )
                  ]),
            ),
            gapH2,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    model.price,
                    style: HAppStyle.label3Bold
                        .copyWith(color: HAppColor.hBluePrimaryColor),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: HAppColor.hBluePrimaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    EvaIcons.plus,
                    color: HAppColor.hWhiteColor,
                  )),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductItemScreen(model: model)),
        );
      },
    );
  }
}
