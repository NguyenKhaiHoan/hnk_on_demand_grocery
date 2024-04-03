import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/payment_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';
import 'package:on_demand_grocery/src/repositories/address_repository.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/repositories/order_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/services/firebase_notification_service.dart';
import 'package:on_demand_grocery/src/services/local_service.dart';
import 'package:on_demand_grocery/src/services/messaging_service.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  var toggleAnimation = false.obs;
  var listIdToggleAnimation = [].obs;

  var refreshButton = false.obs;

  static CartController get instance => Get.find();

  CartController() {
    loadCartData();
  }

  var numberOfCart = 0.obs;
  var totalCartPrice = 0.obs;
  var productQuantityInCart = 0.obs;
  var cartProducts = <ProductInCartModel>[].obs;
  // var cartStoreIds = <String>[].obs;

  final orderRepository = Get.put(OrderRepository());

  Future<void> addToCart(ProductModel product) async {
    if (product.status == 'Tạm hết hàng') {
      HAppUtils.showSnackBarWarning(
          'Cảnh báo', 'Sản phẩm ${product.name} này tạm hết hàng');
      return;
    }

    if (productQuantityInCart.value < 1) {
      productQuantityInCart.value += 1;
    }

    final productInCart =
        convertToCartProduct(product, productQuantityInCart.value);

    int productIndex = cartProducts
        .indexWhere((product) => product.productId == productInCart.productId);

    String text = '';
    if (productIndex < 0) {
      cartProducts.add(productInCart);
      addProductToCartMap(productInCart);
      text = 'thêm';
      storeOrderMap[product.storeId] = StoreOrderModel(
        storeId: product.storeId,
        checkChooseInCart: true,
      );
    } else {
      cartProducts[productIndex].quantity = productInCart.quantity;
      text = 'cập nhật';
    }
    refreshButton.toggle();
    updateCart();
    HAppUtils.showSnackBarSuccess('Thành công', 'Bạn đã $text thành công');
    update();
  }

  void updateCart() {
    calculateCart();

    saveCartData();

    cartProducts.refresh();
    productInCartMap.refresh();
    storeOrderMap.refresh();
    update();
  }

  void calculateCart() {
    int totalPrice = 0;
    int number = 0;
    for (var cartProduct in cartProducts) {
      if (storeOrderMap[cartProduct.storeId] != null) {
        if (storeOrderMap[cartProduct.storeId]!.checkChooseInCart == true) {
          totalPrice += cartProduct.price! * cartProduct.quantity;
          if (storeOrderMap[cartProduct.storeId]!.checkChooseInCart) {
            number += cartProduct.quantity;
          }
        }
      }
    }
    totalCartPrice.value = totalPrice;
    numberOfCart.value = number;
    print("Số lượng: ${numberOfCart.value}");
  }

  void addSingleProductInCart(ProductInCartModel productInCart) {
    int productIndex = findIndexProductInCart(productInCart);

    if (productIndex < 0) {
      cartProducts.add(productInCart);
      addProductToCartMap(productInCart);
      updateCart();
    } else {
      cartProducts[productIndex].quantity += 1;
      productQuantityInCart.value = cartProducts[productIndex].quantity;
      updateCart();
    }
    log(numberOfCart.value.toString());
    update();
  }

  int findIndexProductInCart(ProductInCartModel productInCart) {
    return cartProducts
        .indexWhere((product) => product.productId == productInCart.productId);
  }

  void removeSingleProductInCart(ProductInCartModel productInCart) {
    int productIndex = findIndexProductInCart(productInCart);

    if (productIndex >= 0) {
      if (cartProducts[productIndex].quantity > 1) {
        cartProducts[productIndex].quantity -= 1;
        productQuantityInCart.value = cartProducts[productIndex].quantity;
        updateCart();
      } else {
        log('Đã xóa ${productInCart.productName}');
        cartProducts.removeAt(productIndex);
        removeProductFromCartMap(productInCart);
        updateCart();
        toggleAnimation.value = false;
      }
    }
    update();
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartProducts.clear();
    productInCartMap.clear();
    storeOrderMap.clear();
    updateCart();
    update();
  }

  void clearCartWhenCompleteOrder() {
    productQuantityInCart.value = 0;

    storeOrderMap.removeWhere((key, value) => value.checkChooseInCart == true);
    final remainingStoreOrdersIds =
        storeOrderMap.values.map((storeOrder) => storeOrder.storeId).toList();
    final remainingProducts = cartProducts
        .where((product) => remainingStoreOrdersIds.contains(product.storeId))
        .toList();
    cartProducts.assignAll(remainingProducts);

    updateCart();
    cartProducts.clear();
    productInCartMap.clear();
    storeOrderMap.clear();
    update();
  }

  var saveProducts = <ProductInCartModel>[].obs;
  var saveStoreOrders = <StoreOrderModel>[].obs;

  void saveCartData() {
    saveProducts.assignAll(cartProducts);
    saveStoreOrders.assignAll(storeOrderMap.values.toList());

    final cartData = saveProducts.map((element) => element.toJson()).toList();
    HLocalService.instance().saveData('CartProducts', cartData);
    final storeData =
        saveStoreOrders.map((element) => element.toJson()).toList();
    HLocalService.instance().saveData('StoreOrders', storeData);
  }

  void loadCartData() {
    final cartData =
        HLocalService.instance().getData<List<dynamic>>('CartProducts');
    if (cartData != null) {
      cartProducts.assignAll(cartData
          .map((e) => ProductInCartModel.fromJson(e as Map<String, dynamic>)));
      for (var product in cartProducts) {
        if (productInCartMap.containsKey(product.storeId)) {
          productInCartMap[product.storeId]!.add(product);
        } else {
          productInCartMap[product.storeId] = [product];
        }
      }
    }

    final storeData =
        HLocalService.instance().getData<List<dynamic>>('StoreOrders');
    if (storeData != null) {
      final stores = <StoreOrderModel>[];
      stores.assignAll(storeData
          .map((e) => StoreOrderModel.fromJson(e as Map<String, dynamic>)));
      for (var store in stores) {
        storeOrderMap[store.storeId] = store;
      }
    }

    calculateCart();
  }

  ProductInCartModel convertToCartProduct(ProductModel product, int quantity) {
    final price = product.salePersent != 0 ? product.priceSale : product.price;
    return ProductInCartModel(
        productId: product.id,
        productName: product.name,
        image: product.image,
        price: price,
        quantity: quantity,
        storeId: product.storeId,
        storeName: '',
        storeAddress: '',
        unit: product.unit);
  }

  int getProductQuantity(String productId) {
    return cartProducts
        .where((productInCart) => productInCart.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
  }

  void animationButtonAdd(ProductModel model) {
    if (listIdToggleAnimation.isEmpty) {
      listIdToggleAnimation.add(model.id);
      toggleAnimation.value = true;
    } else if (!listIdToggleAnimation.contains(model.id)) {
      listIdToggleAnimation.clear();
      listIdToggleAnimation.add(model.id);
      toggleAnimation.value = true;
    }
    update();
  }

  void removeProduct(ProductInCartModel productInCart) {
    int productIndex = cartProducts
        .indexWhere((product) => product.productId == productInCart.productId);

    if (productIndex >= 0) {
      cartProducts.removeAt(productIndex);
    }
    updateCart();
    update();
  }

  RxBool? groFastvalue = false.obs;

  var voucherAppliedText = "".obs;
  var voucherAppliedSubText = [].obs;
  var voucherCount = 0.obs;
  RxBool? voucherAppliedTextAppear = false.obs;

  noChooseVoucher() {
    groFastvalue!.value = false;
    voucherAppliedText.value = "";
    voucherAppliedSubText.value = [];
    voucherCount.value = 0;
    voucherAppliedTextAppear!.value = false;
    update();
  }

  displayVoucherAppliedText() {
    if (!groFastvalue!.value) {
      voucherAppliedText.value = "";
      voucherAppliedSubText.value = [];
      voucherCount.value = 0;
      voucherAppliedTextAppear!.value = false;
    } else {
      voucherAppliedTextAppear!.value = true;
      voucherAppliedText.value = "";
      String result = "${voucherAppliedSubText.join(", ")}.";
      if (groFastvalue!.value) {
        voucherCount.value = 1;
      }
      voucherAppliedText.value =
          "Bạn đã sử dụng $voucherCount mã ưu đãi: $result";
    }
    update();
  }

  var applied = false.obs;

  void processOrder(String payment) async {
    try {
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      if (totalCartPrice.value < 0) {
        HAppUtils.stopLoading();
        return;
      }

      final storeOrders = storeOrderMap.values
          .where((storeOrder) => storeOrder.checkChooseInCart == true)
          .toList();

      for (var store in storeOrders) {
        final storeAddress =
            await AddressRepository.instance.getStoreAddress(store.storeId);
        final storeInfomation =
            await StoreRepository.instance.getStoreInformation(store.storeId);
        store.address = storeAddress.first.toString();
        store.latitude = storeAddress.first.latitude;
        store.longitude = storeAddress.first.longitude;
        print('${storeAddress.first.latitude} ${storeAddress.first.longitude}');
        store.name = storeInfomation.name;
      }

      final storeOrdersIds = storeOrders.map((e) => e.storeId).toList();

      final productInOrder = cartProducts
          .where((product) => storeOrdersIds.contains(product.storeId))
          .toList();

      final uid = const Uuid().v1();

      final order = OrderModel(
        // oderId: '',
        oderId: uid,
        orderUserId: AuthenticationRepository.instance.authUser!.uid,
        storeOrders: storeOrders,
        orderProducts: productInOrder,
        orderUser: UserController.instance.user.value,
        orderUserAddress: AddressController.instance.selectedAddress.value,
        paymentMethod: payment,
        paymentStatus:
            payment == 'Tiền mặt' ? 'Chưa thanh toán' : 'Đã thanh toán',
        orderDate: DateTime.now(),
        orderStatus: HAppUtils.orderStatus(0), notificationDelivery: [],
        price: getTotalPrice(),
      );

      // final id = await orderRepository.addAndFindIdOfOrder(order);

      // order.oderId = id;
      // await orderRepository.updateOrderField(id, {'OrderId': id});

      final database = FirebaseDatabase.instance.ref();
      database
          .child('Orders/${order.oderId}')
          .set(order.toJson())
          .then((value) {
        HNotificationService.sendNotificationToStore(productInOrder,
            storeOrders, AddressController.instance.selectedAddress.value);
        HAppUtils.showSnackBarSuccess(
            'Thành công', 'Bạn đã đặt hàng thành công');
        clearCartWhenCompleteOrder();
        HAppUtils.stopLoading();
        Get.offNamed(HAppRoutes.complete, arguments: {'order': order});
      }).onError((error, stackTrace) {
        HAppUtils.showSnackBarSuccess('Thất bại',
            'Đã xảy ra sự cố trong quá trình tảii đơn hàng lên hệ thống');
      });
      update();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Thất bại', 'Đặt hàng không thành công');
      update();
    }
  }

  var productInCartMap = <String, List<ProductInCartModel>>{}.obs;
  var storeOrderMap = <String, StoreOrderModel>{}.obs;

  void addProductToCartMap(ProductInCartModel product) {
    if (productInCartMap.containsKey(product.storeId)) {
      productInCartMap[product.storeId]!.add(product);
    } else {
      productInCartMap.addIf(!productInCartMap.keys.contains(product.storeId),
          product.storeId, [product]);
      storeOrderMap.addIf(
          !storeOrderMap.keys.contains(product.storeId),
          product.storeId,
          StoreOrderModel(
            storeId: product.storeId,
            name: product.storeName ?? '',
            address: product.storeAddress ?? '',
            checkChooseInCart: true,
          ));
    }
    update();
  }

  removeProductFromCartMap(ProductInCartModel product) {
    if (productInCartMap.containsKey(product.storeId)) {
      productInCartMap[product.storeId]!.remove(product);
      if (productInCartMap[product.storeId]!.isEmpty) {
        productInCartMap.remove(product.storeId);
        storeOrderMap.remove(product.storeId);
      }
    }
    update();
  }

  TextEditingController noteController = TextEditingController();

  void showModalBottomSheetStoreOrder(
      BuildContext context, StoreOrderModel storeOrder) {
    bool check = false;
    if (storeOrder.note == '') {
      noteController.clear();
    } else {
      noteController.text = storeOrder.note;
    }
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: HAppSize.deviceHeight - 100,
            padding: const EdgeInsets.symmetric(
                vertical: hAppDefaultPadding, horizontal: hAppDefaultPadding),
            decoration: const BoxDecoration(
                color: HAppColor.hBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Thêm ghi chú cho cửa hàng",
                        style: HAppStyle.heading4Style,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(EvaIcons.close))
                    ],
                  ),
                  gapH12,
                  TextFormField(
                    autofocus: true,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      hintText:
                          'Mô tả mong muốn của bạn cho cửa hàng về các sản phẩm được giao. Ví dụ: chú ý về hạn sử dụng, ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: noteController,
                  ),
                  gapH12,
                  ElevatedButton(
                    onPressed: () {
                      check = true;
                      storeOrder.note = noteController.text.trim();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HAppColor.hBluePrimaryColor,
                        fixedSize: Size(
                            HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text("Lưu",
                        style: HAppStyle.label2Bold
                            .copyWith(color: HAppColor.hWhiteColor)),
                  ),
                ]),
          );
        }).then((value) {
      if (!check) {
        if (storeOrder.note == '') {
          noteController.clear();
        } else {
          noteController.text = storeOrder.note;
        }
      }
    });
    update();
  }

  int getDeliveryCost() {
    int deliveryCost = 0;
    return deliveryCost;
  }

  int getDiscountCost() {
    int discoutCost = 0;
    if (groFastvalue!.value) {
      discoutCost = -100000;
    }
    return discoutCost;
  }

  int getPriceWithDiscount() {
    return totalCartPrice.value + getDiscountCost();
  }

  int getTotalPrice() {
    return totalCartPrice.value + getDiscountCost() + getDeliveryCost();
  }
}
