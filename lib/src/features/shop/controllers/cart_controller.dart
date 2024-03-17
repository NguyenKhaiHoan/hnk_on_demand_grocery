import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/payment_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/repositories/order_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/services/firebase_notification_service.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  var toggleAnimation = false.obs;
  var listIdToggleAnimation = [].obs;

  var refreshButton = false.obs;

  static CartController get instance => Get.find();

  var totalCartPrice = 0.obs;
  var productQuantityInCart = 0.obs;
  var cartProducts = <ProductInCartModel>[].obs;
  var cartStoreIds = <String>[].obs;

  final orderRepository = Get.put(OrderRepository());

  void addToCart(ProductModel product) {
    if (product.status == 'Tạm hết hàng') {
      HAppUtils.showSnackBarWarning(
          'Cảnh báo', 'Sản phẩm ${product.name} này tạm hết hàng');
      return;
    }

    cartStoreIds.addIf(
        !cartStoreIds.contains(product.storeId), product.storeId);

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
      text = 'thêm';
    } else {
      cartProducts[productIndex].quantity = productInCart.quantity;
      text = 'cập nhật';
    }
    refreshButton.toggle();
    updateCart();

    HAppUtils.showSnackBarSuccess('Thành công', 'Bạn đã $text thành công');
  }

  void updateCart() {
    int totalPrice = 0;
    for (var cartProduct in cartProducts) {
      totalPrice += cartProduct.price! * cartProduct.quantity;
    }
    totalCartPrice.value = totalPrice;

    cartProducts.refresh();
  }

  int getTotalPriceWithVoucher() {
    final totalPrice = totalCartPrice.value;
    if (groFastvalue!.value) {
      totalCartPrice -= 100000;
    }
    return totalPrice;
  }

  void addSingleProductInCart(ProductInCartModel productInCart) {
    int productIndex = findIndexProductInCart(productInCart);

    cartStoreIds.addIf(
        !cartStoreIds.contains(productInCart.storeId), productInCart.storeId);
    if (productIndex < 0) {
      cartProducts.add(productInCart);
    } else {
      cartProducts[productIndex].quantity += 1;
      productQuantityInCart.value = cartProducts[productIndex].quantity;
    }
    updateCart();
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
      } else {
        cartProducts.removeAt(productIndex);
        cartStoreIds.remove(productInCart.storeId);
        toggleAnimation.value = false;
      }
      updateCart();
    }
  }

  void clearCart() {
    totalCartPrice.value = 0;
    productQuantityInCart.value = 0;
    cartProducts.clear();
    cartProducts.refresh();
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
  }

  void removeProduct(ProductInCartModel productInCart) {
    int productIndex = cartProducts
        .indexWhere((product) => product.productId == productInCart.productId);

    if (productIndex >= 0) {
      cartProducts.removeAt(productIndex);
    }
    updateCart();
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
  }

  var applied = false.obs;

  Rx<PaymentModel> selectPayment = PaymentModel(id: '1', name: 'Cash').obs;

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

      final order = OrderModel(
        oderId: '',
        orderUserId: AuthenticationRepository.instance.authUser!.uid,
        orderStoreIds: cartStoreIds,
        orderProducts: cartProducts,
        orderUser: UserController.instance.user.value,
        orderUserAddress: AddressController.instance.selectedAddress.value,
        paymentMethod: payment,
        paymentStatus: 'Chưa thanh toán',
        orderDate: DateTime.now(),
        orderStatus: 'Đang chờ',
      );

      final id = await orderRepository.addAndFindIdOfOrder(order);

      order.oderId = id;
      await orderRepository.updateOrderField(id, {'OrderId': id});

      final database = FirebaseDatabase.instance.ref();
      database
          .child('Orders/${order.oderId}')
          .set(order.toJson())
          .then((value) {
        HNotificationService.sendNotificationToStore(cartProducts);
        HAppUtils.showSnackBarSuccess(
            'Thành công', 'Bạn đã đặt hàng thành công');
        clearCart();
        HAppUtils.stopLoading();
        Get.toNamed(HAppRoutes.complete);
      }).onError((error, stackTrace) {
        HAppUtils.showSnackBarSuccess('Thất bại',
            'Đã xảy ra sữ cố trong quá trình tảii đơn hàng lên hệ thống');
      });
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Thất bại', 'Đặt hàng không thành công');
    }
  }
}
