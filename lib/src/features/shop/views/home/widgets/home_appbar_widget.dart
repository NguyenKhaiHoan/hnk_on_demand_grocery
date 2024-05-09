import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HomeAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  HomeAppbarWidget({super.key});

  final userController = UserController.instance;
  final addressController = AddressController.instance;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: HAppSize.deviceWidth - 24 - 24 - 40 - 40,
      toolbarHeight: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: hAppDefaultPadding),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(HAppRoutes.allAddress);
                },
                child: const Row(
                  children: [
                    Icon(
                      EneftyIcons.location_bold,
                      color: HAppColor.hBluePrimaryColor,
                    ),
                    gapW6,
                    Text(
                      "Giao tới",
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
              ),
              gapH4,
              Obx(() {
                if (userController.isSetAddressDeliveryTo.value) {
                  return CustomShimmerWidget.rectangular(
                    height: 10,
                    width: 100,
                  );
                }
                return FutureBuilder(
                    key: Key(
                        'Addresses${addressController.toggleRefresh.value.toString()}'),
                    future: addressController.fetchAllUserAddresses(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CustomShimmerWidget.rectangular(
                          height: 10,
                          width: 100,
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Đã xảy ra sự cố. Không thể tìm thấy vị trí.',
                            style: HAppStyle.paragraph3Regular,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        // userController.fetchCurrentPosition();
                        return CustomShimmerWidget.rectangular(
                          height: 10,
                          width: 100,
                        );
                      } else {
                        final addresses = snapshot.data!;
                        AddressModel address = addresses.firstWhere(
                            (address) => address.selectedAddress,
                            orElse: () => addresses.first);
                        return Text(
                          address.toString(),
                          style: HAppStyle.paragraph3Regular,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    }));
              }),
            ]),
      ),
      actions: [
        UserImageLogoWidget(
          size: 40,
          hasFunction: true,
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
