import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  var listOder = <OrderModel>[].obs;
}
