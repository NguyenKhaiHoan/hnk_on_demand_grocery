import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/recent_order_item_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/live_tracking/live_tracking_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/order_detail_screen.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ListAllOrderScreen extends StatelessWidget {
  ListAllOrderScreen({super.key});

  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
            actions: [
              GestureDetector(
                child: const Icon(EvaIcons.refreshOutline),
                onTap: () {
                  orderController.fetchAllOrders();
                },
              ),
              gapW16
            ],
            bottom: const TabBar(
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                isScrollable: true,
                labelStyle: HAppStyle.label3Bold,
                indicatorColor: HAppColor.hBluePrimaryColor,
                labelColor: HAppColor.hBluePrimaryColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Đang hoạt động',
                  ),
                  Tab(
                    text: 'Hoàn thành',
                  ),
                  Tab(
                    text: 'Hủy',
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              FirebaseAnimatedList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  sort: (a, b) {
                    return ((b.value as Map)['OrderDate'] as int)
                        .compareTo(((a.value as Map)['OrderDate'] as int));
                  },
                  scrollDirection: Axis.vertical,
                  query: FirebaseDatabase.instance
                      .ref()
                      .child('Orders')
                      .orderByChild('OrderUserId')
                      .equalTo(UserController.instance.user.value.id),
                  itemBuilder: (context, snapshot, animation, index) {
                    OrderModel order = OrderModel.fromJson(
                        jsonDecode(jsonEncode(snapshot.value))
                            as Map<String, dynamic>);
                    return Container(
                      margin: const EdgeInsets.only(
                          top: hAppDefaultPadding,
                          right: hAppDefaultPadding,
                          left: hAppDefaultPadding,
                          bottom: 0),
                      child: RecentOrderItemWidget(
                        onTap: () {
                          var stepperData =
                              OrderController.instance.listStepData(order);
                          Get.to(() => const LiveTrackingScreen(), arguments: {
                            'order': order,
                            'stepperData': stepperData
                          });
                        },
                        model: order,
                        width: HAppSize.deviceWidth - hAppDefaultPadding * 2,
                      ),
                    );
                  }),
              _buildList("Hoàn thành"),
              _buildList("Hủy"),
            ],
          ),
        ));
  }

  Widget _buildList(String status) {
    return Obx(() {
      if (orderController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: HAppColor.hBluePrimaryColor),
        );
      }
      var orderList = orderController.listOder
          .where((element) => element.orderStatus == status)
          .toList();

      if (orderList.isEmpty) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.all(hAppDefaultPadding),
        child: ListView.builder(
            key: PageStorageKey(status),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var order = orderList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: hAppDefaultPadding),
                child: RecentOrderItemWidget(
                  onTap: () => Get.to(() => OrderDetailScreen(),
                      arguments: {'order': order}),
                  model: order,
                  width: HAppSize.deviceWidth - hAppDefaultPadding * 2,
                ),
              );
            },
            itemCount: orderList.length),
      );
    });
  }
}
