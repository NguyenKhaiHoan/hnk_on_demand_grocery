import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static WishlistController get instance => Get.find();

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 4);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  animateToTab(int index) {
    tabController.animateTo(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
