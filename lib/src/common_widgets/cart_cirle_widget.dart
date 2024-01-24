import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/base/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';

class CartCircle extends StatelessWidget {
  CartCircle({super.key});

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () =>
              {Get.toNamed(HAppRoutes.cart), homeController.openReminder()},
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: HAppColor.hGreyColorShade300,
                width: 1.5,
              ),
            ),
            child: const Icon(
              EvaIcons.shoppingBag,
              size: 25,
            ),
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  color: HAppColor.hRedColor,
                  borderRadius: BorderRadius.circular(100)),
              child: const Center(
                  child: Text(
                "3",
                style: TextStyle(fontSize: 10, color: HAppColor.hWhiteColor),
              )),
            ))
      ],
    );
  }
}
