import 'package:get/get.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/shop/models/check_box_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
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
            if (product.salePersent != 0) {
              productMoney.value +=
                  (product.priceSale * product.quantity * 0.9).ceil();
            } else {
              productMoney.value +=
                  (product.price * product.quantity * 0.9).ceil();
            }
          } else {
            if (product.salePersent != 0) {
              productMoney.value += product.priceSale * product.quantity;
            } else {
              productMoney.value += product.price * product.quantity;
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
      imgStore = listStore[0].imgStore;
    } else if (name == "Win Mart") {
      imgStore = listStore[1].imgStore;
    } else if (name == "Coop Mart") {
      imgStore = listStore[2].imgStore;
    } else if (name == "Lan Chi Mart") {
      imgStore = listStore[3].imgStore;
    } else if (name == "Aeon Mall") {
      imgStore = listStore[4].imgStore;
    } else if (name == "Mega Mart") {
      imgStore = listStore[5].imgStore;
    } else if (name == "Lotte Mart") {
      imgStore = listStore[6].imgStore;
    } else if (name == "K - Market") {
      imgStore = listStore[7].imgStore;
    }
    return imgStore;
  }

  StoreModel findStoreFromProduct(ProductModel model) {
    for (var store in listStore) {
      if (store.storeId == model.storeId) {
        return store;
      }
    }
    return StoreModel(
        storeId: -1,
        imgStore: '',
        name: '',
        isFavourite: false,
        imgBackground: '',
        category: [],
        rating: -1,
        products: [],
        distance: -1,
        import: false,
        isFamous: false);
  }

  StoreModel findStoreFromStoreName(String name) {
    for (var store in listStore) {
      if (store.name == name) {
        return store;
      }
    }
    return StoreModel(
        storeId: -1,
        imgStore: '',
        name: '',
        isFavourite: false,
        imgBackground: '',
        category: [],
        rating: -1,
        products: [],
        distance: -1,
        import: false,
        isFamous: false);
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
    // ListProducts
    topSellingProducts.value =
        listProducts.where((product) => product.countBuyed > 100).toList();
    topSaleProducts.value =
        listProducts.where((product) => product.salePersent != 0).toList();
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
    // ListFilterProduct
    // listFilterProducts = topSellingProducts;
    // oldList = topSellingProducts;
    // listFilterTopSaleProducts = topSaleProducts;
    // listFilterTopSellingProducts = topSaleProducts;
    // listFilterCate1Products = cate1Products;
    // listFilterCate2Products = cate2Products;
    // listFilterCate3Products = cate3Products;
    // listFilterCate4Products = cate4Products;
    // listFilterCate5Products = cate5Products;
    // listFilterCate6Products = cate6Products;
    // listFilterCate7Products = cate7Products;
    // listFilterCate8Products = cate8Products;
    // listFilterCate9Products = cate9Products;
    // listFilterCate10Products = cate10Products;
    // listFilterCate11Products = cate11Products;
    // listFilterCate12Products = cate12Products;
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

  var selectedValueSort = 'Mới nhất'.obs;
  var checkApplied = false.obs;

  var tagsCategoryObs = <Tag>[].obs;
  var tagsProductObs = <Tag>[].obs;

  var oldList = <ProductModel>[].obs;

  var listFilterProducts = <ProductModel>[].obs;
  var tempListFilterProducts = <ProductModel>[].obs;

  // var listFilterTopSellingProducts = <ProductModel>[].obs;
  // var listFilterTopSaleProducts = <ProductModel>[].obs;
  // var listFilterCate1Products = <ProductModel>[].obs;
  // var listFilterCate2Products = <ProductModel>[].obs;
  // var listFilterCate3Products = <ProductModel>[].obs;
  // var listFilterCate4Products = <ProductModel>[].obs;
  // var listFilterCate5Products = <ProductModel>[].obs;
  // var listFilterCate6Products = <ProductModel>[].obs;
  // var listFilterCate7Products = <ProductModel>[].obs;
  // var listFilterCate8Products = <ProductModel>[].obs;
  // var listFilterCate9Products = <ProductModel>[].obs;
  // var listFilterCate10Products = <ProductModel>[].obs;
  // var listFilterCate11Products = <ProductModel>[].obs;
  // var listFilterCate12Products = <ProductModel>[].obs;

  void filterProduct(RxList<ProductModel> list, int index) {
    if (index > 1) {
      oldList.value = list
          .where((product) =>
              (tagsProductObs[0].active
                  ? findStoreFromProduct(product).distance < 5.0
                  : true) &&
              (tagsProductObs[1].active ? product.rating >= 4.0 : true) &&
              (tagsProductObs[2].active ? product.origin != 'Việt Nam' : true))
          .toList();
    } else {
      oldList.value = list
          .where((product) => tagsCategoryObs.every((category) =>
              category.active
                  ? product.category.contains(category.title)
                  : true))
          .where((product) =>
              (tagsProductObs[0].active
                  ? findStoreFromProduct(product).distance < 5.0
                  : true) &&
              (tagsProductObs[1].active ? product.rating >= 4.0 : true) &&
              (tagsProductObs[2].active ? product.origin != 'Việt Nam' : true))
          .toList();
    }
    listFilterProducts = oldList;
    print('Vào lọc');
    filterProductSort();
  }

  void filterProductSort() {
    print('Vào sort');
    if (selectedValueSort.value == 'Mới nhất') {
      listFilterProducts = oldList;
    } else if (selectedValueSort.value == 'Thấp - Cao') {
      listFilterProducts.sort((a, b) => a.priceSale == 0
          ? (b.priceSale == 0
              ? a.price.compareTo(b.price)
              : a.price.compareTo(b.priceSale))
          : (b.priceSale == 0
              ? a.priceSale.compareTo(b.price)
              : a.priceSale.compareTo(b.priceSale)));
    } else if (selectedValueSort.value == 'Cao - Thấp') {
      listFilterProducts.sort((a, b) => a.priceSale == 0
          ? (b.priceSale == 0
              ? -a.price.compareTo(b.price)
              : -a.price.compareTo(b.priceSale))
          : (b.priceSale == 0
              ? -a.priceSale.compareTo(b.price)
              : -a.priceSale.compareTo(b.priceSale)));
    }
  }
}
