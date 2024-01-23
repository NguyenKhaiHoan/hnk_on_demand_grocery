import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HomeAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 300,
      toolbarHeight: 80,
      leading: const Padding(
        padding: EdgeInsets.only(left: hAppDefaultPadding),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    EneftyIcons.location_bold,
                    color: HAppColor.hBluePrimaryColor,
                  ),
                  gapW6,
                  Text(
                    "Nơi làm việc",
                    style: HAppStyle.heading5Style,
                  ),
                  gapW4,
                  Icon(
                    EvaIcons.arrowIosDownwardOutline,
                    size: 15,
                    color: HAppColor.hGreyColor,
                  ),
                ],
              ),
              gapH4,
              Text(
                "Đại học quốc gia Hà Nội, Cầu giấy",
                style: HAppStyle.paragraph3Regular,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
      ),
      actions: const [
        Padding(
          padding: hAppDefaultPaddingR,
          child: CartCircle(),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
