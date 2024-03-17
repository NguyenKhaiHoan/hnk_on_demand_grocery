import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';

class SearchProductController extends GetxController {
  static SearchProductController get instance => Get.find();

  final TextEditingController controller = TextEditingController();
  var historySearch = [].obs;

  var showSuffixIcon = false.obs;
  var showFilter = false.obs;

  removeHistorySearch(int index) {
    historySearch.removeAt(index);
    update();
  }

  removeAllHistorySearch() {
    historySearch.clear();
    update();
  }

  addHistorySearch() {
    if (controller.text.isNotEmpty) {
      historySearch.add(controller.text);
    }
    update();
  }

  var resultProduct = <ProductModel>[].obs;

  var productInSearch = <String, List<ProductModel>>{}.obs;

  addListProductInSearch(List<ProductModel> list) {
    resultProduct.value = list
        .where((product) =>
            product.name.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
    update();
  }

  addMapProductInSearch() {
    productInSearch.clear();
    for (var product in resultProduct) {
      if (!productInSearch.containsKey(product.storeId)) {
        productInSearch.addAll({
          product.storeId: List.from(resultProduct
              .where((productIsInSearch) =>
                  productIsInSearch.storeId == product.storeId)
              .toList())
        });
      } else {
        productInSearch.update(
            product.storeId,
            (value) => List.from(resultProduct
                .where((productIsInSearch) =>
                    productIsInSearch.storeId == product.storeId)
                .toList()));
      }
      update();
    }
    update();
  }
}
