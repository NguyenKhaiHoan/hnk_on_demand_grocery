import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();

  final DraggableScrollableController dragController =
      DraggableScrollableController();

  late ScrollController scrollController;

  var currentProductDetail = ProductModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  var showAppBar = false.obs;

  changeShowAppBar(bool value) {
    showAppBar.value = value;
  }

  var showNameInAppBar = false.obs;

  changeShowNameInAppBar(bool value) {
    showNameInAppBar.value = value;
  }

  var tempProductInCart = ProductInCartModel.empty();
  final cartController = Get.put(CartController());

  // Future<void> fetchTempProductInCart(ProductModel product) async {
  //   try {
  //     tempProductInCart = await cartController.convertToCartProduct(product, 1);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  void showLargeImage(String image) {
    Get.to(
        () => Dialog.fullscreen(
              child: Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  bottomOpacity: 0,
                  toolbarHeight: 80,
                  backgroundColor: HAppColor.hTransparentColor,
                ),
                body: Center(
                  child: ImageNetwork(
                    image: image,
                    height: HAppSize.deviceHeight * 0.5,
                    width: HAppSize.deviceWidth,
                    duration: 500,
                    curve: Curves.easeIn,
                    onPointer: true,
                    debugPrint: false,
                    fullScreen: false,
                    fitAndroidIos: BoxFit.cover,
                    fitWeb: BoxFitWeb.cover,
                    onLoading: const CircularProgressIndicator(
                      color: HAppColor.hBluePrimaryColor,
                    ),
                    onError: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
        fullscreenDialog: true);
  }
}
