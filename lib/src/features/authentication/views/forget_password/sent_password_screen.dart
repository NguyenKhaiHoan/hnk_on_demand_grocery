import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_infomation_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/forget_password_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class SentPasswordScreen extends StatefulWidget {
  const SentPasswordScreen({super.key});

  @override
  State<SentPasswordScreen> createState() => _SentPasswordScreenState();
}

class _SentPasswordScreenState extends State<SentPasswordScreen> {
  final String email = Get.arguments['email'];

  final forgetPasswordController = ForgetPasswordController.instance;

  @override
  Widget build(BuildContext context) {
    return CustomLayoutInformationScreenWidget(
        action: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(EvaIcons.close),
          ),
          gapW12
        ],
        lottieImage: 'assets/animations/send_email_animation.json',
        title: 'Đặt lại mật khẩu',
        widget1: ElevatedButton(
          onPressed: () {
            Get.offAllNamed(HAppRoutes.login);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(HAppSize.deviceWidth * 0.5, 50),
            backgroundColor: HAppColor.hBluePrimaryColor,
          ),
          child: Text(
            "Đã xong",
            style: HAppStyle.label2Bold.copyWith(color: HAppColor.hWhiteColor),
          ),
        ),
        widget2: Text.rich(
          TextSpan(
            text: 'Không nhận được email? ',
            style: HAppStyle.paragraph3Regular
                .copyWith(color: HAppColor.hGreyColorShade600),
            children: [
              WidgetSpan(
                  child: GestureDetector(
                onTap: () => forgetPasswordController.resendEmail(),
                child: Text(
                  'Gửi lại.',
                  style: HAppStyle.paragraph3Regular
                      .copyWith(color: HAppColor.hBluePrimaryColor),
                ),
              ))
            ],
          ),
        ),
        subTitle:
            'Một email đã được tới $email với 1 đường dẫn để đặt lại mật khẩu của bạn. Nếu không nhận được email sau vài phút, hãy kiểm tra trong hòm thư spam của bạn.');
  }
}
