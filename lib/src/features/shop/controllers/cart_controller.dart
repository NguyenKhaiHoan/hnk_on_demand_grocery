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
import 'package:on_demand_grocery/src/features/shop/controllers/type_button_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/voucher_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/notification_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_address_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/repositories/address_repository.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/repositories/notification_repository.dart';
import 'package:on_demand_grocery/src/repositories/order_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/repositories/voucher_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/services/local_service.dart';
import 'package:on_demand_grocery/src/services/messaging_service.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  var isReorder = false.obs;

  CartController() {
    loadCartData();
  }

  var toggleAnimation = false.obs;
  var listIdToggleAnimation = [].obs;

  var refreshButton = false.obs;

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
      await addProductToCartMap(productInCart);
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

    if (!isReorder.value) {
      saveCartData();
    } else {}

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
  }

  Future<void> addSingleProductInCart(ProductInCartModel productInCart) async {
    int productIndex = findIndexProductInCart(productInCart);

    if (productIndex < 0) {
      cartProducts.add(productInCart);
      await addProductToCartMap(productInCart);
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
    productQuantityInCart.value = 0;
    if (cartProducts.isNotEmpty &&
        productInCartMap.isNotEmpty &&
        storeOrderMap.isNotEmpty) {
      cartProducts.clear();
      productInCartMap.clear();
      storeOrderMap.clear();
    }

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

  Future<void> loadCartFromOrder(OrderModel order) async {
    try {
      clearCart();

      final cartData = order.orderProducts;
      cartProducts.assignAll(cartData);
      List<String> storeIds = [];

      List<String> listStoreNames = [];
      List<String> listStoreAddessess = [];
      for (var product in cartProducts) {
        if (productInCartMap.containsKey(product.storeId)) {
          productInCartMap[product.storeId]!.add(product);
        } else {
          productInCartMap[product.storeId] = [product];
        }
        String storeAddress = '';
        String storeName = '';
        if (!storeIds.contains(product.storeId)) {
          storeIds.add(product.storeId);
          StoreModel store = await StoreRepository.instance
              .getStoreInformation(product.storeId);
          storeName = store.name;
          listStoreNames.add(storeName);
          List<StoreAddressModel> storeAddresses =
              await AddressRepository.instance.getStoreAddress(product.storeId);
          storeAddress = storeAddresses.first.toString();
          listStoreAddessess.add(storeAddress);
        } else {
          int index = storeIds.indexOf(product.storeId);
          storeName = listStoreNames[index];
          storeAddress = listStoreAddessess[index];
        }

        storeOrderMap.addIf(
            !storeOrderMap.keys.contains(product.storeId),
            product.storeId,
            StoreOrderModel(
              storeId: product.storeId,
              name: storeName,
              address: storeAddress,
              checkChooseInCart: true,
            ));
      }

      calculateCart();
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', 'Không thể đặt lại đơn hàng.');
    }
  }

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

  final notificationRepository = Get.put(NotificationRepository());

  Future<void> processOrder(String paymentMethod, String paymentStatus,
      String orderType, String timeOrder) async {
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
          paymentMethod: paymentMethod,
          paymentStatus: paymentStatus,
          orderDate: DateTime.now(),
          orderStatus: HAppUtils.orderStatus(0),
          notificationDelivery: [],
          price: getTotalPrice(),
          orderType: orderType,
          deliveryCost: getDeliveryCost(),
          discount: getDiscountCost(),
          voucher: voucherController.useVoucher.value.id != ''
              ? voucherController.useVoucher.value
              : VoucherModel.empty(),
          replacedProducts: []);

      if (timeOrder != '') {
        order.timeOrder = timeOrder;
      }

      final database = FirebaseDatabase.instance.ref();
      database
          .child('Orders/${order.oderId}')
          .set(order.toJson())
          .then((value) async {
        await HNotificationService.sendNotificationToStore(productInOrder,
                storeOrders, AddressController.instance.selectedAddress.value)
            .then((value) async {
          var uuid = Uuid();

          String title =
              'Đặt thành công mã đơn hàng #${uid.substring(0, 4)}...';
          String body = 'Bạn đã đặt đơn hàng thành công!';

          HNotificationService.showNotification(
              title: title, body: body, payload: '');
          await notificationRepository.addNotification(
            NotificationModel(
                id: uuid.v1(),
                title: 'Đặt thành công mã đơn hàng #${uid.substring(0, 4)}...',
                body: 'Bạn đã đặt đơn hàng thành công!',
                time: DateTime.now(),
                type: 'order'),
          );
        });

        clearCartWhenCompleteOrder();
        if (voucherController.selectedVoucher.value != '' &&
            voucherController.useVoucher.value.id != '') {
          await VoucherRepository.instance
              .updateVoucher(voucherController.useVoucher.value);
        }
        voucherController.resetVoucher();
        HAppUtils.stopLoading();
        Get.offNamed(HAppRoutes.complete, arguments: {'order': order});
      }).onError((error, stackTrace) {
        HAppUtils.stopLoading();
        HAppUtils.showSnackBarError('Thất bại',
            'Đã xảy ra sự cố trong quá trình tải đơn hàng lên hệ thống: ${error.toString()}');
      });
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Thất bại', 'Đặt hàng không thành công');
    }
  }

  var productInCartMap = <String, List<ProductInCartModel>>{}.obs;
  var storeOrderMap = <String, StoreOrderModel>{}.obs;

  Future<void> addProductToCartMap(ProductInCartModel product) async {
    var storeId = product.storeId;
    if (productInCartMap.containsKey(storeId)) {
      productInCartMap[storeId]!.add(product);
    } else {
      productInCartMap
          .addIf(!productInCartMap.keys.contains(storeId), storeId, [product]);
      var store = await StoreRepository.instance.getStoreInformation(storeId);
      var storeAddress =
          await AddressRepository.instance.getStoreAddress(storeId);
      storeOrderMap.addIf(
          !storeOrderMap.keys.contains(storeId),
          storeId,
          StoreOrderModel(
            storeId: storeId,
            name: store.name,
            address: storeAddress.first.toString(),
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
    final typeButtonController = TypeButtonController.instance;
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

  final voucherController = Get.put(VoucherController());

  int getDiscountCost() {
    int discountCost = 0;

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
      if (storeOrderMap[item.storeId] != null) {
        if (storeOrderMap[item.storeId]!.checkChooseInCart == true) {
          total += (item.replacementProduct?.priceSale ?? item.price!) *
              item.quantity;
          print((item.replacementProduct?.priceSale ?? item.price!) *
              item.quantity);
        }
      }
    }
    return total;
  }

  calculatingDifference(ProductModel product1, int product2Price) {
    if (product1.salePersent == 0) {
      int result = product1.price - product2Price;
      return result >= 0
          ? result == 0
              ? "= ${HAppUtils.vietNamCurrencyFormatting(result)}"
              : "> ${HAppUtils.vietNamCurrencyFormatting(result)}"
          : "< ${HAppUtils.vietNamCurrencyFormatting(result)}";
    } else {
      int result = product1.priceSale - product2Price;
      return result >= 0
          ? result == 0
              ? "= ${HAppUtils.vietNamCurrencyFormatting(result)}"
              : "> ${HAppUtils.vietNamCurrencyFormatting(result)}"
          : "< ${HAppUtils.vietNamCurrencyFormatting(result)}";
    }
  }

  String comparePrice(String s) {
    List<String> parts = s.split(" ");
    if (parts[0] == ">") {
      return ">";
    } else if (parts[0] == "<") {
      return "<";
    } else {
      return "=";
    }
  }

  String comparePriceNumber(String s) {
    List<String> parts = s.split(" ");
    return parts[1];
  }
}
