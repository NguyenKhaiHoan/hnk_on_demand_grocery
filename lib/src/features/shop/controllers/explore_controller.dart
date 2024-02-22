import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ExploreController get instance => Get.find();

  late TabController tabController;
  late ScrollController scrollController;

  final showFab = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 14);
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
