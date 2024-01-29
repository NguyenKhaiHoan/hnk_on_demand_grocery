import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  WishlistBottomAppBar({super.key});

  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HAppColor.hBackgroundColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TabBar(
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
                    Tab(
                      text: 'Cửa hàng (${isFavoritedStore.length})',
                    ),
                  ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: HAppColor.hBackgroundColor,
                height: 48,
                width: 48,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(EvaIcons.options2Outline),
                )),
              ),
            ),
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
