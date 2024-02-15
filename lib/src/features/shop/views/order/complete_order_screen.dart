import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CompleteCheckoutScreen extends StatefulWidget {
  const CompleteCheckoutScreen({super.key});

  @override
  State<CompleteCheckoutScreen> createState() => _CompleteCheckoutScreenState();
}

class _CompleteCheckoutScreenState extends State<CompleteCheckoutScreen> {
  final rootController = Get.put(RootController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: hAppDefaultPaddingLR,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/gif/complete_checkout.json',
                height: 300, reverse: true, repeat: true, fit: BoxFit.cover),
            gapH20,
            const Text(
              'Bạn đã đặt hàng thành công!',
              style: HAppStyle.heading2Style,
              textAlign: TextAlign.center,
            ),
            gapH10,
            const Text(
              'Đơn hàng của bạn đã được đặt và bạn sẽ có thể nhận được hàng sớm nhất.',
              style: HAppStyle.paragraph1Regular,
              textAlign: TextAlign.center,
            ),
            gapH40,
            OutlinedButton(
                onPressed: () {
                  Get.offAllNamed(HAppRoutes.root);
                  rootController.animateToScreen(0);
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(HAppSize.deviceWidth * 0.5, 50),
                    backgroundColor: HAppColor.hBackgroundColor,
                    side: BorderSide(
                        width: 2, color: HAppColor.hGreyColorShade300)),
                child: const Text(
                  "Tiếp tục Mua sắm",
                  style: HAppStyle.label2Bold,
                )),
            gapH12,
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(HAppSize.deviceWidth * 0.5, 50),
                backgroundColor: HAppColor.hBluePrimaryColor,
              ),
              child: Text(
                "Theo dõi Đơn hàng",
                style:
                    HAppStyle.label2Bold.copyWith(color: HAppColor.hWhiteColor),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
