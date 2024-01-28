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
      leadingWidth: HAppSize.deviceWidth - 24 - 24 - 40 - 40,
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
                    "Nhà",
                    style: HAppStyle.heading4Style,
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
                "Số nhà 25, Ngõ 143, Đường Chiến Thắng, Xã Tân Triều, Huyện Thanh Trì, Hà Nội",
                style: HAppStyle.paragraph3Regular,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
      ),
      actions: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: const DecorationImage(
                image: AssetImage('assets/logos/logo.png'), fit: BoxFit.fill),
          ),
        ),
        gapW10,
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
