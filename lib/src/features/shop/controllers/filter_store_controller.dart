import 'package:get/get.dart';

class FilterStoreController extends GetxController {
  static FilterStoreController get instance => Get.find();

  var checkApplied = false.obs;
}
