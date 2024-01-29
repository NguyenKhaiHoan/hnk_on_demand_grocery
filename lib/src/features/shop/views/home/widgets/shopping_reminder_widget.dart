import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ShoppingReminderWidget extends StatelessWidget {
  ShoppingReminderWidget({super.key});

  final homeController = Get.put(HomeController());
  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: HAppColor.hWhiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: HAppColor.hBlueSecondaryColor)),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tiếp tục mua sắm",
                style: HAppStyle.heading4Style,
              ),
              GestureDetector(
                  onTap: () => homeController.closeReminder(),
                  child: const Icon(
                    EvaIcons.closeCircle,
                    size: 20,
                    color: HAppColor.hGreyColor,
                  ))
            ],
          ),
          gapH6,
          const Text(
            "Giỏ hàng của bạn đang chờ bạn. Bạn còn chần chừ gì nữa? Hãy tiếp tục mua sắm và khám phá những sản phẩm tuyệt vời khác!",
            style: HAppStyle.paragraph3Regular,
          ),
          gapH10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    EvaIcons.shoppingBag,
                    size: 25,
                    color: HAppColor.hBluePrimaryColor,
                  ),
                  gapW4,
                  Text(
                    "Giỏ hàng (${productController.isInCart.length} sản phẩm)",
                    style: HAppStyle.label3Bold,
                  )
                ],
              ),
              const Icon(
                EvaIcons.arrowIosForward,
                size: 20,
              )
            ],
          ),
          gapH6,
          ProductListStackWidget(
            maxItems: 8,
            items: productController.isInCart
                .map((product) => product.imgPath)
                .toList(),
          ),
        ]),
      ),
      onTap: () => Get.toNamed(HAppRoutes.cart),
    );
  }
}
