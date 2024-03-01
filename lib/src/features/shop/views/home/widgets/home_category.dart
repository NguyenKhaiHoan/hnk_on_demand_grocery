import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/bumble_scroll_bar_flutter.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/category_menu.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategory extends StatelessWidget {
  HomeCategory({super.key});

  final categoryController = Get.put(CategoryController());
  final exploreController = Get.put(ExploreController());
  final rootController = Get.put(RootController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => categoryController.isLoading.value
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CustomBumbleScrollbar(heightContent: 210, child: itemGrid()),
          )
        : CustomBumbleScrollbar(heightContent: 210, child: itemGrid()));
  }

  Widget itemGrid() {
    return SizedBox(
      width: HAppSize.deviceWidth * 1.8,
      child: GridView.builder(
        itemCount: categoryController.listOfCategory.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            mainAxisExtent: 90,
            crossAxisCount: 9,
            childAspectRatio: 1),
        itemBuilder: (context, index) {
          return CategoryMenu(
            onTap: () {
              rootController.animateToScreen(1);
              exploreController.animateToTab(index + 2);
            },
            model: categoryController.listOfCategory[index],
          );
        },
      ),
    );
  }
}
