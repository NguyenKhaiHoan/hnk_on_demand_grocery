import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';

class StoreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static StoreController get instance => Get.find();

  var selfCategory = false.obs;

  var listFilterStore = <StoreModel>[].obs;

  var isFavoritedStores = <StoreModel>[].obs;

  addStoreInFavorited(StoreModel store) {
    if (isFavoritedStores.contains(store)) {
      isFavoritedStores.remove(store);
    } else {
      isFavoritedStores.add(store);
    }
    update();
  }

  late TabController tabController;
  late ScrollController scrollController;

  final showAppBar = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3);
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  animateToTab(int index) {
    tabController.animateTo(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
