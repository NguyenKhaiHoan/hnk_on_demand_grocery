import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final rootController = Get.put(RootController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomNavigationBar(
          currentIndex: rootController.currentPage.value,
          onTap: (index) => rootController.animateToScreen(index),
          iconSize: 25.0,
          borderRadius: const Radius.circular(20),
          selectedColor: HAppColor.hBluePrimaryColor,
          strokeColor: HAppColor.hBlueSecondaryColor,
          unSelectedColor: HAppColor.hGreyColorShade600,
          backgroundColor: HAppColor.hWhiteColor,
          items: [
            CustomNavigationBarItem(
              icon: rootController.currentPage.value == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
            ),
            CustomNavigationBarItem(
              icon: rootController.currentPage.value == 1
                  ? const Icon(Icons.search)
                  : const Icon(Icons.search),
            ),
            CustomNavigationBarItem(
              icon: rootController.currentPage.value == 2
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
            ),
            CustomNavigationBarItem(
              icon: rootController.currentPage.value == 3
                  ? const Icon(Icons.store)
                  : const Icon(Icons.store_outlined),
            ),
            CustomNavigationBarItem(
              icon: rootController.currentPage.value == 4
                  ? const Icon(Icons.person_2)
                  : const Icon(Icons.person_2_outlined),
            ),
          ],
        ));
  }
}
