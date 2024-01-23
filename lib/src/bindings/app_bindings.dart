import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding/on_boarding_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/home/home_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/notification/notification_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/profile/profile_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/root/root_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/wishlist/wishlist_screen.dart';

class HAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => const OnboardingScreen(), fenix: true);
    Get.lazyPut(() => const RootScreen(), fenix: true);
    Get.lazyPut(() => const HomeScreen(), fenix: true);
    Get.lazyPut(() => const WishlistScreen(), fenix: true);
    Get.lazyPut(() => const NotificationScreen(), fenix: true);
    Get.lazyPut(() => const ProfileScreen(), fenix: true);
  }
}
