import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/login_controller.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/on_boarding_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/search_controller.dart';

class HAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController(), fenix: true);
    Get.lazyPut(() => RootController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => DetailController(), fenix: true);
    // Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => SearchProductController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => ExploreController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
  }
}
