import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class VoucherWidget extends StatelessWidget {
  VoucherWidget({
    super.key,
  });

  final cartController = CartController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(HAppRoutes.voucher),
      child: Row(
        children: [
          const Icon(
            Icons.discount_outlined,
            color: HAppColor.hBluePrimaryColor,
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Áp dụng mã ưu đãi",
                    style: HAppStyle.paragraph1Bold),
                Obx(
                  () => cartController.voucherAppliedTextAppear!.value &&
                          cartController.applied.value
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            cartController.voucherAppliedText.value,
                            style: HAppStyle.paragraph3Regular.copyWith(
                              color: HAppColor.hBluePrimaryColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        )
                      : Text("Bạn đang có 1 mã ưu đãi.",
                          style: HAppStyle.paragraph3Regular.copyWith(
                              color: HAppColor.hRedColor,
                              decoration: TextDecoration.none)),
                )
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 12,
          )
        ],
      ),
    );
  }
}
