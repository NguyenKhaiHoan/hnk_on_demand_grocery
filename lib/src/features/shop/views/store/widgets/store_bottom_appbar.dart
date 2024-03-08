import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class StoreBottomAppBar extends StatelessWidget implements PreferredSizeWidget {
  StoreBottomAppBar({super.key});

  final storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HAppColor.hBackgroundColor,
      child: TabBar(
          controller: storeController.tabController,
          labelStyle: HAppStyle.label3Bold,
          indicatorColor: HAppColor.hBluePrimaryColor,
          labelColor: HAppColor.hBluePrimaryColor,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(
              text: 'Sản phẩm',
            ),
            Tab(
              text: 'Danh mục',
            ),
            Tab(
              text: 'Thông tin',
            ),
          ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
