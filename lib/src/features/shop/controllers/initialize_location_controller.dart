import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';

class InitializeLocationController extends GetxController {
  static InitializeLocationController get instance => Get.find();

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  void getLocation() async {
    try {
      var address = AddressController.instance.selectedAddress.value;
      latitude.value = address.latitude;
      longitude.value = address.longitude;
    } catch (e) {
      print(e);
    }
  }
}
