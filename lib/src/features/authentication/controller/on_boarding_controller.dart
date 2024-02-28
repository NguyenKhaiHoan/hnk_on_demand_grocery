import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final controller = LiquidController();

  var buttonText = "".obs;
  var skipText = "".obs;
  var loadingArrow = false.obs;

  var containerWidth = 0.0.obs;

  var currentPage = 0.obs;

  void skipPage() {
    controller.jumpToPage(page: 2);
    update();
  }

  void onPageChangedCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
    if (activePageIndex == 2) {
      containerWidth.value = 140;
      Timer(const Duration(milliseconds: 1100), () {
        buttonText.value = "Đăng nhập";
        loadingArrow.value = true;
        update();
      });
    } else {
      containerWidth.value = 0;
      Timer(const Duration(milliseconds: 1100), () {
        buttonText.value = "";
        loadingArrow.value = false;
      });
    }
  }

  void nextToLoginScreen() {
    final storage = GetStorage();
    storage.write('isFirstTime', false);
    Get.offAllNamed(HAppRoutes.login);
  }
}
