import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class CartController extends GetxController {
  var toggleAnimation = false.obs;
  var listIdToggleAnimation = [].obs;

  var refreshButton = false.obs;

  static CartController get instance => Get.find();

  var totalCartPrice = 0.obs;
  var productQuantityInCart = 0.obs;
  var cartProducts = <ProductInCartModel>[].obs;

  void addToCart(ProductModel product) {
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
    if (groFastvalue!.value) {
      totalPrice -= 100000;
    }
    totalCartPrice.value = totalPrice;

    cartProducts.refresh();
  }

  void addSingleProductInCart(ProductInCartModel productInCart) {
    int productIndex = findIndexProductInCart(productInCart);

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
    int productIndex = cartProducts
        .indexWhere((product) => product.productId == productInCart.productId);

    if (productIndex >= 0) {
      if (cartProducts[productIndex].quantity > 1) {
        cartProducts[productIndex].quantity -= 1;
        productQuantityInCart.value = cartProducts[productIndex].quantity;
      } else {
        cartProducts.removeAt(productIndex);
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
        categoryId: product.categoryId);
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
}
