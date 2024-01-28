import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootController extends GetxController {
  static RootController get instance => Get.find();

  var currentPage = 0.obs;

  final screenController = PageController();

  animateToScreen(int index) {
    currentPage.value = index;
    screenController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
