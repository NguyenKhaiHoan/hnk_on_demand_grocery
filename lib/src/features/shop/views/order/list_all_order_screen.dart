import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/recent_oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/recent_order_item_widget.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ListAllOrderScreen extends StatelessWidget {
  const ListAllOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
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
                        borderRadius: BorderRadius.circular(100),
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
                    text: 'Tất cả',
                  ),
                  Tab(
                    text: 'Đang chờ',
                  ),
                  Tab(
                    text: 'Chưa giao',
                  ),
                  Tab(
                    text: 'Đang giao',
                  ),
                  Tab(
                    text: 'Đã giao',
                  ),
                  Tab(
                    text: 'Đã hủy',
                  )
                ]),
          ),
          body: TabBarView(children: [
            SingleChildScrollView(
              child: CustomLayoutWidget(
                widget: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listOder.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 190,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return RecentOrderItemWidget(
                        onTap: () {}, model: listOder[index]);
                  },
                ),
                subWidget: Container(),
              ),
            ),
            Container(),
            Container(),
            SingleChildScrollView(
              child: CustomLayoutWidget(
                widget: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listOder
                      .where((order) => order.active == "Đang giao")
                      .toList()
                      .length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 190,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return RecentOrderItemWidget(
                        onTap: () {},
                        model: listOder
                            .where((order) => order.active == "Đang giao")
                            .toList()[index]);
                  },
                ),
                subWidget: Container(),
              ),
            ),
            SingleChildScrollView(
              child: CustomLayoutWidget(
                widget: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listOder
                      .where((order) => order.active == "Đã giao")
                      .toList()
                      .length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 190,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return RecentOrderItemWidget(
                        onTap: () {},
                        model: listOder
                            .where((order) => order.active == "Đã giao")
                            .toList()[index]);
                  },
                ),
                subWidget: Container(),
              ),
            ),
            SingleChildScrollView(
              child: CustomLayoutWidget(
                widget: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listOder
                      .where((order) => order.active == "Đã hủy")
                      .toList()
                      .length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 190,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return RecentOrderItemWidget(
                        onTap: () {},
                        model: listOder
                            .where((order) => order.active == "Đã hủy")
                            .toList()[index]);
                  },
                ),
                subWidget: Container(),
              ),
            ),
          ]),
        ));
  }
}
