import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/type_button_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/voucher_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../repositories/address_repository_test.dart';
import '../repositories/store_repository_test.dart';
import 'type_button_controller_test.dart';
import 'voucher_controller_test.dart';

class CartControllerTest extends GetxController {
  static CartControllerTest get instance => Get.find();

  var isReorder = false.obs;
  var status = ''.obs;

  FirebaseDatabase firebaseDatabase;

  CartControllerTest({required this.firebaseDatabase});

  var toggleAnimation = false.obs;
  var listIdToggleAnimation = [].obs;

  var refreshButton = false.obs;

  var numberOfCart = 0.obs;
  var totalCartPrice = 0.obs;
  var productQuantityInCart = 0.obs;
  var cartProducts = <ProductInCartModel>[].obs;
  // var cartStoreIds = <String>[].obs;

  // final orderRepository = Get.put(OrderRepository());

  void addToCart(ProductModel product) {
    if (product.status == 'Tạm hết hàng') {
      return;
    }

    if (productQuantityInCart.value < 1) {
      productQuantityInCart.value += 1;
    }

    final productInCart =
        convertToCartProduct(product, productQuantityInCart.value);

    int productIndex = cartProducts
        .indexWhere((product) => product.productId == productInCart.productId);

    if (productIndex < 0) {
      cartProducts.add(productInCart);
      addProductToCartMap(productInCart);
      storeOrderMap[product.storeId] = StoreOrderModel(
        storeId: product.storeId,
        checkChooseInCart: true,
      );
    } else {
      cartProducts[productIndex].quantity = productInCart.quantity;
    }
    refreshButton.toggle();
    updateCart();
    update();
  }

