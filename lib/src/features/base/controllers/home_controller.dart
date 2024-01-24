import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final CarouselController controller = CarouselController();
  var currentIndex = 0.obs;

  var reminder = true.obs;

  onPageChanged(int index) {
    currentIndex.value = index;
    update();
  }

  closeReminder() {
    reminder.value = false;
    update();
  }

  openReminder() {
    reminder.value = true;
    update();
  }
}
