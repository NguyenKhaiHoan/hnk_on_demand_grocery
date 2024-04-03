import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/repositories/address_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class StoreMenu extends StatelessWidget {
  const StoreMenu({super.key, required this.model});

  final StoreModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final store =
            await StoreRepository.instance.getStoreInformation(model.id);
        final address =
            await AddressRepository.instance.getStoreAddress(model.id);
        final stringAddress = address.first.toString();
        Get.toNamed(HAppRoutes.storeDetail,
            arguments: {'model': store, 'address': stringAddress});
      },
      child: Column(children: [
        Container(
          width: 90,
          height: 80,
          decoration: BoxDecoration(
              color: HAppColor.hWhiteColor,
              borderRadius: BorderRadius.circular(10)),
          child: ImageNetwork(
            image: model.storeImage,
            height: 80,
            width: 90,
            duration: 500,
            curve: Curves.easeIn,
            onPointer: true,
            debugPrint: false,
            fullScreen: false,
            fitAndroidIos: BoxFit.cover,
            fitWeb: BoxFitWeb.cover,
            borderRadius: BorderRadius.circular(10),
            onLoading: CustomShimmerWidget.rectangular(
              height: 80,
              width: 90,
            ),
            onError: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ),
        gapH4,
        Text(
          model.name,
          maxLines: 1,
          style: HAppStyle.paragraph3Regular
              .copyWith(overflow: TextOverflow.ellipsis),
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}

class ShimmerStoreMenu extends StatelessWidget {
  const ShimmerStoreMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomShimmerWidget.rectangular(
        height: 90,
        width: 80,
      ),
      gapH4,
      CustomShimmerWidget.rectangular(
        height: 8,
        width: 10,
      )
    ]);
  }
}
