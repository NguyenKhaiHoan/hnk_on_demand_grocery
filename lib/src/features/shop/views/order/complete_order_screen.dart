import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_infomation_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CompleteCheckoutScreen extends StatefulWidget {
  const CompleteCheckoutScreen({super.key});

  @override
  State<CompleteCheckoutScreen> createState() => _CompleteCheckoutScreenState();
}

class _CompleteCheckoutScreenState extends State<CompleteCheckoutScreen> {
  OrderModel order = Get.arguments['order'];

  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return CustomLayoutInformationScreenWidget(
        lottieImage: 'assets/animations/complete_checkout.json',
        title: 'Đặt hàng thành công!',
        widget1: ElevatedButton(
          onPressed: () {
            final stepperData = orderController.listStepData(order);
            Get.toNamed(HAppRoutes.liveTracking,
                arguments: {'order': order, 'stepperData': stepperData});
            ExploreController.instance.dispose();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(HAppSize.deviceWidth * 0.5, 50),
            backgroundColor: HAppColor.hBluePrimaryColor,
          ),
          child: Text(
            "Theo dõi Đơn hàng",
            style: HAppStyle.label2Bold.copyWith(color: HAppColor.hWhiteColor),
          ),
        ),
        widget2: OutlinedButton(
            onPressed: () {
              // OrderController.instance.fetchAllOrders();
              OrderController.instance.resetToggle.toString();
              Get.offAllNamed(HAppRoutes.root);
            },
            style: ElevatedButton.styleFrom(
                minimumSize: Size(HAppSize.deviceWidth * 0.5, 50),
                backgroundColor: HAppColor.hBackgroundColor,
                side:
                    BorderSide(width: 2, color: HAppColor.hGreyColorShade300)),
            child: const Text(
              "Tiếp tục Mua sắm",
              style: HAppStyle.label2Bold,
            )),
        subTitle:
            'Đơn hàng của bạn đã được đặt và bạn sẽ có thể nhận được hàng sớm nhất.');
  }
}
