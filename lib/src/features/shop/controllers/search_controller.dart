import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';

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

  var productInSearch = <String, RxList<ProductModel>>{}.obs;

  addListProductInSearch(List<ProductModel> list) {
    resultProduct.value = list
        .where((product) =>
            product.name.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
    update();
    print("Vào");
  }

  addMapProductInCart() {
    productInSearch.clear();
    for (var product in resultProduct) {
      if (!productInSearch.containsKey(product.nameStore)) {
        productInSearch.addAll({
          product.nameStore: RxList.from(resultProduct
              .where((productIsInSearch) =>
                  productIsInSearch.nameStore == product.nameStore)
              .toList())
        });
      } else {
        productInSearch.update(
            product.nameStore,
            (value) => RxList.from(resultProduct
                .where((productIsInSearch) =>
                    productIsInSearch.nameStore == product.nameStore)
                .toList()));
      }
      update();
    }
    update();
  }
}
