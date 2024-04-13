import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/recent_order_item_widget.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ListAllOrderScreen extends StatelessWidget {
  ListAllOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            leadingWidth: 80,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: hAppDefaultPadding),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
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
                    child: const Center(
                      child: Icon(
                        EvaIcons.arrowBackOutline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: const Text("Đơn hàng của tôi"),
            centerTitle: true,
            bottom: const TabBar(
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                labelStyle: HAppStyle.label3Bold,
                isScrollable: true,
                indicatorColor: HAppColor.hBluePrimaryColor,
                labelColor: HAppColor.hBluePrimaryColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Đang hoạt dộng',
                  ),
                  Tab(
                    text: 'Hoàn thành',
                  ),
                  Tab(
                    text: 'Từ chối',
                  ),
                  Tab(
                    text: 'Đã hủy',
                  ),
                ]),
          ),
          body: TabBarView(children: [
            // SingleChildScrollView(
            //   child: CustomLayoutWidget(
            //     widget: GridView.builder(
            //       shrinkWrap: true,
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemCount: orderController.listOder.length,
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 1,
            //         crossAxisSpacing: 10.0,
            //         mainAxisSpacing: 10.0,
            //         mainAxisExtent: 190,
            //       ),
            //       itemBuilder: (BuildContext context, int index) {
            //         return RecentOrderItemWidget(
            //             onTap: () {}, model: orderController.listOder[index]);
            //       },
            //     ),
            //     subWidget: Container(),
            //   ),
            // ),
            Container(), Container(), Container(), Container()
          ]),
        ));
  }
}
