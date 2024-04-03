import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/banner_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
import 'package:on_demand_grocery/src/repositories/banner_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class DeliveryPersonController extends GetxController {
  static DeliveryPersonController get instance => Get.find();

  var deliveryPerson = DeliveryPersonModel.empty().obs;
}
