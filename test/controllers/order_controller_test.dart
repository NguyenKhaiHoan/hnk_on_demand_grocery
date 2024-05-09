import 'package:another_stepper/dto/stepper_data.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/services/payment_service.dart';

import '../repositories/order_repository_test.dart';
import 'cart_controller_test.dart';
import 'type_button_controller_test.dart';

class OrderControllerTest extends GetxController {
  static OrderControllerTest get instance => Get.find();

  final orderRepository = OrderRepositoryTest.instance;

  var statusOrder = 'Đã xong kiểm tra các điều kiện đơn hàng'.obs;

  var isFirstTimeRequest = false.obs;

  List<StepperData> listStepData(OrderModel order) {
    List<StepperData> stepperData = [];
    stepperData.addAll(order.storeOrders.map((e) {
      return StepperData(
          title: StepperText(
            "Lấy: ${e.name}",
          ),
          subtitle: StepperText(e.address),
          iconWidget: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: HAppColor.hBluePrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: const Center(
              child: Icon(Icons.storefront_outlined,
                  size: 14, color: HAppColor.hWhiteColor),
            ),
          ));
    }));
    stepperData.add(StepperData(
        title: StepperText("Giao: ${order.orderUser.name}"),
        subtitle: StepperText(order.orderUserAddress.toString()),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: HAppColor.hBluePrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: const Center(
            child: Icon(EvaIcons.homeOutline,
                size: 14, color: HAppColor.hWhiteColor),
          ),
        )));
    return stepperData;
  }

  Future<void> processOrder(UserModel user, AddressModel address) async {
    final typeButtonController = TypeButtonControllerTest.instance;
    final cartController = CartControllerTest.instance;
    if (address.phoneNumber == '') {
      statusOrder.value =
          'Có vẻ bạn chưa nhập số điện thoại. Hãy nhập số điện thoại để hoàn tất đặt hàng';
      return;
    } else {
      if (typeButtonController.orderType != '' &&
          typeButtonController.paymentMethodType != '') {
        bool status = false;
        String timeOrder = '';
        if (typeButtonController.orderType == 'dat_lich' &&
            typeButtonController.timeType == '') {
          statusOrder.value =
              'Bạn chưa chọn thời gian giao hàng cho tùy chọn đặt lịch';
          return;
        }
        if (typeButtonController.orderType == 'dat_lich' &&
            typeButtonController.timeType != '') {
          timeOrder = typeButtonController.timeType;
        }
        if (typeButtonController.paymentMethodType == 'momo_vn') {
          statusOrder.value =
              'Tính năng này sẽ được tích hợp sau, vui lòng chọn phương thức thanh toán khác';
          return;
        }
        if (typeButtonController.paymentMethodType == 'tin_dung') {
          status =
              await HPaymentService.makePayment(cartController.getTotalPrice());
          if (!status) {
            statusOrder.value = 'Bạn chưa thanh toán';
            return;
          }
        }

        await cartController.processOrder(
            typeButtonController.paymentMethodType,
            status ? 'Đã thanh toán' : 'Chưa thanh toán',
            typeButtonController.orderType,
            timeOrder,
            user,
            address);
      } else {
        if (typeButtonController.orderType == '') {
          statusOrder.value = 'Bạn chưa chọn phương thức giao hàng';
        } else if (typeButtonController.paymentMethodType == '') {
          statusOrder.value = 'Bạn chưa chọn phương thức giao hàng thanh toán';
        }
      }
    }
  }

  int totalDifference(OrderModel order) {
    int difference = 0;

    if (order.replacedProducts != null) {
      for (var product in order.replacedProducts!) {
        difference += (product.priceDifference ?? 0) * product.quantity;
      }
      return difference;
    }
    return difference;
  }

  int totalCartValue(List<ProductInCartModel> products) {
    int total = 0;
    for (var product in products) {
      total += (product.replacementProduct?.priceSale ?? product.price!) *
          product.quantity;
    }
    return total;
  }
}
