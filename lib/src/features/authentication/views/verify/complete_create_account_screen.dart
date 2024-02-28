import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_infomation_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CompleteCreateAccountScreen extends StatelessWidget {
  const CompleteCreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayoutInformationScreenWidget(
        lottieImage: 'assets/animations/complete_checkout.json',
        title: 'Tạo tài khoản thành công!',
        widget1: ElevatedButton(
          onPressed: () {
            AuthenticationRepository.instance.screenRedirect();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(HAppSize.deviceWidth * 0.5, 50),
            backgroundColor: HAppColor.hBluePrimaryColor,
          ),
          child: Text(
            "Tiếp tục",
            style: HAppStyle.label2Bold.copyWith(color: HAppColor.hWhiteColor),
          ),
        ),
        widget2: Container(),
        subTitle:
            'Tài khoản của bạn đã được tạo thành công, hãy đăng nhập tài khoản để phám phá những điều hay ho nhé');
  }
}
