import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();

  var dragController = DraggableScrollableController();
  var number = 0.0.obs;

  var showAppBar = false.obs;

  changeShowAppBar(bool value) {
    showAppBar.value = value;
  }

  var showNameInAppBar = false.obs;

  changeShowNameInAppBar(bool value) {
    showNameInAppBar.value = value;
  }

  var count = 1.obs;

  changeCount(String operator) {
    if (operator == "+") {
      count++;
    } else {
      if (count > 1) {
        count--;
      }
    }
  }

  calculatingDifference(ProductModel product1, String product2Price) {
    if (product1.salePersent == "") {
      return (int.parse(
                      product1.price.substring(0, product1.price.length - 5))) -
                  (int.parse(
                      product2Price.substring(0, product2Price.length - 5))) >
              0
          ? "Lớn hơn"
          : "Nhỏ hơn";
    } else {
      return (int.parse(product1.priceSale
                      .substring(0, product1.priceSale.length - 5))) -
                  (int.parse(
                      product2Price.substring(0, product2Price.length - 5))) >
              0
          ? "Lớn hơn"
          : "Nhỏ hơn";
    }
  }
}
