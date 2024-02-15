import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  static WishlistController get instance => Get.find();

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
}
