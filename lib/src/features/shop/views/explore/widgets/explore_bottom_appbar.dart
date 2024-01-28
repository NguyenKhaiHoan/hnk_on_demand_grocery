import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ExploreBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  ExploreBottomAppBar({super.key});

  final exploreController = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HAppColor.hBackgroundColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TabBar(
                  controller: exploreController.tabController,
                  labelStyle: HAppStyle.label3Bold,
                  isScrollable: true,
                  indicatorColor: HAppColor.hBluePrimaryColor,
                  labelColor: HAppColor.hBluePrimaryColor,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Bán chạy',
                    ),
                    Tab(
                      text: 'Giảm giá',
                    ),
                    Tab(
                      text: 'Trái cây',
                    ),
                    Tab(
                      text: 'Rau củ',
                    ),
                    Tab(
                      text: 'Thịt',
                    ),
                    Tab(
                      text: 'Hải sản',
                    ),
                    Tab(
                      text: 'Trứng',
                    ),
                    Tab(
                      text: 'Sữa',
                    ),
                    Tab(
                      text: 'Gia vị',
                    ),
                    Tab(
                      text: 'Hạt',
                    ),
                    Tab(
                      text: 'Bánh mỳ',
                    ),
                    Tab(
                      text: 'Đồ uống',
                    ),
                    Tab(
                      text: 'Ăn vặt',
                    ),
                    Tab(
                      text: 'Mỳ & Gạo',
                    ),
                  ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: HAppColor.hBackgroundColor,
                height: 48,
                width: 48,
                child: const Center(
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
