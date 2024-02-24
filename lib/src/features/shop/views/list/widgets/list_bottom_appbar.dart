import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ListBottomAppBar extends StatelessWidget implements PreferredSizeWidget {
  ListBottomAppBar({super.key});

  final productController = Get.put(ProductController());
  final storeController = Get.put(StoreController());
  final wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HAppColor.hBackgroundColor,
        child: TabBar(
            controller: wishlistController.tabController,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            labelStyle: HAppStyle.label3Bold,
            isScrollable: true,
            indicatorColor: HAppColor.hBluePrimaryColor,
            labelColor: HAppColor.hBluePrimaryColor,
            unselectedLabelColor: Colors.black,
            tabs: [
              Obx(() => Tab(
                    text:
                        'Sản phẩm (${productController.isFavoritedProducts.length})',
                  )),
              Obx(() => Tab(
                    text:
                        'Cửa hàng (${storeController.isFavoritedStores.length})',
                  )),
              Obx(() => Tab(
                    text: 'Mong ước (${productController.wishlistList.length})',
                  )),
              Obx(() => Tab(
                    text:
                        'Chờ có hàng (${productController.registerNotificationProducts.length})',
                  )),
            ]));
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
