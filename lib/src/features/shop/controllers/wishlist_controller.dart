import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/result_wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/repositories/wishlist_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class WishlistController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var refreshWishlistItemData = false.obs;

  static WishlistController get instance => Get.find();

  final wishlistRepository = Get.put(WishlistRepository());

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();

  GlobalKey<FormState> addWishlistFormKey = GlobalKey<FormState>();

  var refreshFavoriteData = false.obs;
  var refreshRegisterNotificationData = false.obs;
  var refreshFavoriteStoreData = false.obs;
  var refreshWishlistData = false.obs;

  final userController = UserController.instance;
  final productRepository = Get.put(ProductRepository());

  var isLoading = false.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 4);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  animateToTab(int index) {
    tabController.animateTo(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void resetForm() {
    titleController.clear();
    subtitleController.clear();
  }

  Future<List<ProductModel>> fetchAllFavoriteProductList() async {
    try {
      final listIds = userController.user.value.listOfFavoriteProduct;
      final products = await productRepository.getProductsFromListIds(listIds!);
      return products;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  Future openCreateFormWishlish() => showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: HAppColor.hBackgroundColor,
            title: const Text('Tạo danh sách mong ước'),
            content: Form(
                key: addWishlistFormKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    enableSuggestions: true,
                    autocorrect: true,
                    controller: titleController,
                    validator: (value) =>
                        HAppUtils.validateEmptyField('Tiêu đề', value),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Nhập tiêu đề',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  gapH12,
                  TextFormField(
                    keyboardType: TextInputType.text,
                    enableSuggestions: true,
                    autocorrect: true,
                    controller: subtitleController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Nhập mô tả (tùy chọn)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ])),
            actions: [
              TextButton(
                  onPressed: () async {
                    addWishlist();
                    Get.back();
                  },
                  child: Text('Tạo',
                      style: HAppStyle.label3Bold
                          .copyWith(color: HAppColor.hDarkColor)))
            ],
          ));

  void addOrRemoveProductInFavoriteList(String productId) async {
    try {
      final listIds = userController.user.value.listOfFavoriteProduct;
      if (!listIds!.contains(productId)) {
        userController.user.value.listOfFavoriteProduct!.add(productId);
      } else {
        userController.user.value.listOfFavoriteProduct!.remove(productId);
      }
      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        return;
      }
      userController.user.refresh();
      await UserRepository.instance.updateSingleField({
        'ListOfFavoriteProduct': userController.user.value.listOfFavoriteProduct
      });
      refreshFavoriteData.toggle();
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  Future<List<StoreModel>> fetchAllFavoriteStoreList() async {
    try {
      final listIds = userController.user.value.listOfFavoriteStore;
      final stores = await productRepository.getStoresFromListIds(listIds!);
      return stores;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  void addOrRemoveStoreInFavoriteList(String storeId) async {
    try {
      final listIds = userController.user.value.listOfFavoriteStore;
      if (!listIds!.contains(storeId)) {
        userController.user.value.listOfFavoriteStore!.add(storeId);
      } else {
        userController.user.value.listOfFavoriteStore!.remove(storeId);
      }
      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        return;
      }
      userController.user.refresh();
      await UserRepository.instance.updateSingleField({
        'ListOfFavoriteStore': userController.user.value.listOfFavoriteStore
      });
      refreshFavoriteStoreData.toggle();
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  Future<List<ProductModel>> fetchAllRegisterNotificationProductList() async {
    try {
      final listIds =
          userController.user.value.listOfRegisterNotificationProduct;
      final products = await productRepository.getProductsFromListIds(listIds!);
      return products;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  void addOrRemoveProductInRegisterNotificationList(String productId) async {
    try {
      final listIds =
          userController.user.value.listOfRegisterNotificationProduct;
      if (!listIds!.contains(productId)) {
        userController.user.value.listOfRegisterNotificationProduct!
            .add(productId);
      } else {
        userController.user.value.listOfRegisterNotificationProduct!
            .remove(productId);
      }
      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        return;
      }
      userController.user.refresh();
      await UserRepository.instance.updateSingleField({
        'ListOfRegisterNotificationProduct':
            userController.user.value.listOfRegisterNotificationProduct
      });
      refreshRegisterNotificationData.toggle();
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  Future<List<WishlistModel>> fetchAllWishlist() async {
    try {
      final wishlists = await wishlistRepository.getAllUserWishlist();
      return wishlists;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  void addWishlist() async {
    try {
      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        return;
      }

      if (!addWishlistFormKey.currentState!.validate()) {
        return;
      }

      var wishlist = WishlistModel(
          id: '',
          title: titleController.text,
          description: subtitleController.text,
          listIds: [],
          uploadTime: DateTime.now());

      final id = await WishlistRepository.instance
          .addAndFindIdForNewWishlist(wishlist);
      wishlist.id = id;
      refreshWishlistData.toggle();

      resetForm();
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  void addOrRemoveProductInWishlist(
      String wishlistId, List<String> listIds) async {
    try {
      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        return;
      }
      await WishlistRepository.instance
          .updateWishlistField(wishlistId, {'ListIds': listIds});
      refreshWishlistItemData.toggle();
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  void addToCart(List<ProductModel> list) {
    final cartController = Get.put(CartController());
    for (var element in list) {
      final cartProduct = cartController.convertToCartProduct(element, 1);
      cartController.addSingleProductInCart(cartProduct);
    }
  }

  void checkAddWishList(List<ProductModel> list, bool check) {
    final cartController = Get.put(CartController());
    if (!check) {
      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thêm vào danh sách mong ước'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Có vẻ bạn chưa thêm các sản phẩm trong Giỏ hàng vào danh sách mong ước. Bạn có muốn tiếp tục điều đó không?',
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hGreyColorShade600),
                  ),
                ]),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  cartController.clearCart();
                  addToCart(list);
                },
                child: Text(
                  'Có',
                  style: HAppStyle.label4Bold
                      .copyWith(color: HAppColor.hBluePrimaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                  cartController.clearCart();
                  addToCart(list);
                },
                child: Text(
                  'Không',
                  style:
                      HAppStyle.label4Bold.copyWith(color: HAppColor.hRedColor),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Get.back();
      cartController.clearCart();
      addToCart(list);
    }
  }
}
