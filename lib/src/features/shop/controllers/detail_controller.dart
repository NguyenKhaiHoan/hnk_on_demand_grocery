import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

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

  // var countText = "1".obs;

  // void setCount(ProductModel model) {
  //   countText.value = model.quantity != 0 ? "${model.quantity}" : '1';
  // }

  // changeCount(String operator) {
  //   int count;
  //   if (operator == "+") {
  //     count = int.parse(countText.value) + 1;
  //     countText.value = count.toString();
  //   } else {
  //     if (int.parse(countText.value) > 1) {
  //       count = int.parse(countText.value) - 1;
  //       countText.value = count.toString();
  //     }
  //   }
  // }

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
