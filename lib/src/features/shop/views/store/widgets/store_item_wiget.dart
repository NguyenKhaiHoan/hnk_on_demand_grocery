import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class StoreItemWidget extends StatelessWidget {
  StoreItemWidget({super.key, required this.model});
  final storeController = Get.put(StoreController());

  final StoreModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HAppSize.deviceWidth - 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Stack(
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(model.imgStore), fit: BoxFit.fill)),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: GestureDetector(
                  onTap: () => storeController.addStoreInFavorited(model),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: HAppColor.hBackgroundColor),
                    child: Center(
                        child: Obx(
                      () => !storeController.isFavoritedStores.contains(model)
                          ? const Icon(
                              EvaIcons.heartOutline,
                              color: HAppColor.hGreyColor,
                            )
                          : const Icon(
                              EvaIcons.heart,
                              color: HAppColor.hRedColor,
                            ),
                    )),
                  ),
                ),
              ),
            ],
          ),
          gapW10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: HAppStyle.heading4Style,
                ),
                gapH10,
                Text(
                  model.category.join(', '),
                  maxLines: 2,
                  style: HAppStyle.paragraph3Regular.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                gapH10,
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
                      model.rating.toStringAsFixed(1),
                      style: HAppStyle.paragraph3Regular,
                    ),
                    Text(
                      ' (100+)',
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                    gapW2,
                    Text(" • ",
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600)),
                    gapW2,
                    Text(model.distance.toStringAsFixed(1),
                        style: HAppStyle.paragraph3Regular),
                    Text(" Km",
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600))
                  ],
                ),
              ],
            ),
          ),
        ]),
        gapH10,
        Row(
          children: [
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    style: HAppStyle.paragraph3Bold,
                    text: "130 ",
                    children: [
                      TextSpan(
                        text: 'Sản phẩm',
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600),
                      ),
                    ],
                  ),
                ),
                Text(
                  " • ",
                  style: HAppStyle.paragraph3Regular
                      .copyWith(color: HAppColor.hGreyColorShade600),
                ),
                Text.rich(
                  TextSpan(
                    style: HAppStyle.paragraph3Bold,
                    text: '1k+ ',
                    children: [
                      TextSpan(
                        text: 'Đã bán',
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 40,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: HAppColor.hGreyColorShade300),
                  ),
                  onPressed: () => Get.toNamed(HAppRoutes.storeDetail,
                      arguments: {'model': model}),
                  child: const Text("Ghé thăm")),
            )
          ],
        ),
      ]),
    );
  }
}
