import 'package:get/get.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/shop/models/check_box_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  @override
  void onInit() {
    getAllProducts();
    super.onInit();
  }

  @override
  void onReady() {
    getExploreProducts();
    getProductsAllStore();
    super.onReady();
  }

  List<ProductModel> checkStore(StoreModel model) {
    if (model.name == "Big C") {
      return bigcstore;
    } else if (model.name == "Win Mart") {
      return winmartstore;
    } else if (model.name == "Coop Mart") {
      return coopmartstore;
    } else if (model.name == "Lan Chi Mart") {
      return lanchistore;
    } else if (model.name == "Aeon Mall") {
      return aeonstore;
    } else if (model.name == "Mega Mart") {
      return megastore;
    }
    return lottestore;
  }

  StoreModel checkProductInStore(ProductModel product) {
    if (bigcstore.contains(product)) {
      return listStore[0];
    }
    if (winmartstore.contains(product)) {
      return listStore[1];
    }
    if (coopmartstore.contains(product)) {
      return listStore[2];
    }
    if (lanchistore.contains(product)) {
      return listStore[3];
    }
    if (aeonstore.contains(product)) {
      return listStore[4];
    }
    if (megastore.contains(product)) {
      return listStore[5];
    }
    return listStore[6];
  }

  RxBool? groFastvalue = false.obs;
  RxBool? bigCValue = false.obs;

  var voucherAppliedText = "".obs;
  var voucherAppliedSubText = [].obs;
  var voucherCount = 0.obs;
  RxBool? voucherAppliedTextAppear = false.obs;

  var isInCart = <ProductModel>[].obs;

  var productInCart = <String, RxList<ProductModel>>{}.obs;

  var wishlistList = <Wishlist>[].obs;

  findSubtitleWishList(String title) {
    String subTitle = "";
    for (var wishlist in wishlistList) {
      if (wishlist.title == title) {
        subTitle = wishlist.subTitle;
      }
    }
    return subTitle;
  }

  addMapProductInWishList() {
    productInWishList.clear();
    for (var wishlist in wishlistList) {
      if (!productInWishList.containsKey(wishlist.title)) {
        productInWishList.addAll({
          wishlist.title: RxList.from(listProducts
              .where((productIsInWishList) =>
                  productIsInWishList.wishlistName.contains(wishlist.title))
              .toList())
        });
      } else {
        productInWishList.update(
            wishlist.title,
            (value) => RxList.from(listProducts
                .where((productIsInWishList) =>
                    productIsInWishList.wishlistName.contains(wishlist.title))
                .toList()));
      }
      update();
    }
  }

  var productInWishList = <String, RxList<ProductModel>>{}.obs;

  noChooseVoucher() {
    groFastvalue!.value = false;
    bigCValue!.value = false;
    voucherAppliedText.value = "";
    voucherAppliedSubText.value = [];
    voucherCount.value = 0;
    voucherAppliedTextAppear!.value = false;
  }

  displayVoucherAppliedText() {
    if (!groFastvalue!.value && !bigCValue!.value) {
      voucherAppliedText.value = "";
      voucherAppliedSubText.value = [];
      voucherCount.value = 0;
      voucherAppliedTextAppear!.value = false;
    } else {
      voucherAppliedTextAppear!.value = true;
      voucherAppliedText.value = "";
      String result = "${voucherAppliedSubText.join(", ")}.";
      if (groFastvalue!.value && bigCValue!.value) {
        voucherCount.value = 2;
      } else if (groFastvalue!.value && !bigCValue!.value) {
        voucherCount.value = 1;
      } else if (!groFastvalue!.value && bigCValue!.value) {
        voucherCount.value = 1;
      } else {
        voucherCount.value = 0;
      }
      voucherAppliedText.value =
          "Bạn đã sử dụng $voucherCount mã ưu đãi: $result";
    }
  }

  changeAllChoose() {
    if (isInCart.isNotEmpty) {
      allChooseBool.value = !allChooseBool.value;
      for (var element in chooseList) {
        element.value = allChooseBool.value;
      }
    }
    update();
  }

  var allChooseBool = true.obs;

  var applied = false.obs;

  addProductInCart(ProductModel product) {
    isInCart.addIf(
        !isInCart.contains(product) && product.status == "", product);
    update();
  }

  removeAllProductInCart() {
    for (var element in isInCart) {
      element.quantity = 0;
    }
    isInCart.clear();
    update();
  }

  removeAllChooseList() {
    chooseList.clear();
    update();
  }

  addMapProductInCart() {
    productInCart.clear();
    for (var product in isInCart) {
      if (!productInCart.containsKey(product.nameStore)) {
        productInCart.addAll({
          product.nameStore: RxList.from(isInCart
              .where((productIsInCart) =>
                  productIsInCart.nameStore == product.nameStore)
              .toList())
        });
      } else {
        productInCart.update(
            product.nameStore,
            (value) => RxList.from(isInCart
                .where((productIsInCart) =>
                    productIsInCart.nameStore == product.nameStore)
                .toList()));
      }
      update();
    }
    removeAllChooseList();
    for (var storeName in productInCart.keys) {
      String imgStore = findImgStore(storeName);
      chooseList.add(CheckBoxStoreModel(
          title: storeName, imgStore: imgStore, value: true));
    }
    sumProductMoney();
    update();
  }

  var productMoney = 0.obs;

  checkBigCVoucher() {
    for (var product in isInCart) {
      for (var choose in chooseList) {
        if (product.imgStore == choose.imgStore && choose.value == true) {
          if (bigCValue!.value == true &&
              product.nameStore == "Big C" &&
              product.category == "Trái cây") {
            return true;
          }
        }
      }
    }
    return false;
  }

  sumProductMoney() {
    productMoney.value = 0;
    for (var product in isInCart) {
      for (var choose in chooseList) {
        if (product.imgStore == choose.imgStore && choose.value == true) {
          if (bigCValue!.value == true &&
              product.nameStore == "Big C" &&
              product.category == "Trái cây" &&
              applied.value) {
            if (product.salePersent != "") {
              productMoney.value += (int.parse(product.priceSale
                          .substring(0, product.priceSale.length - 5)) *
                      product.quantity *
                      0.9)
                  .ceil();
            } else {
              productMoney.value += (int.parse(product.price
                          .substring(0, product.price.length - 5)) *
                      product.quantity *
                      0.9)
                  .ceil();
            }
          } else {
            if (product.salePersent != "") {
              productMoney.value += int.parse(product.priceSale
                      .substring(0, product.priceSale.length - 5)) *
                  product.quantity;
            } else {
              productMoney.value += int.parse(
                      product.price.substring(0, product.price.length - 5)) *
                  product.quantity;
            }
          }
        }
      }
    }
    if (groFastvalue!.value == true &&
        productMoney.value >= 200 &&
        applied.value) {
      productMoney.value = productMoney.value - 100;
    }
  }

  findImgStore(String name) {
    String imgStore = "";
    if (name == "Big C") {
      imgStore = imgStores[0];
    } else if (name == "Win Mart") {
      imgStore = imgStores[1];
    } else if (name == "Coop Mart") {
      imgStore = imgStores[2];
    } else if (name == "Lan Chi Mart") {
      imgStore = imgStores[3];
    } else if (name == "Aeon Mall") {
      imgStore = imgStores[4];
    } else if (name == "Mega Mart") {
      imgStore = imgStores[5];
    } else if (name == "Lotte Mart") {
      imgStore = imgStores[6];
    }
    return imgStore;
  }

  refreshList(RxList<ProductModel> list) {
    list.refresh();
    update();
  }

  refreshAllList() {
    listProducts.refresh();
    getExploreProducts();
    update();
  }

  var listProducts = <ProductModel>[].obs;
  var topSellingProducts = <ProductModel>[].obs;
  var topSaleProducts = <ProductModel>[].obs;
  var cate1Products = <ProductModel>[].obs;
  var cate2Products = <ProductModel>[].obs;
  var cate3Products = <ProductModel>[].obs;
  var cate4Products = <ProductModel>[].obs;
  var cate5Products = <ProductModel>[].obs;
  var cate6Products = <ProductModel>[].obs;
  var cate7Products = <ProductModel>[].obs;
  var cate8Products = <ProductModel>[].obs;
  var cate9Products = <ProductModel>[].obs;
  var cate10Products = <ProductModel>[].obs;
  var cate11Products = <ProductModel>[].obs;
  var cate12Products = <ProductModel>[].obs;
  var isFavoritedProducts = <ProductModel>[].obs;
  var comparePriceProducts = <ProductModel>[].obs;
  var registerNotificationProducts = <ProductModel>[].obs;

  addRegisterNotificationProducts(ProductModel product) {
    if (registerNotificationProducts.contains(product)) {
      registerNotificationProducts.remove(product);
    } else {
      registerNotificationProducts.add(product);
    }
    update();
  }

  addProductInFavorited(ProductModel product) {
    if (isFavoritedProducts.contains(product)) {
      isFavoritedProducts.remove(product);
    } else {
      isFavoritedProducts.add(product);
    }
    update();
  }

  void getComparePriceProduct(ProductModel model) {
    if (comparePriceProducts.isNotEmpty) {
      comparePriceProducts.clear();
    }
    comparePriceProducts.value = listProducts
        .where((product) => product.name == model.name && product != model)
        .toList();
  }

  void getAllProducts() {
    listProducts.value = DummyData.getAllProducts();
  }

  void getExploreProducts() {
    topSellingProducts.value = listProducts
        .where((product) => int.parse(product.countBuyed) > 100)
        .toList();
    topSaleProducts.value =
        listProducts.where((product) => product.salePersent != "").toList();
    cate1Products.value = listProducts
        .where((product) => product.category == "Trái cây")
        .toList();
    cate2Products.value =
        listProducts.where((product) => product.category == "Rau củ").toList();
    cate3Products.value =
        listProducts.where((product) => product.category == "Thịt").toList();
    cate4Products.value =
        listProducts.where((product) => product.category == "Hải sản").toList();
    cate5Products.value =
        listProducts.where((product) => product.category == "Trứng").toList();
    cate6Products.value =
        listProducts.where((product) => product.category == "Sữa").toList();
    cate7Products.value =
        listProducts.where((product) => product.category == "Gia vị").toList();
    cate8Products.value =
        listProducts.where((product) => product.category == "Hạt").toList();
    cate9Products.value =
        listProducts.where((product) => product.category == "Bánh mỳ").toList();
    cate10Products.value =
        listProducts.where((product) => product.category == "Đồ uống").toList();
    cate11Products.value =
        listProducts.where((product) => product.category == "Ăn vặt").toList();
    cate12Products.value = listProducts
        .where((product) => product.category == "Mỳ & Gạo")
        .toList();
  }

  var bigcstore = <ProductModel>[].obs;
  var coopmartstore = <ProductModel>[].obs;
  var winmartstore = <ProductModel>[].obs;
  var lanchistore = <ProductModel>[].obs;
  var aeonstore = <ProductModel>[].obs;
  var megastore = <ProductModel>[].obs;
  var lottestore = <ProductModel>[].obs;

  void getProductsAllStore() {
    bigcstore.value = listProducts
        .where((product) => product.imgStore == listStore[0].imgStore)
        .toList();
    coopmartstore.value = listProducts
        .where((product) => product.imgStore == listStore[1].imgStore)
        .toList();

    winmartstore.value = listProducts
        .where((product) => product.imgStore == listStore[2].imgStore)
        .toList();

    lanchistore.value = listProducts
        .where((product) => product.imgStore == listStore[3].imgStore)
        .toList();

    aeonstore.value = listProducts
        .where((product) => product.imgStore == listStore[4].imgStore)
        .toList();

    megastore.value = listProducts
        .where((product) => product.imgStore == listStore[5].imgStore)
        .toList();

    lottestore.value = listProducts
        .where((product) => product.imgStore == listStore[6].imgStore)
        .toList();
  }

  var wishListProduct = <ProductModel>[].obs;
}
