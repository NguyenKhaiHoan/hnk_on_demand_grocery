import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class SectionProfileWidget extends StatelessWidget {
  SectionProfileWidget({
    super.key,
    required this.title,
    required this.title2,
    required this.showIcon,
    this.function,
    required this.isSubLoading,
  });

  final userController = UserController.instance;
  final bool isSubLoading;
  final String title2;
  final Function()? function;
  final bool showIcon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: HAppStyle.paragraph2Bold
                .copyWith(color: HAppColor.hGreyColorShade600),
          ),
        ),
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerRight,
            child: Obx(() => userController.isLoading.value || isSubLoading
                ? CustomShimmerWidget.rectangular(height: 8)
                : Text(
                    title2,
                    style: HAppStyle.paragraph2Regular,
                    textAlign: TextAlign.right,
                  )),
          ),
        ),
        showIcon
            ? title == 'Id'
                ? Row(
                    children: [
                      gapW6,
                      GestureDetector(
                        onTap: function,
                        child: const Icon(
                          EvaIcons.copyOutline,
                          size: 20,
                        ),
                      )
                    ],
                  )
                : Row(
                    children: [
                      gapW6,
                      GestureDetector(
                        onTap: function,
                        child: const Icon(
                          EvaIcons.arrowIosForwardOutline,
                          size: 20,
                        ),
                      )
                    ],
                  )
            : Container()
      ],
    );
  }
}
