import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var reminder = false.obs;

  closeReminder() {
    reminder.value = false;
    update();
  }

  openReminder() {
    reminder.value = true;
    update();
  }
}
