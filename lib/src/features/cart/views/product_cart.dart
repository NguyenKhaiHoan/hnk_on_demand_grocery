import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';
import 'package:on_demand_grocery/src/features/store/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProductCartWidget extends StatelessWidget {
  const ProductCartWidget({super.key, required this.model});

  final ProductItem model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HAppSize.deviceWidth - 48,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        Container(
          height: 110,
          width: 110,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(model.imgPath), fit: BoxFit.fill)),
        ),
        gapW10,
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(
                      EvaIcons.flip2Outline,
                      size: 15,
                    ),
                    Text(
                      "Thay thế",
                      style: HAppStyle.label4Bold,
                    )
                  ],
                )),
            Column(
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  style: HAppStyle.heading4Style
                      .copyWith(overflow: TextOverflow.ellipsis),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
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
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: HAppColor.hBackgroundColor),
                        child: const Center(
                          child: Icon(
                            EvaIcons.minus,
                            size: 10,
                          ),
                        )),
                    gapW6,
                    const Text(
                      "1",
                      style: HAppStyle.paragraph2Bold,
                    ),
                    gapW6,
                    Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: HAppColor.hBluePrimaryColor),
                        child: const Center(
                          child: Icon(
                            EvaIcons.plus,
                            size: 10,
                            color: HAppColor.hWhiteColor,
                          ),
                        )),
                  ],
                ),
                gapW24,
                Text(
                  model.price,
                  style: HAppStyle.heading5Style
                      .copyWith(color: HAppColor.hBluePrimaryColor),
                )
              ],
            )
          ],
        ),
      ]),
    );
  }
}