  void updateCart() {
    calculateCart();

    // if (!isReorder.value) {
    //   saveCartData();
    // } else {}

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
          number += cartProduct.quantity;
        }
      }
    }
    totalCartPrice.value = totalPrice;
    numberOfCart.value = number;
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

  // void saveCartData() {
  //   saveProducts.assignAll(cartProducts);
  //   saveStoreOrders.assignAll(storeOrderMap.values.toList());

  //   final cartData = saveProducts.map((element) => element.toJson()).toList();
  //   HLocalService.instance().saveData('CartProducts', cartData);
  //   final storeData =
  //       saveStoreOrders.map((element) => element.toJson()).toList();
  //   HLocalService.instance().saveData('StoreOrders', storeData);
  // }

  // void loadCartData() {
  //   productQuantityInCart.value = 0;
  //   cartProducts.clear();
  //   productInCartMap.clear();
  //   storeOrderMap.clear();

  //   final cartData =
  //       HLocalService.instance().getData<List<dynamic>>('CartProducts');
  //   if (cartData != null) {
  //     cartProducts.assignAll(cartData
  //         .map((e) => ProductInCartModel.fromJson(e as Map<String, dynamic>)));
  //     for (var product in cartProducts) {
  //       if (productInCartMap.containsKey(product.storeId)) {
  //         productInCartMap[product.storeId]!.add(product);
  //       } else {
  //         productInCartMap[product.storeId] = [product];
  //       }
  //     }
  //   }

  //   final storeData =
  //       HLocalService.instance().getData<List<dynamic>>('StoreOrders');
  //   if (storeData != null) {
  //     final stores = <StoreOrderModel>[];
  //     stores.assignAll(storeData
  //         .map((e) => StoreOrderModel.fromJson(e as Map<String, dynamic>)));
  //     for (var store in stores) {
  //       storeOrderMap[store.storeId] = store;
  //     }
  //   }

  //   calculateCart();
  // }

  // void loadCartFromOrder(OrderModel order) {
  //   clearCart();

  //   final cartData = order.orderProducts;
  //   cartProducts.assignAll(cartData);
  //   for (var product in cartProducts) {
  //     if (productInCartMap.containsKey(product.storeId)) {
  //       productInCartMap[product.storeId]!.add(product);
  //     } else {
  //       productInCartMap[product.storeId] = [product];
  //     }

  //     storeOrderMap.addIf(
  //         !storeOrderMap.keys.contains(product.storeId),
  //         product.storeId,
  //         StoreOrderModel(
  //           storeId: product.storeId,
  //           name: product.storeName ?? '',
  //           address: product.storeAddress ?? '',
  //           checkChooseInCart: true,
  //         ));
  //   }

  //   calculateCart();
  // }

  ProductModel convertToProductModel(ProductInCartModel product) {
    return ProductModel(
        id: product.productId,
        name: product.productName!,
        image: product.image!,
        categoryId: '',
        description: '',
        status: '',
        price: product.price!,
        salePersent: 0,
        priceSale: product.price!,
        unit: product.unit!,
        countBuyed: 0,
        rating: 0,
        origin: '',
        storeId: product.storeId,
        uploadTime: DateTime.now());
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

  void replaceProduct(String productId, ProductModel replaceProduct) {
    var product = cartProducts
        .where((productInCart) => productInCart.productId == productId)
        .first;
    if (product.replacementProduct == null) {
      product.addReplacement(replaceProduct);
      return;
    }
    product.replacementProduct = null;
    product.priceDifference = null;
    return;
  }

  bool checkReplaceProduct(String productId, ProductModel replaceProduct) {
    var product = cartProducts
        .where((productInCart) => productInCart.productId == productId)
        .first;

    if (product.replacementProduct != null &&
        product.replacementProduct!.id == replaceProduct.id) {
      return true;
    }
    return false;
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

  Future<void> processOrder(
      String paymentMethod,
      String paymentStatus,
      String orderType,
      String timeOrder,
      UserModel user,
      AddressModel address) async {
    try {
      if (totalCartPrice.value < 0) {
        return;
      }

      final storeOrders = storeOrderMap.values
          .where((storeOrder) => storeOrder.checkChooseInCart == true)
          .toList();

      for (var store in storeOrders) {
        final storeAddress =
            await AddressRepositoryTest.instance.getStoreAddress(store.storeId);
        final storeInfomation = await StoreRepositoryTest.instance
            .getStoreInformation(store.storeId);
        store.address = storeAddress.first.toString();
        store.latitude = storeAddress.first.latitude;
        store.longitude = storeAddress.first.longitude;
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
          orderUserId: '',
          storeOrders: storeOrders,
          orderProducts: productInOrder,
          orderUser: user,
          orderUserAddress: address,
          paymentMethod: paymentMethod,
          paymentStatus: paymentStatus,
          orderDate: DateTime.now(),
          orderStatus: HAppUtils.orderStatus(0),
          notificationDelivery: [],
          price: getTotalPrice(),
          orderType: orderType,
          deliveryCost: getDeliveryCost(),
          discount: getDiscountCost(),
          voucher: VoucherModel.empty(),
          replacedProducts: []);

      if (timeOrder != '') {
        order.timeOrder = timeOrder;
      }

      final database = firebaseDatabase.ref();
      await database
          .child('Orders/${order.oderId}')
          .set(order.toJson())
          .then((value) async {
        status.value = 'Đặt hàng thành công';
        clearCartWhenCompleteOrder();
      }).onError((error, stackTrace) {});
    } catch (e) {
      status.value = 'Đặt đơn hàng không thành công';
      throw e.toString();
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

  int getDeliveryCost() {
    int deliveryCost = 0;
    final typeButtonController = TypeButtonControllerTest.instance;
    if (typeButtonController.orderType == 'dat_lich' &&
        (typeButtonController.timeType == '16:00 - 17:00' ||
            typeButtonController.timeType == '17:00 - 18:00')) {
      deliveryCost += 5000;
    }
    if (typeButtonController.orderType == 'uu_tien') {
      deliveryCost += 10000;
    }
    return deliveryCost;
  }

  int getDiscountCost() {
    int discountCost = 0;
    final voucherController = VoucherControllerTest.instance;
    if (voucherController.selectedVoucher.value != '' &&
        voucherController.useVoucher.value.id != '') {
      final voucher = voucherController.useVoucher.value;
      if (voucher.type == 'Flat') {
        discountCost = voucher.discountValue;
      } else {
        if (voucher.storeId!.isEmpty) {
          discountCost = HAppUtils.roundValue(
              (totalCartPrice.value * (voucher.discountValue / 100)).floor());
        } else {
          int totalPriceInStore = cartProducts
              .where((element) => element.storeId == voucher.storeId)
              .fold(
                  0,
                  (previousValue, element) =>
                      previousValue + element.price! * element.quantity);
          discountCost = HAppUtils.roundValue(
              (totalPriceInStore * (voucher.discountValue / 100)).floor());
        }
      }
    }
    return discountCost;
  }

  int getPriceWithDiscount() {
    return totalCartPrice.value + getDiscountCost();
  }

  int getTotalPrice() {
    return totalCartPrice.value -
                getDiscountCost() +
                getDeliveryCost() +
                getServiceCost() <
            0
        ? 0
        : totalCartPrice.value -
            getDiscountCost() +
            getDeliveryCost() +
            getServiceCost();
  }

  int getServiceCost() {
    return 5000;
  }

  int totalDifference() {
    int difference = 0;
    for (var item in cartProducts) {
      difference += (item.priceDifference ?? 0) * item.quantity;
    }
    return difference;
  }

  int totalCartValue() {
    int total = 0;
    for (var item in cartProducts) {
      total +=
          (item.replacementProduct?.priceSale ?? item.price!) * item.quantity;
    }
    return total;
  }
}
