import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
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

  calculatingDifference(ProductModel product1, int product2Price) {
    if (product1.salePersent == 0) {
      int result = product1.price - product2Price;
      return result >= 0
          ? result == 0
              ? "= ${DummyData.vietNamCurrencyFormatting(result)}"
              : "> ${DummyData.vietNamCurrencyFormatting(result)}"
          : "< ${DummyData.vietNamCurrencyFormatting(result)}";
    } else {
      int result = product1.priceSale - product2Price;
      return result >= 0
          ? result == 0
              ? "= ${DummyData.vietNamCurrencyFormatting(result)}"
              : "> ${DummyData.vietNamCurrencyFormatting(result)}"
          : "< ${DummyData.vietNamCurrencyFormatting(result)}";
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
