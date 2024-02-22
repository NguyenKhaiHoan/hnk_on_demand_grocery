import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();

  final DraggableScrollableController dragController =
      DraggableScrollableController();

  late ScrollController scrollController;

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

  var countText = "1".obs;

  void setCount(ProductModel model) {
    countText.value = model.quantity != 0 ? "${model.quantity}" : '1';
  }

  changeCount(String operator) {
    int count;
    if (operator == "+") {
      count = int.parse(countText.value) + 1;
      countText.value = count.toString();
    } else {
      if (int.parse(countText.value) > 1) {
        count = int.parse(countText.value) - 1;
        countText.value = count.toString();
      }
    }
  }

  calculatingDifference(ProductModel product1, String product2Price) {
    if (product1.salePersent == "") {
      int result =
          (int.parse(product1.price.substring(0, product1.price.length - 5))) -
              (int.parse(product2Price.substring(0, product2Price.length - 5)));
      return result >= 0
          ? result == 0
              ? "= ${result.abs()}"
              : "> ${result.abs()}"
          : "< ${result.abs()}";
    } else {
      int result = (int.parse(
              product1.priceSale.substring(0, product1.priceSale.length - 5))) -
          (int.parse(product2Price.substring(0, product2Price.length - 5)));
      return result >= 0
          ? result == 0
              ? "= ${result.abs()}"
              : "> ${result.abs()}"
          : "< ${result.abs()}";
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
    return "${parts[1]}.000₫";
  }
}
