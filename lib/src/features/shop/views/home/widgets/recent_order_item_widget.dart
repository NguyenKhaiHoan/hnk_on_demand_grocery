import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/features/shop/views/live_tracking/live_tracking_screen.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class RecentOrderItemWidget extends StatelessWidget {
  final Function() onTap;
  final OrderModel model;
  final double width;

  const RecentOrderItemWidget({
    super.key,
    required this.onTap,
    required this.model,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 200,
        decoration: BoxDecoration(
          color: HAppColor.hWhiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(hAppDefaultPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: model.orderStatus == 'Hoàn thành'
                        ? HAppColor.hBluePrimaryColor
                        : model.orderStatus == 'Từ chối'
                            ? HAppColor.hOrangeColor
                            : model.orderStatus == "Hủy"
                                ? HAppColor.hRedColor
                                : HAppColor.hGreyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                      model.orderStatus == 'Hoàn thành'
                          ? 'Hoàn thành'
                          : model.orderStatus == 'Từ chối'
                              ? 'Từ chối'
                              : model.orderStatus == "Hủy"
                                  ? 'Hủy'
                                  : 'Đang hoạt động',
                      style: HAppStyle.label4Regular
                          .copyWith(color: HAppColor.hWhiteColor))),
              GestureDetector(
                onTap: () async {
                  if (model.orderStatus == 'Hoàn thành' ||
                      model.orderStatus == 'Từ chối' ||
                      model.orderStatus == "Hủy") {
                    final cartController = Get.put(CartController());
                    cartController.isReorder.value = true;
                    await cartController.loadCartFromOrder(model);
                    Get.toNamed(HAppRoutes.cart);
                  } else {
                    var stepperData =
                        OrderController.instance.listStepData(model);
                    Get.to(() => const LiveTrackingScreen(), arguments: {
                      'order': model,
                      'stepperData': stepperData
                    });
                  }
                },
                child: model.orderStatus == 'Hoàn thành' ||
                        model.orderStatus == 'Từ chối' ||
                        model.orderStatus == "Hủy"
                    ? Row(
                        children: [
                          const Icon(
                            EvaIcons.refreshOutline,
                            size: 20,
                            color: HAppColor.hBluePrimaryColor,
                          ),
                          gapW4,
                          Text(
                            "Đặt lại",
                            style: HAppStyle.label3Bold
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Icon(
                            EvaIcons.eyeOutline,
                            size: 20,
                            color: HAppColor.hBluePrimaryColor,
                          ),
                          gapW4,
                          Text(
                            "Theo dõi",
                            style: HAppStyle.label3Bold
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          ),
                        ],
                      ),
              )
            ],
          ),
          gapH6,
          Row(children: [
            const Icon(
              Icons.tag,
              size: 15,
            ),
            Text(
              '${model.oderId.substring(0, 15)}...',
              style: HAppStyle.heading5Style,
            )
          ]),
          gapH4,
          Row(
            children: [
              Text(
                DateFormat('EEEE, d-M-y', 'vi').format(model.orderDate!),
                style: HAppStyle.paragraph3Regular
                    .copyWith(color: HAppColor.hGreyColor),
              ),
            ],
          ),
          const Spacer(),
          ProductInCartListStackWidget(
            maxItems: 5,
            items: model.orderProducts,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tổng cộng: ",
                style: HAppStyle.paragraph1Bold,
              ),
              Text(
                HAppUtils.vietNamCurrencyFormatting(model.price),
                style: HAppStyle.heading5Style
                    .copyWith(color: HAppColor.hBluePrimaryColor),
              )
            ],
          )
        ]),
      ),
    );
  }
}
