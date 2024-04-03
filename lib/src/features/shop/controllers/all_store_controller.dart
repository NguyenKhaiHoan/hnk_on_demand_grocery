import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class AllStoreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static AllStoreController get instance => Get.find();

  var selfCategory = false.obs;
  var selectedValueSort = 'A - Z'.obs;
  var checkApplied = false.obs;

  var tagsCategoryObs = <Tag>[].obs;

  var tagsStoreObs = <Tag>[].obs;

  var listFilterStore = <StoreModel>[].obs;

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
