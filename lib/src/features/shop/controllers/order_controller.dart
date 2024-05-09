import 'package:another_stepper/dto/stepper_data.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/type_button_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/notification_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/repositories/notification_repository.dart';
import 'package:on_demand_grocery/src/repositories/order_repository.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/services/messaging_service.dart';
import 'package:on_demand_grocery/src/services/payment_service.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  var resetToggle = false.obs;

  var listOder = <OrderModel>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    fetchAllOrders();
    super.onInit();
  }

  Future<void> fetchAllOrders() async {
    try {
      isLoading.value = true;
      final orders = await orderRepository.getAllUserOrder();
      orders.sort((a, b) => b.orderDate!.millisecondsSinceEpoch
          .compareTo(a.orderDate!.millisecondsSinceEpoch));
      listOder.assignAll(orders);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  final orderRepository = Get.put(OrderRepository());

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

  var isOnLiveTracking = false.obs;

  OrderModel updateOrder(
      {required OrderModel order,
      required String status,
      required int activeStep}) {
    FirebaseDatabase.instance
        .ref()
        .child('Orders/${order.oderId}')
        .update({'ActiveStep': activeStep, 'OrderStatus': status});

    order.orderStatus = status;
    order.activeStep = activeStep;
    return order;
  }

  Future<dynamic> removeOrder(String orderId) async {
    await FirebaseDatabase.instance.ref().child('Orders/$orderId').remove();
    await FirebaseDatabase.instance.ref().child('Charts/$orderId').remove();
    isFirstTimeRequest.value = false;
  }

  Future<void> saveOrder(
      {required OrderModel order,
      required String status,
      required int activeStep}) async {
    try {
      Get.back();
      HAppUtils.loadingOverlays();
      var presentId = order.oderId;

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      var orderNew =
          updateOrder(order: order, status: status, activeStep: activeStep);

      final id = await orderRepository.addAndFindIdNewOrder(orderNew);
      orderNew.oderId = id;

      await orderRepository
          .updateOrderField(orderNew.oderId, {'OrderId': orderNew.oderId});

      // removeOrder(presentId);
      // await fetchAllOrders();

      if (orderNew.orderStatus == 'Hoàn thành') {
        Future.forEach(orderNew.orderProducts, (productInCart) async {
          final product = await ProductRepository.instance
              .getProductInformation(productInCart.productId);
          await ProductRepository.instance.updateSingleField(
              productInCart.productId,
              {'CountBuyed': product.countBuyed + productInCart.quantity});
        }).then((value) {
          final notification = Get.put(NotificationRepository());
          var uid = const Uuid();
          String title =
              'Hoàn thành đơn hàng với mã #${orderNew.oderId.substring(0, 4)}...';
          String body =
              'Bạn đã nhận đơn hàng thành công, hãy đánh giá cảm nghĩ của bạn về sản phẩm nhé';
          HNotificationService.showNotification(
              title: title, body: body, payload: '');
          notification.addNotification(NotificationModel(
              id: uid.v1(),
              title: title,
              body: body,
              time: DateTime.now(),
              type: 'order'));
        });
      }

      await removeOrder(presentId).then((value) async {
        await fetchAllOrders();
      });

      resetToggle.toggle();
      HAppUtils.stopLoading();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError(
          'Lỗi', 'Thêm lịch sử đơn hàng mới không thành công');
    }
  }

  Future<void> processOrder() async {
    final addressController = AddressController.instance;
    final typeButtonController = TypeButtonController.instance;
    final cartController = Get.put(CartController());
    if (addressController.selectedAddress.value.phoneNumber == '') {
      HAppUtils.showSnackBarWarning('Cảnh báo',
          'Có vẻ bạn chưa nhập số điện thoại. Hãy nhập số điện thoại để hoàn tất đặt hàng');
      return;
    } else {
      if (typeButtonController.orderType != '' &&
          typeButtonController.paymentMethodType != '') {
        bool status = false;
        String timeOrder = '';
        if (typeButtonController.orderType == 'dat_lich' &&
            typeButtonController.timeType == '') {
          HAppUtils.showSnackBarWarning("Cảnh báo",
              'Bạn chưa chọn thời gian giao hàng cho tùy chọn đặt lịch');
          return;
        }
        if (typeButtonController.orderType == 'dat_lich' &&
            typeButtonController.timeType != '') {
          timeOrder = typeButtonController.timeType;
        }
        if (typeButtonController.paymentMethodType == 'momo_vn') {
          HAppUtils.showSnackBarWarning("Cảnh báo",
              'Tính năng này sẽ được tích hợp sau, vui lòng chọn phương thức thanh toán khác');
          return;
        }
        if (typeButtonController.paymentMethodType == 'tin_dung') {
          status =
              await HPaymentService.makePayment(cartController.getTotalPrice());
          if (!status) {
            HAppUtils.showSnackBarWarning("Cảnh báo", 'Bạn chưa thanh toán');
            return;
          }
        }

        await cartController.processOrder(
            typeButtonController.paymentMethodType,
            status ? 'Đã thanh toán' : 'Chưa thanh toán',
            typeButtonController.orderType,
            timeOrder);
      } else {
        if (typeButtonController.orderType == '') {
          HAppUtils.showSnackBarWarning(
              "Cảnh báo", 'Bạn chưa chọn phương thức giao hàng');
        } else if (typeButtonController.paymentMethodType == '') {
          HAppUtils.showSnackBarWarning(
              "Cảnh báo", 'Bạn chưa chọn phương thức giao hàng thanh toán');
        }
      }
    }
  }

  int totalDifference(OrderModel order) {
    int difference = 0;

    if (order.replacedProducts != null) {
      print('Không null');

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
