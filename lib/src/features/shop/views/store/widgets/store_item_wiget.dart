import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class StoreItemWidget extends StatelessWidget {
  StoreItemWidget({super.key, required this.model});
  final storeController = StoreController.instance;
  final wishlistController = WishlistController.instance;

  final StoreModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HAppSize.deviceWidth - hAppDefaultPadding * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Stack(
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(model.storeImage),
                        fit: BoxFit.fill)),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: GestureDetector(
                  onTap: () => wishlistController
                      .addOrRemoveStoreInFavoriteList(model.id),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: HAppColor.hBackgroundColor),
                    child: Center(
                        child: Obx(
                      () => !UserController
                              .instance.user.value.listOfFavoriteStore
                              .contains(model.id)
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: HAppStyle.heading4Style,
                ),
                gapH10,
                Text(
                  model.listOfCategoryId.join(', '),
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
                      ' /5',
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                    gapW2,
                    Text(" • ",
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600)),
                    gapW2,
                    Text(model.productCount.toString(),
                        style: HAppStyle.paragraph3Regular),
                    Text(" Sản phẩm",
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600))
                  ],
                ),
              ],
            ),
          ),
        ]),
      ]),
    );
  }
}

class ShimmerStoreItemWidget extends StatelessWidget {
  const ShimmerStoreItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HAppSize.deviceWidth - hAppDefaultPadding * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomShimmerWidget.rectangular(
            height: 130,
            width: 130,
          ),
          gapW10,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomShimmerWidget.rectangular(
                  height: 14,
                ),
                gapH10,
                CustomShimmerWidget.rectangular(
                  height: 16,
                ),
                gapH10,
                CustomShimmerWidget.rectangular(
                  height: 14,
                  width: 100,
                ),
              ],
            ),
          ),
        ]),
      ]),
    );
  }
}
