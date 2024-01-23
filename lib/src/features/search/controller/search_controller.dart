import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProductController extends GetxController {
  static SearchProductController get instance => Get.find();

  final TextEditingController controller = TextEditingController();
  var historySearch = [].obs;

  removeHistorySearch(int index) {
    historySearch.removeAt(index);
    update();
  }

  removeAllHistorySearch() {
    historySearch.clear();
    update();
  }

  addHistorySearch() {
    historySearch.add(controller.text);
    update();
  }
}
