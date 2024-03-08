import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_infomation_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class NoDeliverScreen extends StatefulWidget {
  const NoDeliverScreen({super.key});

  @override
  State<NoDeliverScreen> createState() => _NoDeliverScreenState();
}

class _NoDeliverScreenState extends State<NoDeliverScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutInformationScreenWidget(
        lottieImage: 'assets/animations/no_delivery_animation.json',
        title: 'Xin lỗi, chúng tôi không giao hàng tại vị trí của bạn.',
        widget1: ElevatedButton(
          onPressed: () {
            AuthenticationRepository.instance.screenRedirect();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: HAppColor.hBluePrimaryColor,
              fixedSize: Size(HAppSize.deviceWidth, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Text("Đặt lại vị trí",
              style:
                  HAppStyle.label2Bold.copyWith(color: HAppColor.hWhiteColor)),
        ),
        widget2: Container(),
        subTitle:
            'Hiện tại, chúng tôi chỉ phục vụ trong địa bàn Thành phố Hà Nội. Nếu vị trí hiện tại của bạn không đúng, hãy đặt lại vị trí của bạn');
  }
}
