import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_name_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:shimmer/shimmer.dart';

class IsLoadingUserNameWidget extends StatelessWidget {
  IsLoadingUserNameWidget({
    super.key,
    required this.widget,
  });

  final changeNameController = ChangeNameController.instance;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Obx(() => changeNameController.isLoading.value
        ? const Center(
            child:
                CircularProgressIndicator(color: HAppColor.hBluePrimaryColor),
          )
        : widget);
  }
}
