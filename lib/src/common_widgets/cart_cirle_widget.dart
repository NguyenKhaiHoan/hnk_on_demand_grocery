import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';

class CartCircle extends StatelessWidget {
  CartCircle({super.key});

  final homeController = HomeController.instance;
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              homeController.openReminder();
              Get.toNamed(HAppRoutes.cart);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: HAppColor.hGreyColorShade300,
                    width: 1.5,
                  ),
                  color: HAppColor.hBackgroundColor),
              child: const Icon(
                EvaIcons.shoppingCart,
                size: 25,
              ),
            )),
        Positioned(
          top: 0,
          right: 0,
          child: Obx(() => AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: cartController.cartProducts.isNotEmpty ? 1 : 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      color: HAppColor.hRedColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                      child: Obx(() => Text(
                            cartController.cartProducts.isNotEmpty
                                ? "${cartController.numberOfCart.value}"
                                : '',
                            style: const TextStyle(
                                fontSize: 10, color: HAppColor.hWhiteColor),
                          ))),
                ),
              )),
        )
      ],
    );
  }
}
