import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ExploreController get instance => Get.find();

  late TabController tabController;
  late ScrollController scrollController;

  final showFab = false.obs;
  var isLoading = false.obs;
  var isLoadingAdd = false.obs;
  var index = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 20);
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

  void scrollToTop() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
  }
}
