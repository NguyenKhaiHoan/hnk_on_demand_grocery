import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';

class DeliveryPersonController extends GetxController {
  static DeliveryPersonController get instance => Get.find();

  var deliveryPerson = DeliveryPersonModel.empty().obs;
}
