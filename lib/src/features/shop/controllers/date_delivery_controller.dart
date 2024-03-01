import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateDeliveryController extends GetxController {
  static DateDeliveryController get instance => Get.find();

  var currentDateSelectedIndex = 0.obs;
  var selectedDate = DateTime.now().add(const Duration(days: 0)).obs;
  var date = ''.obs;
}
