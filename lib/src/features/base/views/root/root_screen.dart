import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/base/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/base/views/explore/explore_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/home/home_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/notification/notification_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/profile/profile_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/root/widgets/bottom_nav_bar.dart';
import 'package:on_demand_grocery/src/features/base/views/wishlist/wishlist_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const WishlistScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  final rootController = Get.put(RootController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: rootController.screenController,
          children: screens,
        ),
        bottomNavigationBar: Container(
          color: HAppColor.hTransparentColor,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: BottomNavBar(),
        ),
      ),
    );
  }
}
