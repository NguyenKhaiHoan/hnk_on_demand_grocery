import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_infomation_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/verify_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final String email = Get.arguments['email'];

  final verifyController = Get.put(VerifyController());

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
        title: 'Xác thực email của bạn',
        widget1: Container(),
        widget2: Text.rich(
          TextSpan(
            text: 'Không nhận được email? ',
            style: HAppStyle.paragraph3Regular
                .copyWith(color: HAppColor.hGreyColorShade600),
            children: [
              WidgetSpan(
                  child: GestureDetector(
                onTap: () => verifyController.sendEmailVerification(),
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
            'Một email đã được tới $email với 1 đường dẫn để xác thực tài khoản của bạn. Nếu không nhận được email sau vài phút, hãy kiểm tra trong hòm thư spam của bạn.');
  }
}
