import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_name_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_password_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_phone_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/views/profile/profile_screen.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/banner_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/chat_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/date_delivery_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/filter_store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/explore_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/home_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/root/gesture_detector_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/root/widgets/bottom_nav_bar.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/list_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/store_all_screen.dart';
import 'package:on_demand_grocery/src/services/location_service.dart';
import 'package:on_demand_grocery/src/services/messaging_service.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const ListScreen(),
    const AllStoreScreen(),
    const ProfileScreen(),
  ];

  final _messagingService = HNotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HLocationService.getNearbyStoresAndProducts();
    });
    _messagingService.init(context);
  }

  final rootController = RootController.instance;
  final storeController = Get.put(StoreController());
  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetectorScreen(
            screen: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: rootController.screenController,
              children: screens,
            ),
            Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Container(
                  color: HAppColor.hTransparentColor,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: const BottomNavBar(),
                ))
          ],
        )),
      ),
    );
  }
}
