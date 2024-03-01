import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:shimmer/shimmer.dart';

class UserImageLogoWidget extends StatelessWidget {
  UserImageLogoWidget({
    super.key,
    required this.size,
  });

  final userController = Get.put(UserController());
  final rootController = Get.put(RootController());

  final double size;

  @override
  Widget build(BuildContext context) {
    return Obx(() => userController.isLoading.value
        ? const Center(
            child:
                CircularProgressIndicator(color: HAppColor.hBluePrimaryColor),
          )
        : userController.user.value.profileImage == ''
            ? GestureDetector(
                onTap: () => rootController.animateToScreen(4),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/logos/logo.png'),
                  ),
                ))
            : GestureDetector(
                onTap: () => rootController.animateToScreen(4),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(userController.user.value.profileImage),
                  ),
                )));
  }
}
