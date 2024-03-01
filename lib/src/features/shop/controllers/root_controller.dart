import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootController extends GetxController {
  static RootController get instance => Get.find();

  var currentPage = 0.obs;

  late PageController screenController;

  @override
  void onInit() {
    super.onInit();
    screenController = PageController();
  }

  @override
  void dispose() {
    screenController.dispose();
    super.dispose();
  }

  animateToScreen(int index) {
    currentPage.value = index;
    screenController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }
}
